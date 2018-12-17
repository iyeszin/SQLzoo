--In which we join two tables; game and goals.

--1. Modify it to show the matchid and player name for all goals scored by Germany. 
SELECT matchid, player FROM goal 
  WHERE teamid like 'GER'

--2. Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game
where id = 1012

--3. Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
  FROM game, goal 
where game.id=goal.matchid and goal.teamid='GER'

--4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
select team1, team2, player
from game, goal
where player like 'Mario%' and game.id=goal.matchid

--5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
  FROM goal, eteam
 WHERE gtime<=10 and goal.teamid=eteam.id

--6. List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
select mdate, teamname
from game, eteam
where coach='Fernando Santos' and team1=eteam.id

--7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
select player
from game,goal
where stadium='National Stadium, Warsaw' and game.id=goal.matchid

--====================================================================

--8. Instead show the name of all players who scored a goal against Germany.
SELECT distinct goal.player
  FROM game, goal
    WHERE goal.matchid = game.id and goal.teamid!='GER'
and (game.team1='GER' or game.team2='GER')

--9. Show teamname and the total number of goals scored.
SELECT teamname, count(gtime)
  FROM eteam JOIN goal ON id=teamid
group by teamname
 ORDER BY teamname

--10. Show the stadium and the number of goals scored in each stadium. 
select stadium, count(gtime)
from game, goal
where game.id=goal.matchid
group by game.stadium

--11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid,mdate, count(*)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
group by goal.matchid, game.mdate

--12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid,mdate,COUNT(gtime) 
FROM game,goal
WHERE game.id = goal.matchid AND teamid = 'GER' GROUP BY matchid,mdate

--13. List every match with the goals scored by each team as shown. 
SELECT game.mdate,
  game.team1,
  sum(CASE WHEN goal.teamid=team1 THEN 1 ELSE 0 END) as score1,
  game.team2,
  sum(CASE WHEN goal.teamid=team2 THEN 1 ELSE 0 END) as score2
  FROM game LEFT JOIN goal ON goal.matchid = game.id
group by game.id, game.mdate, game.team1, game.team2
order by game.mdate, goal.matchid, team1, team2