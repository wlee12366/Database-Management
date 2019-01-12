

# Imported tables with import wizard using data in "data-sql_import" folder

# PER -- Player Efficiency Rating
# 	A measure of per-minute production standardized such that the league average is 15.

# WS/48 -- Win Shares Per 48 Minutes
#	An estimate of the number of wins contributed by a player per 48 minutes (league average is approximately .100)

# OBPM -- Offensive Box Plus/Minus
#	A box score estimate of the offensive points per 100 possessions a player contributed above a league-average player, translated to an average team.
# DBPM -- Defensive Box Plus/Minus
#	A box score estimate of the defensive points per 100 possessions a player contributed above a league-average player, translated to an average team.


# Khris Middleton - Wing, Milwaukee Bucks, age 27
# 	Mid-volume scorer, high efficiency and quality D 2nd or 3rd option

CREATE OR REPLACE VIEW Middleton as   
    SELECT salaries.player, salaries.salary, salaries.salary_scale, salaries.age, 
    	history_nba.season, history_nba.per, history_nba.ws_per_48, history_nba.pts
    FROM salaries, history_nba
    WHERE salaries.player = history_nba.player and salaries.season = history_nba.season and 
    	history_nba.per > 16 and history_nba.per < 20 and history_nba.ws_per_48 > .125 and 
    	history_nba.ws_per_48 < .150 and history_nba.pts > 1500 and history_nba.pts < 2000 and 
        salaries.age > 25 and salaries.age < 29
    ORDER BY history_nba.season Desc;

# Jimmy Butler - Wing, Philadelphia 76ers, age 29
#	High-volume scorer, elite D, some injury / age concerns (games missed)

CREATE OR REPLACE VIEW Butler as   
    SELECT salaries.player, salaries.salary, salaries.salary_scale, salaries.age, 
    	history_nba.season, history_nba.per, history_nba.ws_per_48, round((history_nba.pts / history_nba.games),2) as PPG
    FROM salaries, history_nba
    WHERE salaries.player = history_nba.player and salaries.season = history_nba.season and 
    	history_nba.per > 20 and history_nba.per < 23 and 
    	history_nba.ws_per_48 > .170 and history_nba.ws_per_48 < .2 and 
    	(history_nba.pts / history_nba.games) > 19.5 and (history_nba.pts / history_nba.games) < 24 and 
        salaries.age > 27 and salaries.age < 32
    ORDER BY history_nba.season Desc;


# Tobias Harris - Wing / Forward, LA Clippers, age 26
#	Versatile scorer, not known for Defense. Playing unusually well this year.

CREATE OR REPLACE VIEW TobiasHarris as   
    SELECT salaries.player, salaries.salary, salaries.salary_scale, salaries.age, 
    	history_nba.season, history_nba.per, history_nba.obpm, history_nba.dbpm, round((history_nba.pts / history_nba.games),2) as PPG
    FROM salaries, history_nba
    WHERE salaries.player = history_nba.player and salaries.season = history_nba.season and 
    	history_nba.per > 16 and history_nba.per < 22 and 
    	history_nba.obpm > 1.8 and history_nba.obpm < 2.8 and 
    	history_nba.dbpm > -0.3 and history_nba.dbpm < .2 and
    	(history_nba.pts / history_nba.games) > 16 and (history_nba.pts / history_nba.games) < 24 and 
        salaries.age > 24 and salaries.age < 29
    ORDER BY history_nba.season Desc;

# Marcus Morris - Wing / Forward, Boston Celtics, age 29
#	Versatile scorer, not known for Defense. Playing unusually well this year.

CREATE OR REPLACE VIEW MarcusMorris as   
    SELECT salaries.player, salaries.salary, salaries.salary_scale, salaries.age, 
    	history_nba.season, history_nba.per, history_nba.obpm, history_nba.dbpm, round((history_nba.pts / history_nba.games),2) as PPG
    FROM salaries, history_nba
    WHERE salaries.player = history_nba.player and salaries.season = history_nba.season and 
    	history_nba.per > 11 and history_nba.per < 17 and 
    	history_nba.obpm > -0.4 and history_nba.obpm < 0.4 and 
    	history_nba.dbpm > -0.7 and history_nba.dbpm < 0.0 and
    	(history_nba.pts / history_nba.games) > 12 and (history_nba.pts / history_nba.games) < 17 and 
        salaries.age > 26 and salaries.age < 32
    ORDER BY history_nba.season Desc;

# Try again with OWS and DWS - much better. Ilyasova is a good comp and just signed for 3 yrs / $21mm last summer

CREATE OR REPLACE VIEW MarcusMorris_ws as   
    SELECT salaries.player, salaries.salary, salaries.salary_scale, salaries.age, 
    	history_nba.season, history_nba.per, history_nba.ows, history_nba.dws, round((history_nba.pts / history_nba.games),2) as PPG
    FROM salaries, history_nba
    WHERE salaries.player = history_nba.player and salaries.season = history_nba.season and 
    	history_nba.per > 11 and history_nba.per < 17 and 
    	history_nba.ows > 1.3 and history_nba.ows < 2.8 and 
    	history_nba.dws > 1.8 and history_nba.dws < 2.8 and
    	(history_nba.pts / history_nba.games) > 12 and (history_nba.pts / history_nba.games) < 17 and 
        salaries.age > 26 and salaries.age < 32
    ORDER BY history_nba.season Desc;

# Danny Green - Wing, Toronto Raptors, age 31
#	3 and D wing, ageing...

CREATE OR REPLACE VIEW DannyGreen as   
    SELECT salaries.player, salaries.salary, salaries.salary_scale, salaries.age, 
    	history_nba.season, history_nba.per, history_nba.dws,
    	round((history_nba.three_pointers_attempted / history_nba.games),2) as ThreePG,
        history_nba.three_point_perc,
    	round((history_nba.pts / history_nba.games),2) as PPG
    FROM salaries, history_nba
    WHERE salaries.player = history_nba.player and salaries.season = history_nba.season and 
    	history_nba.per > 9.5 and history_nba.per < 14 and 
    	history_nba.dws > 2.5 and
    	history_nba.three_point_perc > .35 and history_nba.three_point_perc < .425 and
        (history_nba.three_pointers_attempted / history_nba.games) > 2 and
    	(history_nba.pts / history_nba.games) > 7 and (history_nba.pts / history_nba.games) < 14 and 
        salaries.age > 29 and salaries.age < 36
    ORDER BY history_nba.season Desc;

# Nikola Mirotic - Big, New Orleans Pelicans, age 27
# 	Stretch big

CREATE OR REPLACE VIEW Mirotic as   
    SELECT salaries.player, salaries.salary, salaries.salary_scale, salaries.age, 
    	history_nba.season, history_nba.per, history_nba.obpm, history_nba.dbpm
    	round((history_nba.three_pointers_attempted / history_nba.games),2) as ThreePG,
        history_nba.three_point_perc,
    	round((history_nba.pts / history_nba.games),2) as PPG
    FROM salaries, history_nba
    WHERE salaries.player = history_nba.player and salaries.season = history_nba.season and 
    	history_nba.per > 15 and history_nba.per < 20 and 
    	history_nba.obpm > 1 and history_nba.obpm < 3 and
    	history_nba.dbpm > -1.5 and history_nba.dbpm < .5 and
    	history_nba.three_point_perc > .35 and
        (history_nba.three_pointers_attempted / history_nba.games) > 4 and
    	(history_nba.pts / history_nba.games) > 14 and (history_nba.pts / history_nba.games) < 20 and 
        salaries.age > 25 and salaries.age < 30
    ORDER BY history_nba.season Desc;

# How about with rebounds (to indicate position)?

CREATE OR REPLACE VIEW Mirotic_reb as   
    SELECT salaries.player, salaries.salary, salaries.salary_scale, salaries.age, 
    	history_nba.season, history_nba.per, history_nba.obpm, history_nba.dbpm,
    	round((history_nba.three_pointers_attempted / history_nba.games),2) as ThreePG,
        history_nba.three_point_perc,
    	round((history_nba.pts / history_nba.games),2) as PPG,
        history_nba.reb_perc
    FROM salaries, history_nba
    WHERE salaries.player = history_nba.player and salaries.season = history_nba.season and 
    	history_nba.per > 15 and history_nba.per < 20 and 
    	history_nba.obpm > 1 and history_nba.obpm < 3 and
    	history_nba.dbpm > -1.5 and history_nba.dbpm < .5 and
    	history_nba.three_point_perc > .35 and
        (history_nba.three_pointers_attempted / history_nba.games) > 4 and
    	(history_nba.pts / history_nba.games) > 14 and (history_nba.pts / history_nba.games) < 20 and 
        salaries.age > 25 and salaries.age < 30 and
        history_nba.reb_perc > 10
    ORDER BY history_nba.season Desc;



#### SPOOL 

# Get salaries table with position

set sqlformat csv
SPOOL /Users/Sam/Desktop/spool_salaries_detail.csv
SELECT * FROM(
SELECT salaries.player, salaries.salary, salaries.season, salaries.salary_proportion, salaries.salary_scale,
	salaries.age, history_nba.pos, history_nba.ws, history_nba.per
FROM salaries, history_nba
WHERE salaries.player = history_nba.player and salaries.season = history_nba.season
ORDER BY salaries.player);
spool off


















