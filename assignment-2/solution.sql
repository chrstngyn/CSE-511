--1
CREATE TABLE query1 AS
SELECT g.name, count(1) as moviecount
FROM hasagenre
         JOIN genres g USING (genreid)
GROUP BY name;  

--2
CREATE TABLE query2 AS
SELECT g.name AS name, avg(rating) AS rating
FROM movies m
         JOIN hasagenre h USING (movieid)
         JOIN ratings r USING (movieid)
         JOIN genres g USING (genreid)
GROUP BY g.name;

--3
CREATE TABLE query3 AS
SELECT m.title, count(1) AS countofratings
FROM ratings
         JOIN movies m USING (movieid)
GROUP BY m.title
HAVING count(1) > 9;

--4
CREATE TABLE query4 AS
SELECT m.movieid AS movieid, m.title
FROM movies m
         JOIN hasagenre h USING (movieid)
         JOIN genres g USING (genreid)
WHERE g.name = 'Comedy';

--5
CREATE TABLE query5 AS
SELECT m.title, avg(rating) as average
FROM ratings r
         JOIN movies m USING (movieid)
GROUP BY m.title;

--6
CREATE TABLE query6 AS
SELECT avg(r.rating) AS average
FROM movies m
         JOIN ratings r USING (movieid)
         JOIN hasagenre h USING (movieid)
         JOIN genres g USING (genreid)
WHERE g.name = 'Comedy';

--7
CREATE TABLE query7 AS
SELECT avg(rating) as average
FROM ratings
        JOIN (SELECT movieid
			  FROM movies m
					JOIN hasagenre h USING (movieid)
					JOIN genres g USING (genreid)
			  WHERE g.name IN ('Romance', 'Comedy')
			  GROUP BY m.movieid
			  HAVING count(1) = 2) Y
		USING (movieid);
--8
CREATE TABLE query8 AS
SELECT avg(rating) as average
FROM ratings
         JOIN (SELECT movieid
			   FROM movies m
					JOIN hasagenre h USING (movieid)
					JOIN genres g USING (genreid)
			   WHERE g.name IN ('Romance', 'Comedy')
			   GROUP BY m.movieid
			   HAVING array_agg(g.name) = '{Romance}') Y
     USING (movieid);
     
--9
CREATE TABLE query9 AS SELECT movieid, rating from ratings WHERE userid=:v1;

CREATE TABLE similarity as (
with avgcalc as (select movieid, avg(rating) as average
	from ratings
	group by movieid)
	select a.movieid as m1, b.movieid as m2, ( 1 - ( ABS ( a.average - b.average))/5) as s, c.rating, d.title
		from avgcalc as a, avgcalc as b ,query9 as c,movies as d
		where a.movieid not in(select movieid from query9) --select all not rated movies
		and b.movieid in (select movieid from query9) --select all rated movies
		and b.movieid = c.movieid 
		and a.movieid = d.movieid);

CREATE TABLE recommendation as (
select title
	from similarity 
	group by title, m1
	having (SUM(s * rating) /SUM(s)) > 3.9);