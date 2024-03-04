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

select * from reportedcrime;

--select sum(x.reported_cases), substring(x.occured_time,1,1) 
--from (
--select count(*) as reported_cases, occured_time
--from reportedcrime
--where occured_time like '10%'
--group by occured_time
--) x
--group by substring(x.occured_time,1,1) 


select distinct format(try_convert(datetime,trim(occured_time)),'h tt', 'en-US') as occured_hour,
count(*) over (partition by format(try_convert(datetime,trim(occured_time)),'h tt', 'en-US')) as no_of_reported_cases
from reportedcrime;



--What are the statuses of the reported cases?

select * from reportedcrime;

select status_desc, count(*) as no_of_reported_cases, format(count(*) * 100.0 / (select count(*) from reportedcrime),'N2') as percentage_by_status
from reportedcrime
group by status_desc
order by count(*) desc




--Which areas are considered the least safe?
-- On which weekday do we observe the highest number of reported cases?
--- most common crimes per year --https://www.kaggle.com/code/amaninaman/map-visualisation-preprocessing-bar-charts#(3)-INTERACTIVE-MAP-OF-CRIMES-BY-YEAR



Temporal Analysis:

What is the overall trend in reported cases over time?
Which month experiences the highest number of reported cases?
Are there any significant patterns in the day of the week or hour of the day when incidents occur?


Geospatial Analysis:
Which areas (Area_Code, Area, District_No) have the highest and lowest crime rates?
Can you identify specific locations (Location, Lat, Lon) with a concentration of reported cases?
Crime Types:

What are the top three most frequently reported crime types (Crime_Desc)?
How does the distribution of crime types vary across different areas?
Demographic Analysis:

What is the age distribution of victims?
Can you identify any patterns related to the gender and race of victims in reported cases?

Weapon Usage:
Which weapons (Weapon_Desc) are most commonly associated with reported cases?
Are there specific crime types where weapons are frequently used?
Status Analysis:

What is the distribution of case statuses (Status_Desc)?
Are there differences in the resolution status of cases across different crime types?
Victim Characteristics:

Is there a correlation between victim age and the severity of the crime (e.g., using Crime_Code)?
What are the most common crime locations (Crime_Location_Desc) for different victim demographics?
Time to Resolution:

What is the average time to resolve reported cases?
Are there differences in resolution time based on crime types or areas?
Weekday Analysis:

On which weekday do you observe the highest number of reported cases?
Are there variations in the distribution of incidents based on the day of the week?
Location Descriptions:

What are the most common crime location descriptions (Crime_Location_Desc)?
Can you identify any patterns in reported incidents based on location descriptions?

