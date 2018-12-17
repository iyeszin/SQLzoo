--In which we join Edinburgh bus routes to Edinburgh bus routes.

--1. How many stops are in the database
select count(id)
from stops

--2. Find the id value for the stop 'Craiglockhart' 
select id
from stops 
where name='Craiglockhart' 

--3. Give the id and the name for the stops on the '4' 'LRT' service. 
select stops.id, stops.name
from stops, route
where route.num=4
and route.company='LRT'
and stops.id=route.stop

--4. Add a HAVING clause to restrict the output to these two routes. 
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
having count(*)=2

--5. Change the query so that it shows the services from Craiglockhart to London Road. 
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 and b.stop=149

--6. Change the query so that the services between 'Craiglockhart' and 'London Road'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
and stopb.name='London Road' 

--7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') 
select distinct a.company, b.num
from route a, route b
where a.num=b.num
and a.stop=115
and b.stop=137

--8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' 
select a.company, b.num
from route a, route b, stops sa, stops sb
where a.num=b.num and sa.id=a.stop and sb.id=b.stop
and sa.name='Craiglockhart'
and sb.name='Tollcross'

--9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
--including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
select sa.name, a.company, a.num
from route a, route b, stops sa, stops sb
where a.num=b.num and sa.id=a.stop and sb.id=b.stop
and sb.name='Craiglockhart'
and a.company in ('bus', 'lrt')

--10. Find the routes involving two buses that can go from Craiglockhart to Sighthill.
--Show the bus no. and company for the first bus, the name of the stop for the transfer,
--and the bus no. and company for the second bus. 
SELECT DISTINCT S.num, S.company, stops.name, E.num, E.company
FROM
(SELECT a.company, a.num, b.stop
 FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
 WHERE a.stop=(SELECT id FROM stops WHERE name= 'Craiglockhart')
)S
JOIN
(SELECT a.company, a.num, b.stop
 FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
 WHERE a.stop=(SELECT id FROM stops WHERE name= 'Sighthill')
)E
ON (S.stop = E.stop)JOIN stops ON(stops.id = S.stop)
