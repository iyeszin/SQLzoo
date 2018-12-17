--In which we join actors to movies in the Movie Database.

--1. List the films where the yr is 1962 [Show id, title] 
SELECT id, title
 FROM movie
 WHERE yr=1962

--2. Give year of 'Citizen Kane'. 
select yr
from movie
where title='Citizen Kane'

--3. List all of the Star Trek movies, include the id, title and yr. Order results by year. 
select id, title, yr
from movie
where title like '%star trek%'
order by yr

--4. What id number does the actor 'Glenn Close' have? 
select id
from actor
where name='Glenn Close' 

--5. What is the id of the film 'Casablanca' 
select id
from movie
where title='Casablanca' 

--6. Obtain the cast list for 'Casablanca'. 
select actor.name
from actor, casting
where casting.actorid=actor.id and casting.movieid=11768 

--7. Obtain the cast list for the film 'Alien' 
select actor.name
from actor, casting, movie
where casting.actorid=actor.id and casting.movieid=movie.id and movie.title='Alien' 

--8. List the films in which 'Harrison Ford' has appeared 
select movie.title
from actor, casting, movie
where casting.actorid=actor.id and casting.movieid=movie.id and actor.name='Harrison Ford'

--9. List the films where 'Harrison Ford' has appeared - but not in the starring role.
select movie.title
from actor, casting, movie
where casting.actorid=actor.id and casting.movieid=movie.id and actor.name='Harrison Ford' and casting.ord<>1

--10. List the films together with the leading star for all 1962 films. 
select movie.title, actor.name
from actor, casting, movie
where casting.actorid=actor.id and casting.movieid=movie.id and movie.yr=1962 and casting.ord=1

--================================================

--11. Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies. 
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)

--12. List the film title and the leading actor for all of the films 'Julie Andrews' played in. 
SELECT movie.title, actor.name FROM casting, movie, actor
WHERE movieid IN (
  SELECT movieid FROM casting, actor
  WHERE casting.actorid=actor.id and actor.name='Julie Andrews')
and casting.movieid=movie.id and casting.actorid=actor.id and casting.ord=1

--13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles. 
select actor.name
from actor, casting
where casting.actorid=actor.id and casting.ord=1
group by actor.name having count(*)>=30

--14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title. 
select movie.title, count(casting.actorid)
from movie, casting
where movie.yr=1978 and casting.movieid=movie.id
group by movie.title
order by count(*) desc, movie.title

--15. List all the people who have worked with 'Art Garfunkel'. 
select actor.name
from actor, casting
where casting.actorid=actor.id and 
movieid in (select movieid from casting, actor
where casting.actorid=actor.id and actor.name='Art Garfunkel')
and actor.name!='Art Garfunkel'
group by actor.name