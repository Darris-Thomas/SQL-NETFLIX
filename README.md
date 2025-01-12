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

