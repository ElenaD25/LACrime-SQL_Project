------ II. Exploration Data Analysis ------

-- Find answers to the following question
select * from reportedcrime;


--What racial groups are most impacted?

SELECT 
    victim_race,
    COUNT(id) AS no_of_reported_cases,
    FORMAT(COUNT(id) * 100.0 / (SELECT COUNT(*) FROM reportedcrime), 'N2')  AS percentage_of_total_cases 
FROM 
    reportedcrime
GROUP BY 
    victim_race
ORDER BY 
    COUNT(id) DESC;


--Which weapons are most commonly associated with reported cases? Top 10 often used weapons in reported cases

select top 10 weapon_used_code, weapon_desc, count(id) as no_of_reported_crimes,
format(count(id) * 100.0/ (select count(id) from reportedcrime), 'N2') as percentage_of_crimes_for_weapons
from reportedcrime
where weapon_used_code <> 0
group by weapon_used_code,weapon_desc
order by count(id) desc;


--What types of incidents are reported most frequently?

select crime_code, crime_desc, count(id) as reported_cases_by_crime_type
from reportedcrime
group by crime_code, crime_desc
order by count(id) desc

--it might be as well calculates as percentages of total reported cases

select crime_code, crime_desc, count(id) as no_reported_cases,
format(count(id) * 100.0 / (select count(*) from reportedcrime),'N2') as percentage_of_crime_type
from reportedcrime
group by crime_code, crime_desc
order by count(id) desc


--Which genre experiences the highest incidence of cases?

SELECT 
    victim_genre,
    COUNT(id) AS no_of_reported_cases,
    FORMAT(COUNT(id) * 100.0 / (SELECT COUNT(*) FROM reportedcrime), 'N2')  AS percentage_of_total_cases 
FROM 
    reportedcrime
GROUP BY 
    victim_genre
ORDER BY 
    COUNT(id) DESC;

--What age range is disproportionately affected?

select sum(x.reported_cases)
from 
(
select victim_age, count(*) as reported_cases from reportedcrime where victim_age between 1 and 10
group by victim_age 
) x

with cte_age_range
as
(
select count(*) as no_reported_cases,
    case
        when victim_age between 1 and 10 then '<= 10 years old'
        when victim_age between 11 and 20 then 'between 11 and 20 years old'
         when victim_age between 21 and 30 then 'between 21 and 30 years old'
         when victim_age between 31 and 40 then 'between 31 and 40 years old'
         when victim_age between 41 and 50 then 'between 41 and 50 years old'
         when victim_age between 51 and 60 then 'between 51 and 60 years old'
         when victim_age between 61 and 70 then 'between 61 and 70 years old'
         when victim_age between 71 and 80 then 'between 71 and 80 years old'
         when victim_age > 81 then 'bigger than 80 years old'
         else 'unknown'
    end as victim_age_range
from reportedcrime
group by victim_age
) 
    select sum(no_reported_cases), victim_age_range
    from cte_age_range
    group by victim_age_range;


-- subquery approach


select sum(x.no_reported_cases), x.victim_age_range
from
(
select count(*) as no_reported_cases,
    case
        when victim_age between 1 and 10 then '<= 10 years old'
        when victim_age between 11 and 20 then 'between 11 and 20 years old'
         when victim_age between 21 and 30 then 'between 21 and 30 years old'
         when victim_age between 31 and 40 then 'between 31 and 40 years old'
         when victim_age between 41 and 50 then 'between 41 and 50 years old'
         when victim_age between 51 and 60 then 'between 51 and 60 years old'
         when victim_age between 61 and 70 then 'between 61 and 70 years old'
         when victim_age between 71 and 80 then 'between 71 and 80 years old'
         when victim_age > 81 then 'bigger than 80 years old'
         else 'unknown'
    end as victim_age_range
from reportedcrime
group by victim_age
) x
  group by x.victim_age_range;


---When do incidents most commonly occur?

---- day of month

select count(id) as cases_reported, year(occured_date) as years,datename(weekday, occured_date) as occured_day
from reportedcrime
where year(occured_date) = 2023
group by year(occured_date) , datename(weekday, occured_date)
order by count(id),year(occured_date) desc


--- time of day

select distinct format(try_convert(datetime,trim(occured_time)),'h tt', 'en-US') as occured_hour,
count(*) over (partition by format(try_convert(datetime,trim(occured_time)),'h tt', 'en-US')) as no_of_reported_cases
from reportedcrime
order by format(try_convert(datetime,trim(occured_time)),'h tt', 'en-US')


--- month

--without a specific year

select count(id) as no_of_reported_cases, datename(month, occured_date) as month_reported
from reportedcrime
--where year(occured_date) = 2023 
group by datename(month, occured_date)
order by count(id) desc


--for a specific year
select count(id) as no_of_reported_cases, datename(month, occured_date) as month_reported
from reportedcrime
where year(occured_date) = 2023 
group by datename(month, occured_date)
order by count(id) desc


--What are the statuses of the reported cases?

select status_desc, count(*) as no_of_reported_cases, format(count(*) * 100.0 / (select count(*) from reportedcrime),'N2') as percentage_by_status
from reportedcrime
group by status_desc
order by count(*) desc


--Which areas are considered the least safe by the number of reported cases

select top 10 area, count(id) as no_of_reported_cases
from reportedcrime
group by area
order by count(id) desc;


--- most common crimes per year 

WITH RankedCrimes AS (
    SELECT
        year(occured_date) AS year_occurred,
        crime_code,
        crime_desc,
        COUNT(id) AS no_of_reported_cases,
        RANK() OVER (PARTITION BY year(occured_date) ORDER BY COUNT(id) DESC) AS crime_rank
    FROM
        reportedcrime
    GROUP BY
        year(occured_date),
        crime_code,
        crime_desc
)
SELECT
    year_occurred,
    crime_code,
    crime_desc,
    no_of_reported_cases
FROM
    RankedCrimes
WHERE
    crime_rank = 1;


-- what are the most common crime location descriptions (Crime_Location_Desc)?

select top 10 crime_location_code, crime_location_desc, count(id) as no_of_reported_cases, rank() over (order by count(id) desc) as case_rank
from reportedcrime
group by crime_location_code, crime_location_desc

