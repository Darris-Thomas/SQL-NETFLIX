--Netflix project

CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;

--Solving 15 problems

--1. Count the number of Movies vs TV Shows
select type,count(*)
from netflix
group by type;

--2. Find the most common rating for movies and TV shows
with cte as
(
select type,rating,count(*) count,rank() over(partition by type order by count(*) desc) as rn from netflix
group by rating,type
order by count(*) desc
)
select type,rating,count from cte
where rn=1;

--3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM netflix
WHERE release_year = 2020 AND type = 'Movie';

--4. Find the top 5 countries with the most content on Netflix
select
   unnest(string_to_array(country,',')) as country,
   count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;

--5. Identify the longest movie
select title,type,duration from netflix
   where type = 'Movie'
   and duration = (select max(duration) from netflix);

--6. Find content added in the last 5 years
select * from netflix
where to_date(date_added,'month dd,yyyy') >= current_date-interval '5 years';


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix
where director ilike '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons

select *,
split_part(duration,' ',1) :: numeric as no_of_seasons 
from netflix
  where type = 'TV Show'
  and split_part(duration,' ',1)::numeric > 5;

--9. Count the number of content items in each genre
select count(show_id) as count,
unnest(string_to_array(listed_in,',')) as genres
from netflix
group by genres
order by count desc;

--10.Find each year and the average numbers of content release in India on netflix.
   --return top 5 year with highest avg content release!
select 
extract(year from to_date(date_added,'month dd,yyyy')) as netflix_release_year,
count(*) yearly_content,
round(count(*) :: numeric / (select count(*) from netflix where country = 'India'):: numeric * 100,2) as avg_content_per_year
from netflix
where country = 'India'
group by 1
order by 3 desc
limit 5;

--11. List all movies that are documentaries
select title
from netflix
where type = 'Movie' and listed_in ilike '%documentaries%';

--12. Find all content without a director
select title from netflix 
where director is null;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix
where casts ilike '%salman khan%' 
and release_year >= extract(year from current_date) - 10;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
unnest(string_to_array(casts,',')) as actors,count(*) as movies
from netflix
where country ilike '%india%'
group by 1
order by movies desc
limit 10;

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
    --the description field. Label content containing these keywords as 'Bad' and all other 
    --content as 'Good'. Count how many items fall into each category
with cte as
(
select show_id,type,title,description,
case
    when
      description ilike 'kill%' or
	  description ilike '%violence%'
    then 'BAD'
    else 'GOOD'
end as category
from netflix
)
select category,count(*) as total_count
from cte
group by category
order by 2 desc;
	
