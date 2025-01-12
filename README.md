# **DATA ANALYSIS ON NETFLIX MOVIES AND WEB SERIES**


## OVERVIEW
This project focuses on an in-depth analysis of Netflix's movies and TV shows dataset using SQL. The objective is to uncover meaningful insights and address various business-related questions derived from the data. This README outlines the project's goals, key business challenges, proposed solutions, findings, and conclusions in detail.

## OBJECTIVES
- Examine the distribution of content types, distinguishing between movies and TV shows.
- Determine the most frequent ratings associated with movies and TV shows.
- Analyze content by release years, countries of origin, and durations.
- Investigate and classify content using specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## SCHEMA
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Solving 15 problems

### 1. Count the Number of Movies vs TV Shows

```sql
select type,count(*)
from netflix
group by type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
with cte as
(
select type,rating,count(*) count,rank() over(partition by type order by count(*) desc) as rn from netflix
group by rating,type
order by count(*) desc
)
select type,rating,count from cte
where rn=1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE release_year = 2020 AND type = 'Movie';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select
   unnest(string_to_array(country,',')) as country,
   count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select title,type,duration from netflix
   where type = 'Movie'
   and duration = (select max(duration) from netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select * from netflix
where to_date(date_added,'month dd,yyyy') >= current_date-interval '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from netflix
where director ilike '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select *,
split_part(duration,' ',1) :: numeric as no_of_seasons 
from netflix
  where type = 'TV Show'
  and split_part(duration,' ',1)::numeric > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select count(show_id) as count,
unnest(string_to_array(listed_in,',')) as genres
from netflix
group by genres
order by count desc;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix, return top 5 year with highest avg content release!

```sql
select 
extract(year from to_date(date_added,'month dd,yyyy')) as netflix_release_year,
count(*) yearly_content,
round(count(*) :: numeric / (select count(*) from netflix where country = 'India'):: numeric * 100,2) as avg_content_per_year
from netflix
where country = 'India'
group by 1
order by 3 desc
limit 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select title
from netflix
where type = 'Movie' and listed_in ilike '%documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select title from netflix 
where director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select * from netflix
where casts ilike '%salman khan%' 
and release_year >= extract(year from current_date) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
select 
unnest(string_to_array(casts,',')) as actors,count(*) as movies
from netflix
where country ilike '%india%'
group by 1
order by movies desc
limit 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


