DROP DATABASE IF EXISTS VolleyDB;
CREATE DATABASE VolleyDB;
USE VolleyDB;

CREATE TABLE DatabaseManager (
	username	VARCHAR(512),
    password	VARCHAR(512),
    PRIMARY KEY (username)
);

CREATE TABLE Player 
(
    username	VARCHAR(512),
    password	VARCHAR(512),
    name	VARCHAR(512),
    surname	VARCHAR(512),
    date_of_birth	VARCHAR(512),
    height	INT,
    weight	INT,
    PRIMARY KEY (username)
);

CREATE TABLE PlayerPositions 
(
    player_positions_id	INT,
    username	VARCHAR(512),
    position	INT NOT NULL,
    PRIMARY KEY (player_positions_id),
    FOREIGN KEY (username) REFERENCES Player(username),
    UNIQUE (username, position)
);

CREATE TABLE Coach 
(
    username	VARCHAR(512),
    password	VARCHAR(512),
    name	VARCHAR(512),
    surname	VARCHAR(512),
    nationality	VARCHAR(512),
    PRIMARY KEY (username)
);

CREATE TABLE Channel (
	channel_ID	INT,
    channel_name	VARCHAR(512),
    PRIMARY KEY (channel_ID),
    UNIQUE (channel_name)
);

CREATE TABLE Team 
(
    team_ID	INT,
    team_name	VARCHAR(512),
    coach_username	VARCHAR(512) NOT NULL,
    contract_start	VARCHAR(512),
    contract_finish	VARCHAR(512),
    channel_ID	INT NOT NULL,
    PRIMARY KEY (team_ID),
    FOREIGN KEY (coach_username) REFERENCES Coach(username),
    FOREIGN KEY (channel_ID) REFERENCES Channel(channel_ID)
);

CREATE TABLE PlayerTeams 
(
    player_teams_id	INT,
    username	VARCHAR(512) NOT NULL,
    team	INT NOT NULL,
    PRIMARY KEY (player_teams_id),
    FOREIGN KEY (username) REFERENCES Player(username),
    FOREIGN KEY (team) REFERENCES Team(team_ID)
);

CREATE TABLE `Position`
(
    position_ID	INT,
    position_name	VARCHAR(512),
    PRIMARY KEY (position_ID)
);

CREATE TABLE Jury 
(
    username	VARCHAR(512),
    password	VARCHAR(512),
    name	VARCHAR(512),
    surname	VARCHAR(512),
    nationality	VARCHAR(512),
    PRIMARY KEY (username)
);

CREATE TABLE Stadium (
	stadium_ID	INT,
    stadium_name	VARCHAR(512),
    stadium_country	VARCHAR(512),
    PRIMARY KEY (stadium_ID)
);

CREATE TABLE MatchSession 
(
    session_ID	INT,
    team_ID	INT NOT NULL,
    stadium_ID	INT NOT NULL,
    time_slot	INT,
    date	VARCHAR(512),
    assigned_jury_username	VARCHAR(512) NOT NULL,
    rating	DOUBLE,
    PRIMARY KEY (session_ID),
    FOREIGN KEY (team_ID) REFERENCES Team(team_ID),
    FOREIGN KEY (stadium_ID) REFERENCES Stadium(stadium_ID) ON UPDATE CASCADE,
    FOREIGN KEY (assigned_jury_username) REFERENCES Jury(username)
);

CREATE TABLE SessionSquads 
(
    squad_ID	INT,
    session_ID	INT,
    played_player_username	VARCHAR(512),
    position_ID	INT,
    PRIMARY KEY (squad_ID),
    FOREIGN KEY (session_ID) REFERENCES MatchSession(session_ID) ON DELETE CASCADE,
    FOREIGN KEY (played_player_username) REFERENCES Player(username),
    FOREIGN KEY (position_ID) REFERENCES `Position`(position_ID),
    UNIQUE (session_ID, played_player_username)
);

INSERT INTO DatabaseManager (username, password) VALUES ("Kevin", "Kevin");
INSERT INTO DatabaseManager (username, password) VALUES ("Bob", "Bob");
INSERT INTO DatabaseManager (username, password) VALUES ("sorunlubirarkadas", "muvaffakiyetsizleştiricileştiriveremeyebileceklerimizdenmişsinizcesine");
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('g_orge', 'Go.1993', 'Gizem ', 'Örge', '26/04/1993', '170', '59');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('c_ozbay', 'Co.1996', 'Cansu ', 'Özbay', '17/10/1996', '182', '78');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('m_vargas', 'Mv.1999', 'Melissa ', 'Vargas', '16/10/1999', '194', '76');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('h_baladin', 'Hb.2007', 'Hande ', 'Baladın', '01/09/2007', '190', '81');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('a_kalac', 'Ak.1995', 'Aslı ', 'Kalaç', '13/12/1995', '185', '73');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('ee_dundar', 'Eed.2008', 'Eda Erdem ', 'Dündar', '22/06/2008', '188', '74');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('z_gunes', 'Zg.2008', 'Zehra ', 'Güneş', '07/07/2008', '197', '88');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('i_aydin', 'Ia.2007', 'İlkin ', 'Aydın', '05/01/2007', '183', '67');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('e_sahin', 'Es.2001', 'Elif ', 'Şahin', '19/01/2001', '190', '68');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('e_karakurt', 'Ek.2006', 'Ebrar ', 'Karakurt', '17/01/2006', '196', '73');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('s_akoz', 'Sa.1991', 'Simge ', 'Aköz', '23/04/1991', '168', '55');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('k_akman', 'Ka.2006', 'Kübra ', 'Akman', '13/10/2006', '200', '88');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('d_cebecioglu', 'Dc.2007', 'Derya ', 'Cebecioğlu', '24/10/2007', '187', '68');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('a_aykac', 'Aa.1996', 'Ayşe ', 'Aykaç', '27/02/1996', '176', '57');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_2826', 'P.45825', 'Brenda', 'Schulz', '13/12/2002', '193', '80');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_9501', 'P.99695', 'Erika', 'Foley', '21/12/1995', '164', '62');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_3556', 'P.49595', 'Andrea', 'Campbell', '26/4/1996', '185', '100');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_7934', 'P.24374', 'Beatrice', 'Bradley', '28/5/1997', '150', '57');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_4163', 'P.31812', 'Betsey', 'Lenoir', '7/5/1993', '156', '48');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_2835', 'P.51875', 'Martha', 'Lazo', '20/5/2001', '173', '71');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_8142', 'P.58665', 'Wanda', 'Ramirez', '3/1/1994', '183', '94');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_2092', 'P.16070', 'Eileen', 'Ryen', '21/6/2004', '188', '60');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_3000', 'P.73005', 'Stephanie', 'White', '19/5/2002', '193', '74');
INSERT INTO Player (username, password, name, surname, date_of_birth, height, weight) VALUES ('user_8323', 'P.33562', 'Daenerys', 'Targaryen', '16/9/2006', '222', '74');
INSERT INTO Jury (username, password, name, surname, nationality) VALUES ('o_ozcelik', 'ozlem.0347', 'Özlem', 'Özçelik', 'TR');
INSERT INTO Jury (username, password, name, surname, nationality) VALUES ('m_sevinc', 'mehmet.0457', 'Mehmet', 'Sevinç', 'TR');
INSERT INTO Jury (username, password, name, surname, nationality) VALUES ('e_sener', 'ertem.4587', 'Ertem', 'Şener', 'TR');
INSERT INTO Jury (username, password, name, surname, nationality) VALUES ('s_engin', 'sinan.6893', 'Sinan', 'Engin', 'TR');
INSERT INTO Position (position_ID, position_name) VALUES ('0', 'Libero');
INSERT INTO Position (position_ID, position_name) VALUES ('1', 'Setter');
INSERT INTO Position (position_ID, position_name) VALUES ('2', 'Opposite hitter');
INSERT INTO Position (position_ID, position_name) VALUES ('3', 'Outside hitter');
INSERT INTO Position (position_ID, position_name) VALUES ('4', 'Middle blocker');
INSERT INTO Coach (username, password, name, surname, nationality) VALUES ('d_santarelli', 'santa.really1', 'Daniele ', 'Santarelli', 'ITA');
INSERT INTO Coach (username, password, name, surname, nationality) VALUES ('g_guidetti', 'guidgio.90', 'Giovanni ', 'Guidetti', 'ITA');
INSERT INTO Coach (username, password, name, surname, nationality) VALUES ('f_akbas', 'a.fatih55', 'Ferhat ', 'Akbaş', 'TR');
INSERT INTO Coach (username, password, name, surname, nationality) VALUES ('m_hebert', 'm.hebert45', 'Mike', 'Hebert', 'US');
INSERT INTO Coach (username, password, name, surname, nationality) VALUES ('o_deriviere', 'oliviere_147', 'Oliviere', 'Deriviere', 'FR');
INSERT INTO Coach (username, password, name, surname, nationality) VALUES ('a_derune', 'aderune_147', 'Amicia', 'DeRune', 'FR');
INSERT INTO Channel (channel_ID, channel_name) VALUES ('0','BeIN Sports');
INSERT INTO Channel (channel_ID, channel_name) VALUES ('1','Digiturk');
INSERT INTO Channel (channel_ID, channel_name) VALUES ('2','TRT');
INSERT INTO Team (team_ID, team_name, coach_username, contract_start, contract_finish, channel_ID) VALUES ('0', 'Women A', 'd_santarelli', '25.12.2021', '12.12.2025', '0');
INSERT INTO Team (team_ID, team_name, coach_username, contract_start, contract_finish, channel_ID) VALUES ('1', 'Women B', 'g_guidetti', '11.09.2021', '11.09.2026', '1');
INSERT INTO Team (team_ID, team_name, coach_username, contract_start, contract_finish, channel_ID) VALUES ('2', 'U19', 'f_akbas', '10.08.2021', '10.08.2026', '0');
INSERT INTO Team (team_ID, team_name, coach_username, contract_start, contract_finish, channel_ID) VALUES ('3', 'Women B', 'f_akbas', '10.08.2000', '10.08.2015', '1');
INSERT INTO Team (team_ID, team_name, coach_username, contract_start, contract_finish, channel_ID) VALUES ('4', 'Women C', 'm_hebert', '01.04.2024', '21.07.2026', '1');
INSERT INTO Team (team_ID, team_name, coach_username, contract_start, contract_finish, channel_ID) VALUES ('5', 'U19', 'o_deriviere', '10.08.2015', '09.08.2020', '2');
INSERT INTO Team (team_ID, team_name, coach_username, contract_start, contract_finish, channel_ID) VALUES ('6', 'U19', 'a_derune', '10.08.2005', '10.08.2010', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('1', 'g_orge', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('2', 'c_ozbay', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('3', 'c_ozbay', '1');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('4', 'm_vargas', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('5', 'm_vargas', '1');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('6', 'h_baladin', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('7', 'h_baladin', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('8', 'a_kalac', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('9', 'a_kalac', '1');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('10', 'ee_dundar', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('11', 'ee_dundar', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('12', 'z_gunes', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('13', 'z_gunes', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('14', 'i_aydin', '1');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('15', 'i_aydin', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('16', 'e_sahin', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('17', 'e_karakurt', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('18', 'e_karakurt', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('19', 's_akoz', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('20', 's_akoz', '1');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('21', 'k_akman', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('22', 'k_akman', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('23', 'd_cebecioglu', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('24', 'd_cebecioglu', '1');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('25', 'a_aykac', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('26', 'user_2826', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('27', 'user_2826', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('28', 'user_9501', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('29', 'user_9501', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('30', 'user_3556', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('31', 'user_3556', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('32', 'user_7934', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('33', 'user_7934', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('34', 'user_4163', '1');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('35', 'user_4163', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('36', 'user_2835', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('37', 'user_2835', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('38', 'user_8142', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('39', 'user_8142', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('40', 'user_2092', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('41', 'user_2092', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('42', 'user_3000', '2');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('43', 'user_3000', '3');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('44', 'user_8323', '0');
INSERT INTO PlayerTeams (player_teams_id, username, team) VALUES ('45', 'user_8323', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('1', 'g_orge', '0');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('2', 'g_orge', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('3', 'c_ozbay', '1');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('4', 'm_vargas', '2');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('5', 'h_baladin', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('6', 'a_kalac', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('7', 'ee_dundar', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('8', 'z_gunes', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('9', 'i_aydin', '1');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('10', 'i_aydin', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('11', 'e_sahin', '1');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('12', 'e_sahin', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('13', 'e_karakurt', '2');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('14', 'e_karakurt', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('15', 's_akoz', '0');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('16', 'k_akman', '0');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('17', 'k_akman', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('18', 'd_cebecioglu', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('19', 'd_cebecioglu', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('20', 'a_aykac', '0');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('21', 'user_2826', '2');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('22', 'user_2826', '1');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('23', 'user_9501', '0');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('24', 'user_9501', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('25', 'user_3556', '1');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('26', 'user_3556', '0');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('27', 'user_7934', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('28', 'user_7934', '2');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('29', 'user_4163', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('30', 'user_4163', '0');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('31', 'user_2835', '2');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('32', 'user_2835', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('33', 'user_8142', '1');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('34', 'user_8142', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('35', 'user_2092', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('36', 'user_2092', '2');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('37', 'user_3000', '1');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('38', 'user_3000', '4');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('39', 'user_8323', '3');
INSERT INTO PlayerPositions (player_positions_id, username, position) VALUES ('40', 'user_8323', '2');
INSERT INTO Stadium (stadium_ID, stadium_name, stadium_country) VALUES ('0', 'Burhan Felek Voleybol Salonu', 'TR');
INSERT INTO Stadium (stadium_ID, stadium_name, stadium_country) VALUES ('1', 'GD Voleybol Arena', 'TR');
INSERT INTO Stadium (stadium_ID, stadium_name, stadium_country) VALUES ('2', 'Copper Box Arena', 'UK');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('0', '0', '0', '1', '10.03.2024', 'o_ozcelik', '4.5');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('1', '1', '1', '1', '03.04.2024', 'o_ozcelik', '4.9');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('2', '0', '1', '3', '03.04.2024', 'o_ozcelik', '4.4');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('3', '2', '2', '2', '03.04.2024', 'm_sevinc', '4.9');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('4', '3', '2', '2', '03.04.2023', 'e_sener', '4.5');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('5', '3', '1', '1', '27.05.2023', 's_engin', '4.4');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('6', '0', '1', '1', '01.09.2022', 'm_sevinc', '4.6');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('7', '0', '2', '3', '02.05.2023', 'o_ozcelik', '4.7');
INSERT INTO MatchSession (session_ID, team_ID, stadium_ID, time_slot, date, assigned_jury_username, rating) VALUES ('8', '1', '0', '1', '10.03.2024', 'o_ozcelik', '4.5');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('1', '0', 'g_orge', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('2', '0', 'c_ozbay', '1');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('3', '0', 'm_vargas', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('4', '0', 'h_baladin', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('5', '0', 'a_kalac', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('6', '0', 'ee_dundar', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('7', '1', 'c_ozbay', '1');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('8', '1', 'm_vargas', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('9', '1', 'i_aydin', '1');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('10', '1', 'a_kalac', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('11', '1', 's_akoz', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('12', '1', 'd_cebecioglu', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('13', '2', 'g_orge', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('14', '2', 'm_vargas', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('15', '2', 'c_ozbay', '1');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('16', '2', 'a_kalac', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('17', '2', 's_akoz', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('18', '2', 'a_aykac', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('19', '3', 'ee_dundar', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('20', '3', 'h_baladin', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('21', '3', 'z_gunes', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('22', '3', 'i_aydin', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('23', '3', 'e_karakurt', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('24', '3', 'k_akman', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('25', '4', 'user_2826', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('26', '4', 'user_9501', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('27', '4', 'user_3556', '1');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('28', '4', 'user_7934', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('29', '4', 'user_4163', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('30', '4', 'user_2835', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('31', '5', 'user_2826', '1');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('32', '5', 'user_9501', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('33', '5', 'user_3556', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('34', '5', 'user_7934', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('35', '5', 'user_4163', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('36', '5', 'user_2835', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('37', '6', 'g_orge', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('38', '6', 'm_vargas', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('39', '6', 'c_ozbay', '1');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('40', '6', 'a_kalac', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('41', '6', 'e_karakurt', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('42', '6', 'a_aykac', '0');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('43', '7', 'g_orge', '3');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('44', '7', 'm_vargas', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('45', '7', 'c_ozbay', '1');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('46', '7', 'a_kalac', '4');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('47', '7', 'e_karakurt', '2');
INSERT INTO SessionSquads (squad_ID, session_ID, played_player_username, position_ID) VALUES ('48', '7', 'a_aykac', '0');

DELIMITER //

CREATE TRIGGER before_player_insert
BEFORE INSERT ON Player
FOR EACH ROW
BEGIN
	DECLARE manager_count INT;
    
    SELECT COUNT(*) INTO manager_count FROM DatabaseManager DM WHERE DM.username = NEW.username;
    
    IF manager_count > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists in the managers table';
    END IF;
END;
//

CREATE TRIGGER before_jury_insert
BEFORE INSERT ON Jury
FOR EACH ROW
BEGIN
	DECLARE manager_count INT;
    
    SELECT COUNT(*) INTO manager_count FROM DatabaseManager DM WHERE DM.username = NEW.username;
    
    IF manager_count > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists in the managers table';
    END IF;
END;
//

CREATE TRIGGER before_coach_insert
BEFORE INSERT ON Coach
FOR EACH ROW
BEGIN
	DECLARE manager_count INT;
    
    SELECT COUNT(*) INTO manager_count FROM DatabaseManager DM WHERE DM.username = NEW.username;
    
    IF manager_count > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists in the managers table';
    END IF;
END;
//

CREATE TRIGGER before_session_squads_insert
BEFORE INSERT ON SessionSquads
FOR EACH ROW
BEGIN
	DECLARE overlap_count INT; -- timeslot
    DECLARE illegal_pos_count INT;
    
    SELECT COUNT(*) INTO overlap_count 
    FROM SessionSquads SS, MatchSession MS_OLD, MatchSession MS_NEW
    WHERE SS.played_player_username=NEW.played_player_username AND MS_OLD.session_ID=SS.session_ID AND MS_NEW.session_ID=NEW.session_ID
    AND MS_NEW.date=MS_OLD.date AND (
    (ABS(MS_OLD.time_slot-MS_NEW.time_slot) < 2 OR MS_NEW.time_slot > 3 OR MS_NEW.time_slot < 1) -- Timeslot overlap
    
    );
    
    SELECT COUNT(*) INTO illegal_pos_count
    FROM PlayerPositions PP
    WHERE PP.username=NEW.played_player_username AND PP.position=NEW.position_ID;
    
    IF overlap_count > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This player is already playing in this timeslot.';
    END IF;
    
    IF illegal_pos_count != 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This player cannot play in this position.';
    END IF;
    
END;
//

CREATE TRIGGER before_match_session_update
BEFORE UPDATE ON MatchSession
FOR EACH ROW
BEGIN

	DECLARE unrated_match_count INT;
    
    SELECT COUNT(*) INTO unrated_match_count
    FROM MatchSession MS
    WHERE NEW.session_ID = MS.session_ID AND MS.rating IS NULL;

    IF unrated_match_count = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Juries cannot edit their ratings.';
    END IF;
END;
//

CREATE TRIGGER before_match_session_insert
BEFORE INSERT ON MatchSession
FOR EACH ROW
BEGIN
	DECLARE overlap_count INT; -- timeslot or stadium
    
    SELECT COUNT(*) INTO overlap_count 
    FROM MatchSession MS
    WHERE MS.date=NEW.date AND (
    (ABS(MS.time_slot - NEW.time_slot) < 2 OR NEW.time_slot > 3 OR NEW.time_slot < 1)
    AND
    MS.stadium_ID=NEW.stadium_ID
    );
    
    IF overlap_count > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Match sessions cannot overlap in terms of timeslot or stadium.';
    END IF;
    
END;
//

CREATE TRIGGER before_database_manager_insert
BEFORE INSERT ON DatabaseManager
FOR EACH ROW
BEGIN

	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You cannot add a new database manager.';
    
END;
//

CREATE TRIGGER before_team_insert
BEFORE INSERT ON Team
FOR EACH ROW
BEGIN

	DECLARE total_count INT;
	DECLARE available_count INT; -- contract dates
    
    IF STR_TO_DATE(NEW.contract_start, "%d.%m.%Y") > STR_TO_DATE(NEW.contract_finish, "%d.%m.%Y") THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Contract start must be before contract finish.';
    END IF;
    
    SELECT COUNT(*) INTO total_count
    FROM Team T
    WHERE T.coach_username=NEW.coach_username;
    
    
    SELECT COUNT(*) INTO available_count 
    FROM Team T
    WHERE T.coach_username=NEW.coach_username AND
    (
		STR_TO_DATE(NEW.contract_finish, "%d.%m.%Y") < STR_TO_DATE(T.contract_start, "%d.%m.%Y")
    OR
		STR_TO_DATE(NEW.contract_start, "%d.%m.%Y") > STR_TO_DATE(T.contract_finish, "%d.%m.%Y")
    );
    
    IF total_count != available_count THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This coach is already coaching another team during that time.';
    END IF;
    
END;
//

DELIMITER ;