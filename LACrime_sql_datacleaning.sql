use TEST;

select count(column_name) as No_of_columns from information_schema.columns
where table_name = 'ReportedCrime';

select count(*) as No_of_rows from ReportedCrime;

select column_name, data_type from information_schema.columns
where table_name = 'ReportedCrime';


----it's always better to have a backup table
select * 
into ReportedCrime_bkp
from ReportedCrime;

select count(*) as Records from ReportedCrime_bkp ;

select column_name, data_type 
from information_schema.columns
where table_name = 'ReportedCrime_bkp'

---IT's show time

-- drop the columns that you don't need

alter table ReportedCrime
drop column Mocodes, [Crm_cd_1], [crm_cd_2], [crm_cd_3], [crm_cd_4], [cross_street], [Part_1_2]

-- rename columns for readability and better understanding

EXEC sp_rename 'ReportedCrime.DR_NO', 'ID', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Date_Rptd', 'Reported_Date', 'COLUMN';
EXEC sp_rename 'ReportedCrime.DATE_OCC', 'Occured_Date', 'COLUMN';
EXEC sp_rename 'ReportedCrime.TIME_OCC', 'Occured_Time', 'COLUMN';
EXEC sp_rename 'ReportedCrime.AREA', 'Area_Code', 'COLUMN';
EXEC sp_rename 'ReportedCrime.AREA_NAME', 'Area', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Rpt_Dist_No', 'District_No', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Crm_Cd', 'Crime_Code', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Crm_Cd_Desc', 'Crime_Desc', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Vict_Age', 'Victim_Age', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Vict_Sex', 'Victim_Genre', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Vict_Descent', 'Victim_Race', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Premis_Cd', 'Crime_Location_Code', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Premis_Desc', 'Crime_Location_Desc', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Weapon_Used_Cd', 'Weapon_Used_Code', 'COLUMN';
EXEC sp_rename 'ReportedCrime.Weapon_Desc', 'Weapon_Desc', 'COLUMN';
EXEC sp_rename 'ReportedCrime.LOCATION', 'Location', 'COLUMN';
EXEC sp_rename 'ReportedCrime.LAT', 'Lat', 'COLUMN';
EXEC sp_rename 'ReportedCrime.LON', 'Lon', 'COLUMN';


------ I. Data cleaning ------

--- search and replace NULLs --- 

-- check if we have NULL values in our data

exec NullValueInspector @table = 'ReportedCrime_bkp' --- NullValueInspector is a stored procedure that can be found in SQL-scripts repo on my GitHub

-- after finding all the columns that contained NULLs, we replace them with different values (it isn't recommended to have NULLs, especially when preparing data for further analysis)
update ReportedCrime set Victim_Genre = 'Unknown' where Victim_Genre is null;
update ReportedCrime set Victim_Race = 'Unknown' where Victim_Race is null;
update ReportedCrime set Crime_Location_Code = '0' where Crime_Location_Code is null;
update ReportedCrime set Crime_Location_Desc = 'Unknown' where Crime_Location_Desc is null;
update ReportedCrime set Weapon_Used_Code = '0' where Weapon_Used_Code is null;
update ReportedCrime set Weapon_Desc = 'Unknown' where Weapon_Desc is null;


---check again for null values
exec NullValueInspector @table = 'ReportedCrime' -- nothing to see here, result = 0


--- search for duplicate values ---

select ID, count(ID) --> NO DUPLICATES (YAY)
from  ReportedCrime
group by ID
having count(ID) > 1


-- substitute abbreviated or single-character values with their corresponding full versions. For example, replace 'F' with 'female,' and 'B' with 'black' for the race variable, among others

select distinct victim_genre from ReportedCrime;

update ReportedCrime set victim_genre =
	case
		when victim_genre = 'F' then 'Female'
		when victim_genre = 'M' then 'Male' 		
		when victim_genre = 'X' or victim_genre = 'H' then 'Unknown'
		else 'Unknown'
	end 

update ReportedCrime set Victim_Race = 
	case 
		when Victim_Race = 'A' then 'Other Asian'
		when Victim_Race = 'B' then 'Black'
		when Victim_Race = 'C' then 'Chinese'
		when Victim_Race = 'D' then 'Cambodian'
		when Victim_Race = 'F' then 'Filipino'
		when Victim_Race = 'G' then 'Guamanian'
		when Victim_Race = 'H' then 'Hispanic'
		when Victim_Race = 'I' then 'American Indian'
		when Victim_Race = 'J' then 'Japanese'
		when Victim_Race = 'K' then 'Korean'
		when Victim_Race = 'L' then 'Laotian'
		when Victim_Race = 'O' then 'Other'
		when Victim_Race = 'P' then 'Pacific Islander'
		when Victim_Race = 'S' then 'Samoan'
		when Victim_Race = 'U' then 'Hawaiian'
		when Victim_Race = 'V' then 'Vietnamese'
		when Victim_Race = 'W' then 'White'
		when Victim_Race = 'X' then 'Unknown'
		when Victim_Race = 'Z' then 'Asian Indian'
		else 'Unknown'
	end


-- identify & delete the rows with mystery times in the occurred_time column and change its data type

select time_occ as Occured_Time  from reportedcrime_bkp where TIME_OCC >= 25 and len(TIME_OCC) =2;

delete from ReportedCrime where occured_time >= 25 and len(occured_time) =2;

alter table reportedcrime alter column occured_time nvarchar(10);

update ReportedCrime set occured_time =
	case 
		when len(occured_time) = 1 then concat(occured_time, ':00')
		when len(occured_time) = 2 then concat(occured_time, ':00')
		when len(occured_time) = 3 then concat(left(occured_time, 1),':', right(occured_time,2))
		when len(occured_time) = 4 then concat(left(occured_time, 2),':', right(occured_time,2))
	end;

update reportedcrime set occured_time = format(try_convert(datetime,trim(occured_time)),'hh:mm tt', 'en-US') ;

update reportedcrime set occured_time = '12:00 AM'  WHERE OCCURED_TIME IS NULL;

---- keep only the date into date columns (occured_date, reported_date)

alter table reportedcrime alter column occured_date date; --convert from datettime to date
alter table reportedcrime alter column reported_date date; --convert from datettime to date

--- capitalize values in Crime_desc and Weapon_desc columns

update reportedcrime set crime_desc =
CONCAT(UPPER(SUBSTRING(crime_desc, 1, 1)), LOWER(SUBSTRING(crime_desc, 2, LEN(crime_desc))));

update reportedcrime set weapon_desc =
CONCAT(UPPER(SUBSTRING(weapon_desc, 1, 1)), LOWER(SUBSTRING(weapon_desc, 2, LEN(weapon_desc))));


--update ReportedCrime
--set Location =
--        CASE
--            WHEN LEN(Location) < 15 THEN TRIM(Location)
--            ELSE SUBSTRING(Location, 1, LEN(Location) - 2)
--        END


--script used to update the location column value (remove the latest 2 characters and the extra spaces, and capitalize every word
WITH cte_location AS (
    SELECT
        location,
        CASE
            WHEN LEN(location) < 15 THEN TRIM(location)
            ELSE SUBSTRING(location, 1, LEN(location) - 2)
        END AS eks
    FROM
        ReportedCrime
)

UPDATE tgt
SET tgt.location = (
    SELECT STRING_AGG(UPPER(LEFT(OriginalWord, 1)) + LOWER(SUBSTRING(OriginalWord, 2, LEN(OriginalWord))), ' ') WITHIN GROUP (ORDER BY WordOrder) AS CapitalizedString
    FROM (
        SELECT value AS OriginalWord,
               ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS WordOrder
        FROM STRING_SPLIT(cte_location.eks, ' ')
    ) SplitWords
)
FROM ReportedCrime tgt
JOIN cte_location ON cte_location.location = tgt.location;

--- check the lastest version of my table
select * from ReportedCrime;


--- drop rows where victim_age < 0
select victim_age, count(*) from reportedcrime group by victim_age order by victim_age;

delete from reportedcrime where victim_age < 0;
