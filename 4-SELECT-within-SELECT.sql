--In which we form queries using other queries.

--1. List each country name where the population is larger than that of 'Russia'. 
SELECT name FROM bbc
 WHERE population > ALL
       (SELECT MAX(population)
          FROM bbc
         WHERE region = 'Europe')
   AND region = 'South Asia'


--2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
select name from world
where continent='europe' and
gdp/population > (select gdp/population from world where name= 'United Kingdom')

--3. List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
select name, continent
from world
where continent in (select continent from world where name in ('Argentina','Australia'))
order by name

--4. Which country has a population that is more than Canada but less than Poland? Show the name and the population.
select name, population
from world
where population > (select population from world where name='Canada') 
and population < (select population from world where name='Poland') 

--5. Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
select name, concat(round(population/(select population from world where name='Germany')*100),'%') from world
where continent='europe'

--6. Which countries have a GDP greater than every country in Europe?
SELECT name
  FROM world
 WHERE gdp > ALL(SELECT gdp FROM world
                         WHERE gdp>0 and continent='Europe')

--7. Find the largest country (by area) in each continent, show the continent, the name and the area: 
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND population>0)

--8. List each continent and the name of the country that comes first alphabetically.
select continent, name
from world x
where name <= ALL(select name from world y
where y.continent=x.continent
order by name)

--9. Find the continents where all countries have a population <= 25000000. Show name, continent and population. 
select name, continent, population
from world x
where not exists (select * from world y
where x.continent=y.continent and population > 25000000)

--10. Some countries have populations more than three times that of any of their neighbours (in the same continent). 
--Give the countries and continents.
select name, continent
from world x
where population > ALL (select population*3 from world y
where x.continent=y.continent and population>0 and y.name != x.name)
