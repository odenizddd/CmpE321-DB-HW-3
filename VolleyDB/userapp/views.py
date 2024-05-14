from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.template import loader
from django.db import connection
import django.db.utils

def login(request):

    error = None

    username = request.GET.get("username")
    password = request.GET.get("password")

    if username == None or password == None:
        return render(request, 'login.html', {"error": error})

    try:
        with connection.cursor() as cursor:
            for user in ["DatabaseManager","Player", "Jury", "Coach"]:
                query = f"SELECT * FROM {user} WHERE username='{username}' AND password='{password}'"
                cursor.execute(query)
                row = cursor.fetchone()
                if row != None:
                    return redirect(f"/{user}/{username}")
    except django.db.utils.DatabaseError as e:
        error = e.__cause__
        print(error)
            
    return render(request, 'login.html', {"error": error})

def databaseManager(request, username):
    error = request.session.get("error")
    request.session['error'] = None
    return render(request, 'DatabaseManager.html', {"error": error})

def player(request, username):
    error = None

    try:
        with connection.cursor() as cursor:
            query = f"""SELECT Player.name, Player.surname FROM (SELECT played_player_username, COUNT(*) as play_count FROM (SELECT SS.played_player_username FROM  SessionSquads SS,  (SELECT session_ID, played_player_username FROM SessionSquads SS WHERE SS.played_player_username=\"{username}\") UserPlayed WHERE SS.played_player_username!=UserPlayed.played_player_username AND SS.session_ID=UserPlayed.session_ID) Teammates GROUP BY Teammates.played_player_username ORDER BY play_count DESC) PlayedCount LEFT JOIN Player ON PlayedCount.played_player_username=Player.username;"""
            cursor.execute(query)
            players = cursor.fetchall()
            query = f"""
                        SELECT AVG(P.height) FROM (SELECT * FROM (SELECT played_player_username, COUNT(*) as play_count FROM (SELECT SS.played_player_username FROM 
                        SessionSquads SS, 
                        (SELECT session_ID, played_player_username FROM SessionSquads SS WHERE SS.played_player_username="{username}") UserPlayed
                        WHERE SS.played_player_username!=UserPlayed.played_player_username AND SS.session_ID=UserPlayed.session_ID) Teammates
                        GROUP BY Teammates.played_player_username
                        ORDER BY play_count DESC) PlayedCount
                        WHERE PlayedCount.play_count=(SELECT MAX(play_count) FROM (SELECT played_player_username, COUNT(*) as play_count FROM (SELECT SS.played_player_username FROM 
                        SessionSquads SS, 
                        (SELECT session_ID, played_player_username FROM SessionSquads SS WHERE SS.played_player_username="{username}") UserPlayed
                        WHERE SS.played_player_username!=UserPlayed.played_player_username AND SS.session_ID=UserPlayed.session_ID) Teammates
                        GROUP BY Teammates.played_player_username
                        ORDER BY play_count DESC) PlayedCount)) MostPlayed LEFT JOIN Player P ON MostPlayed.played_player_username=P.username;
                    """
            cursor.execute(query)
            height = cursor.fetchall()
    except django.db.utils.DatabaseError as e:
        error = e.__cause__
        print(error)
    return render(request, 'Player.html', {"players": players, "height": height[0][0], "error": error})

def jury(request, username):
    error = None

    if (request.GET.get("rating") != None):
        rating = request.GET.get("rating")
        session_ID = request.GET.get("session")
        try:
            with connection.cursor() as cursor:
                query = f"UPDATE MatchSession SET rating={rating} WHERE session_ID={session_ID}"
                cursor.execute(query)
                connection.commit()
        except django.db.utils.DatabaseError as e:
            error = e.__cause__
            print(error)
    try:
        with connection.cursor() as cursor:
            query = f"""SELECT COUNT(rating), AVG(rating) FROM MatchSession MS LEFT JOIN Jury J ON J.username=MS.assigned_jury_username
                    WHERE J.username="{username}" AND MS.rating IS NOT NULL;"""
            cursor.execute(query)
            data = cursor.fetchone()
            query = f"""SELECT MS.session_ID FROM MatchSession MS
                        WHERE MS.assigned_jury_username="{username}" AND MS.rating IS NULL AND STR_TO_DATE(MS.date, "%d.%m.%Y")<NOW();"""
            cursor.execute(query)
            not_rated = cursor.fetchall()
    except django.db.utils.DatabaseError as e:
        error = e.__cause__
        print(error)
    return render(request, 'Jury.html', {"rating_count": data[0], "rating_average": data[1], "not_rated": [row[0] for row in not_rated], "error": error}) 

def coach(request, username):
    error = None

    if (request.GET.get("session_ID") != None):
        session_ID = request.GET.get("session_ID")
        players = request.GET.getlist("player")
        positions = [request.GET.get(f"position{i}") for i in range(1,7)]

        try:
            with connection.cursor() as cursor:
                query = "INSERT INTO SessionSquads (session_ID, played_player_username, position_ID) VALUES (%s, %s, %s);"
                cursor.executemany(query, [(session_ID, player, position) for (player, position) in zip(players, positions)])
                connection.commit()
        except django.db.utils.DatabaseError as e:
            error = e.__cause__
            print(error)

    if (request.GET.get("delete_ID") != None):
        delete_ID = request.GET.get("delete_ID")
        try:
            with connection.cursor() as cursor:
                query = "DELETE FROM MatchSession MS WHERE MS.session_ID=%s;"
                cursor.execute(query, (delete_ID,))
                connection.commit()
        except django.db.utils.DatabaseError as e:
            error = e.__cause__
            print(error)
    
    if (request.GET.get("stadium_ID") != None):
        stadium_ID = request.GET.get("stadium_ID")
        y, m, d = request.GET.get("date").split("-")
        date = f"{d}.{m}.{y}"
        slot = request.GET.get("slot")
        jury = request.GET.get("jury")
        team_ID = request.GET.get("team_ID")
        next_session_ID = request.GET.get("next_session_ID")

        try:
            with connection.cursor() as cursor:
                query = f"INSERT INTO MatchSession (session_ID, stadium_ID, date, time_slot, assigned_jury_username, team_ID, rating) VALUES ({next_session_ID}, {stadium_ID}, '{date}', {slot}, '{jury}', {team_ID}, NULL)"
                cursor.execute(query)
                connection.commit()
        except django.db.utils.DatabaseError as e:
            error = e.__cause__
            print(error)

    try:
        with connection.cursor() as cursor:
            query = f"""SELECT S.stadium_name, S.stadium_country, S.stadium_ID FROM Stadium S;"""
            cursor.execute(query)
            stadiums = cursor.fetchall()

            query = f"""SELECT MS.session_ID FROM MatchSession MS, Team T
                        WHERE T.coach_username="{username}" AND T.team_ID = MS.team_ID 
                        AND STR_TO_DATE(T.contract_start, "%d.%m.%Y") < NOW()
                        AND STR_TO_DATE(T.contract_finish, "%d.%m.%Y") > NOW();"""
            cursor.execute(query)
            directing_matches = cursor.fetchall()

            query = f"""SELECT T.team_ID FROM Team T
                        WHERE T.coach_username="{username}" 
                        AND STR_TO_DATE(T.contract_start, "%d.%m.%Y") < NOW()
                        AND STR_TO_DATE(T.contract_finish, "%d.%m.%Y") > NOW();"""
            cursor.execute(query)
            res = cursor.fetchone()
            if res:
                team_ID = res[0]
            else:
                team_ID = None

            query = f"""SELECT P.name, P.surname, P.username FROM Player P, PlayerTeams PT, Team T
                    WHERE T.coach_username = "{username}" AND T.team_ID = PT.team 
                    AND PT.username = P.username AND STR_TO_DATE(T.contract_start, "%d.%m.%Y") < NOW()
                    AND STR_TO_DATE(T.contract_finish, "%d.%m.%Y") > NOW();"""
            cursor.execute(query)
            available_players = cursor.fetchall()

            query = f"""SELECT J.username, J.name, J.surname FROM Jury J;"""
            cursor.execute(query)
            juries = cursor.fetchall()

            query = f"""SELECT MAX(session_ID) FROM MatchSession;"""
            cursor.execute(query)
            next_session_ID = cursor.fetchone()[0] + 1

            query = f"""SELECT MS.session_ID FROM Team T, MatchSession MS
                        WHERE T.coach_username="{username}" AND T.team_ID=MS.team_ID AND
                        MS.session_ID NOT IN (SELECT SS.session_ID FROM SessionSquads SS WHERE SS.session_ID=MS.session_ID);"""
            cursor.execute(query)
            not_squaded = cursor.fetchall()
    except django.db.utils.DatabaseError as e:
        error = e.__cause__
        print(error)

    return render(request, 'Coach.html', {"stadiums": stadiums, "available_players": available_players, "directing_matches": [match[0] for match in directing_matches], "juries": juries, "team_ID": team_ID, "next_session_ID": next_session_ID, "error": error, "not_squaded": [row[0] for row in not_squaded]})

def addPlayer(request, username):
    error = None

    if (request.GET.get("name") != None):
        player_username = request.GET.get("username")
        password = request.GET.get("password")
        name = request.GET.get("name")
        surname = request.GET.get("surname")
        y, m, d = request.GET.get("date_of_birth").split("-")
        date_of_birth = f"{d}.{m}.{y}"
        height = request.GET.get("height")
        weight = request.GET.get("weight")
        positions = request.GET.getlist("position")
        teams = request.GET.getlist("team")

        try:
            with connection.cursor() as cursor:
                query = f"INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('{player_username}', '{password}', '{name}', '{surname}', '{date_of_birth}', {height}, {weight})"
                cursor.execute(query)
                connection.commit()

            with connection.cursor() as cursor:
                query = "INSERT INTO PlayerPositions (username, position) VALUES (%s, %s)"
                cursor.executemany(query, [(player_username, position) for position in positions])
                connection.commit()

            with connection.cursor() as cursor:
                query = "INSERT INTO PlayerTeams (username, team) VALUES (%s, %s)"
                cursor.executemany(query, [(player_username, team) for team in teams])
                connection.commit()
        except django.db.utils.DatabaseError as e:
            error = e.__cause__
            print(error)
        if error:
            request.session['error'] = error.__str__()
        return redirect(f"/DatabaseManager/{username}")
    try:
        with connection.cursor() as cursor:
            query = f"SELECT team_ID FROM Team"
            cursor.execute(query)
            rows = cursor.fetchall()
    except django.db.utils.DatabaseError as e:
        error = e.__cause__
        print(error)
    return render(request, 'AddPlayer.html', {"teams": [row[0] for row in rows], "error": error})

def addCoach(request, username):
    error = None

    if (request.GET.get("name") != None):
        coach_username = request.GET.get("username")
        password = request.GET.get("password")
        name = request.GET.get("name")
        surname = request.GET.get("surname")
        nationality = request.GET.get("nationality")

        try:
            with connection.cursor() as cursor:
                query = f"INSERT INTO Coach (username, password, name, surname, nationality) VALUES ('{coach_username}', '{password}', '{name}', '{surname}', '{nationality}')"
                cursor.execute(query)
                connection.commit()
        except django.db.utils.DatabaseError as e:
            error = e.__cause__
            print(error)
        if error:
            request.session['error'] = error.__str__()
        return redirect(f"/DatabaseManager/{username}")
    return render(request, 'AddCoach.html', {"error": error})

def addJury(request, username):
    error = None

    if (request.GET.get("name") != None):
        jury_username = request.GET.get("username")
        password = request.GET.get("password")
        name = request.GET.get("name")
        surname = request.GET.get("surname")
        nationality = request.GET.get("nationality")

        try:
            with connection.cursor() as cursor:
                query = f"INSERT INTO Jury (username, password, name, surname, nationality) VALUES ('{jury_username}', '{password}', '{name}', '{surname}', '{nationality}')"
                cursor.execute(query)
                connection.commit()
        except django.db.utils.DatabaseError as e:
            error = e.__cause__
            print(error)

        if error:
            request.session['error'] = error.__str__()
        return redirect(f"/DatabaseManager/{username}")
    return render(request, 'AddJury.html', {"error": error})

def changeStadiumName(request, username):
    error = None

    if (request.GET.get("newname") != None):
        oldname = request.GET.get("oldname")
        newname = request.GET.get("newname")
        try:
            with connection.cursor() as cursor:
                query = f"UPDATE Stadium SET stadium_name='{newname}' WHERE stadium_name='{oldname}'"
                cursor.execute(query)
                connection.commit()
        except django.db.utils.DatabaseError as e:
            error = e.__cause__
            print(error)
        if error:
            request.session['error'] = error.__str__()
        return redirect(f"/DatabaseManager/{username}")
    try:
        with connection.cursor() as cursor:
            query = f"SELECT stadium_name FROM Stadium"
            cursor.execute(query)
            rows = cursor.fetchall()
    except django.db.utils.DatabaseError as e:
        error = e.__cause__
        print(error)
    return render(request, 'ChangeStadiumName.html', {"stadiums": [row[0] for row in rows], "error": error})