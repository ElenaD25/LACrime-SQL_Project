------ II. Exploration Data Analysis ------


    -- What are the most affected racial groups?

select 
    victim_race,
    count(id) as no_of_reported_cases,
    format(count(id) * 100.0 / (select count(*) from reportedcrime), 'N2')  AS percentage_of_total_cases 
from 
    reportedcrime
group by 
    victim_race
order by 
    count(id) desc;

    -- Which are the top 10 weapons most commonly associated with reported cases?

select top 10 weapon_used_code, weapon_desc, count(id) as no_of_reported_crimes,
format(count(id) * 100.0/ (select count(id) from reportedcrime), 'N2') as percentage_of_crimes_for_weapons
from reportedcrime
where weapon_used_code <> 0
group by weapon_used_code,weapon_desc
order by count(id) desc;


    -- What types of incidents are reported most frequently?

select crime_code, crime_desc, count(id) as reported_cases_by_crime_type
from reportedcrime
group by crime_code, crime_desc
order by count(id) desc

-- it might be as well calculates as percentages of total reported cases

select crime_code, crime_desc, count(id) as no_reported_cases,
format(count(id) * 100.0 / (select count(*) from reportedcrime),'N2') as percentage_of_crime_type
from reportedcrime
group by crime_code, crime_desc
order by count(id) desc


    -- Which genre experiences the highest incidence of cases?

select 
    victim_genre,
    count(id) as no_of_reported_cases,
    format(count(id) * 100.0 / (select count(*) from reportedcrime), 'N2')  AS percentage_of_total_cases 
from 
    reportedcrime
group by 
    victim_genre
order by 
    count(id) desc;


    -- What age range is disproportionately affected?

-- CTE approach
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
    select victim_age_range, sum(no_reported_cases) as no_reported_cases
    from cte_age_range
    where victim_age_range <> 'unknown'
    group by victim_age_range;


-- subquery approach
select x.victim_age_range, sum(x.no_reported_cases) as no_reported_cases, 
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


    --- When do incidents most commonly occur? (Day of the month, Time of day, Month of year)

-- day of month

with DayCount as 
(
    select count(id) as no_of_reported_cases, year(occured_date) as years,datename(weekday, occured_date) as occured_day
    from reportedcrime
    where year(occured_date) = 2023
    group by year(occured_date) , datename(weekday, occured_date)
)
     select occured_day, no_of_reported_cases
     from daycount
     order bY
        case occured_day
            when 'Monday' then 1
            when 'Tuesday' then 2
            when 'Wednesday' then 3
            when 'Thursday' then 4 
            when 'Friday' then 5
            when 'Saturday' then 6
            when 'Sunday' then 7
        end;



-- time of day
with HourlyCounts as (
    select 
        format(try_convert(datetime, trim(occured_time)), 'h tt', 'en-US') AS occured_hour,
        count(*) as no_of_reported_cases
    from 
        reportedcrime
    group by 
        format(try_convert(datetime, trim(occured_time)), 'h tt', 'en-US')
)
select 
    occured_hour,
    no_of_reported_cases
from 
    HourlyCounts
order by 
    case 
        when right(occured_hour, 2) = 'AM' then 1
        when right(occured_hour, 2) = 'PM' then 2
    end,
    cast(substring(occured_hour, 1, charindex(' ', occured_hour) - 1) as int);


-- month of year

  -- without a specific year
select year(occured_date),datename(month, occured_date) as month_reported, count(id) as no_of_reported_cases 
from reportedcrime 
group by year(occured_date), datename(month, occured_date)
order by year(occured_date),
    CASE 
        WHEN datename(month, occured_date) = 'January' THEN 1
        WHEN datename(month, occured_date) = 'February' THEN 2
        WHEN datename(month, occured_date) = 'March' THEN 3
        WHEN datename(month, occured_date) = 'April' THEN 4
        WHEN datename(month, occured_date) = 'May' THEN 5
        WHEN datename(month, occured_date) = 'June' THEN 6
        WHEN datename(month, occured_date) = 'July' THEN 7
        WHEN datename(month, occured_date) = 'August' THEN 8
        WHEN datename(month, occured_date) = 'September' THEN 9
        WHEN datename(month, occured_date) = 'October' THEN 10
        WHEN datename(month, occured_date) = 'November' THEN 11
        WHEN datename(month, occured_date) = 'December' THEN 12
    END;


  -- for a specific year
select year(occured_date), datename(month, occured_date) as month_reported, count(id) as no_of_reported_cases
from reportedcrime
where year(occured_date) = 2023 
group by datename(month, occured_date)
order by 
    CASE 
        WHEN datename(month, occured_date) = 'January' THEN 1
        WHEN datename(month, occured_date) = 'February' THEN 2
        WHEN datename(month, occured_date) = 'March' THEN 3
        WHEN datename(month, occured_date) = 'April' THEN 4
        WHEN datename(month, occured_date) = 'May' THEN 5
        WHEN datename(month, occured_date) = 'June' THEN 6
        WHEN datename(month, occured_date) = 'July' THEN 7
        WHEN datename(month, occured_date) = 'August' THEN 8
        WHEN datename(month, occured_date) = 'September' THEN 9
        WHEN datename(month, occured_date) = 'October' THEN 10
        WHEN datename(month, occured_date) = 'November' THEN 11
        WHEN datename(month, occured_date) = 'December' THEN 12
    END;


    -- What are the statuses of the reported cases?

select status_desc, count(*) as no_of_reported_cases, format(count(*) * 100.0 / (select count(*) from reportedcrime),'N2') as percentage_by_status
from reportedcrime
group by status_desc
order by count(*) desc


    -- Which areas are considered the least safe? (by number of reported cases)

select top 10 area, count(id) as no_of_reported_cases
from reportedcrime
group by area
order by count(id) desc;


    -- What are the most common crimes per year? 

with rankedcrimes as (
    select
        year(occured_date) as year_occurred,
        crime_code,
        crime_desc,
        count(id) as no_of_reported_cases,
        rank() over (partition by year(occured_date) order by count(id) desc) as crime_rank
    from
        reportedcrime
    group by
        year(occured_date),
        crime_code,
        crime_desc
)
select
    year_occurred,
    crime_code,
    crime_desc,
    no_of_reported_cases
from
    rankedcrimes
where
    crime_rank = 1;


    -- What are the dangerous zones for each race/ age range?

-- this query provides insights into the areas most affected by reported crime for each victim race

with cte_victims_race_area
as
(
    select victim_race, area, count(id) as no_of_cases, row_number() over(partition by victim_race order by count(id) desc) as ranks
    from reportedcrime
    group by victim_race, area
)
    select 
        victim_race, area, no_of_cases
    from cte_victims_race_area
    where ranks = 1
    order by no_of_cases desc


-- this query aims to identify the top 10 areas with the highest number of reported cases for each victim age range

with cte_dangerous_are_victim_age
as
(
    select area, count(id) as no_of_reported_cases, row_number() over (partition by victim_age order by count(id) desc) as ranks,
        
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
    group by area, victim_age
)
    select top 10 area, victim_age_range, no_of_reported_cases
    from cte_dangerous_are_victim_age
    where ranks = 1
    order by no_of_reported_cases desc


    -- What are the dangerous areas for each gender? (female/male)
        -- this query provides insights into the top three dangerous areas for females based on reported crime data

-- female
with cte_dangerous_areas_for_females
as
(
    select victim_genre, area, crime_desc,
    count(id) as no_of_cases, row_number() over (partition by victim_genre order by count(id) desc) as ranked_d
    from reportedcrime
    where victim_genre <> 'Unknown'
    group by victim_genre, area, crime_desc
)
    select victim_genre, area, crime_desc,ranked_d, no_of_cases
    from cte_dangerous_time_by_gender
    where ranked_d between 1 and 3 and victim_genre = 'Female'
    order by ranked_d;
   
-- male   
with cte_dangerous_areas_for_males
as
(
    select victim_genre, area, crime_desc,
    count(id) as no_of_cases, row_number() over (partition by victim_genre order by count(id) desc) as ranked_d
    from reportedcrime
    where victim_genre <> 'Unknown'
    group by victim_genre, area, crime_desc
)
    select victim_genre, area, crime_desc,ranked_d, no_of_cases
    from cte_dangerous_time_by_gender
    where ranked_d between 1 and 3 and victim_genre = 'Male'
    order by ranked_d;


    -- Are there specific crime types where weapons are frequently used?

select top 10 crime_desc, weapon_desc, count(id) as no_of_reported_cases
from reportedcrime
where weapon_desc not like '%Unknown%'
group by crime_desc, weapon_desc
order by count(id) desc


    -- What are most types of crimes based on the area?
       
select distinct top 10 area, crime_desc, count(id) as no_of_reported_cases
from reportedcrime
group by area, crime_desc
order by no_of_reported_cases desc
    



