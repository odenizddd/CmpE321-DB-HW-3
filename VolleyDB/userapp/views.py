from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.template import loader
from django.db import connection

def login(request):

    username = request.GET.get("username")
    password = request.GET.get("password")

    if username == None or password == None:
        return render(request, 'login.html')

    with connection.cursor() as cursor:
        for user in ["DatabaseManager","Player", "Jury", "Coach"]:
            query = f"SELECT * FROM {user} WHERE username='{username}' AND password='{password}'"
            cursor.execute(query)
            row = cursor.fetchone()
            if row != None:
                return redirect(f"/{user}/{username}")
            
    return render(request, 'login.html')

def databaseManager(request, username):
    return render(request, 'DatabaseManager.html')

def player(request, username):
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
    return render(request, 'Player.html', {"players": players, "height": height[0][0]})

def jury(request, username):
    if (request.GET.get("rating") != None):
        rating = request.GET.get("rating")
        session_ID = request.GET.get("session")
        with connection.cursor() as cursor:
            query = f"UPDATE MatchSession SET rating={rating} WHERE session_ID={session_ID}"
            cursor.execute(query)
            connection.commit()
    with connection.cursor() as cursor:
        query = f"""SELECT COUNT(rating), AVG(rating) FROM MatchSession MS LEFT JOIN Jury J ON J.username=MS.assigned_jury_username
                WHERE J.username="{username}" AND MS.rating IS NOT NULL;"""
        cursor.execute(query)
        data = cursor.fetchone()
        query = f"""SELECT MS.session_ID FROM MatchSession MS
                    WHERE MS.assigned_jury_username="{username}" AND MS.rating IS NULL AND STR_TO_DATE(MS.date, "%d.%m.%Y")<NOW();"""
        cursor.execute(query)
        not_rated = cursor.fetchall()
    return render(request, 'Jury.html', {"rating_count": data[0], "rating_average": data[1], "not_rated": [row[0] for row in not_rated]}) 

def coach(request, username):
    return render(request, 'Coach.html')

def addPlayer(request):
    if (request.GET.get("name") != None):
        username = request.GET.get("username")
        password = request.GET.get("password")
        name = request.GET.get("name")
        surname = request.GET.get("surname")
        y, m, d = request.GET.get("date_of_birth").split("-")
        date_of_birth = f"{d}.{m}.{y}"
        height = request.GET.get("height")
        weight = request.GET.get("weight")
        positions = request.GET.getlist("position")
        teams = request.GET.getlist("team")

        with connection.cursor() as cursor:
            query = f"INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('{username}', '{password}', '{name}', '{surname}', '{date_of_birth}', {height}, {weight})"
            cursor.execute(query)
            connection.commit()

        with connection.cursor() as cursor:
            query = "INSERT INTO PlayerPositions (username, position) VALUES (%s, %s)"
            cursor.executemany(query, [(username, position) for position in positions])
            connection.commit()

        with connection.cursor() as cursor:
            query = "INSERT INTO PlayerTeams (username, team) VALUES (%s, %s)"
            cursor.executemany(query, [(username, team) for team in teams])
            connection.commit()

        return redirect("/DatabaseManager")
    with connection.cursor() as cursor:
        query = f"SELECT team_ID FROM Team"
        cursor.execute(query)
        rows = cursor.fetchall()
    return render(request, 'AddPlayer.html', {"teams": [row[0] for row in rows]})

def addCoach(request):
    if (request.GET.get("name") != None):
        username = request.GET.get("username")
        password = request.GET.get("password")
        name = request.GET.get("name")
        surname = request.GET.get("surname")
        nationality = request.GET.get("nationality")

        with connection.cursor() as cursor:
            query = f"INSERT INTO Coach (username, password, name, surname, nationality) VALUES ('{username}', '{password}', '{name}', '{surname}', '{nationality}')"
            cursor.execute(query)
            connection.commit()

        return redirect("/DatabaseManager")
    return render(request, 'AddCoach.html')

def addJury(request):
    if (request.GET.get("name") != None):
        username = request.GET.get("username")
        password = request.GET.get("password")
        name = request.GET.get("name")
        surname = request.GET.get("surname")
        nationality = request.GET.get("nationality")

        with connection.cursor() as cursor:
            query = f"INSERT INTO Jury (username, password, name, surname, nationality) VALUES ('{username}', '{password}', '{name}', '{surname}', '{nationality}')"
            cursor.execute(query)
            connection.commit()

        return redirect("/DatabaseManager")
    return render(request, 'AddJury.html')

def changeStadiumName(request):
    if (request.GET.get("newname") != None):
        oldname = request.GET.get("oldname")
        newname = request.GET.get("newname")
        with connection.cursor() as cursor:
            query = f"UPDATE Stadium SET stadium_name='{newname}' WHERE stadium_name='{oldname}'"
            cursor.execute(query)
            connection.commit()
        return redirect("/DatabaseManager")
    with connection.cursor() as cursor:
        query = f"SELECT stadium_name FROM Stadium"
        cursor.execute(query)
        rows = cursor.fetchall()
    return render(request, 'ChangeStadiumName.html', {"stadiums": [row[0] for row in rows]})