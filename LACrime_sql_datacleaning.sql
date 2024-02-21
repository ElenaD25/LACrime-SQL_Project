use TEST;

----it's always better to have a backup table
select * 
into ReportedCrime_bkp
from ReportedCrime;

---IT's show time

-- drop the columns that you don't need

alter table ReportedCrime drop column Mocodes, [Crm_cd_1], [crm_cd_2], [crm_cd_3], [crm_cd_4], [cross_street], [Part_1_2]

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

exec NullValueInspector @table = 'ReportedCrime' --- NullValueInspector is a stored procedure that can be found in SQL-scripts repo on my GitHub

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


-- delete the rows with mystery times in the occurred_time column and change its data type

delete from reportedcrime where occured_time >= 25 and len(occured_time) =2;

alter table reportedcrime alter column occured_time nvarchar(10);

update reportedcrime set occured_time =
	case 
		when len(occured_time) = 1 then concat(occured_time, ':00')
		when len(occured_time) = 2 then concat(occured_time, ':00')
		when len(occured_time) = 3 then concat(left(occured_time, 1),':', right(occured_time,2))
		when len(occured_time) = 4 then concat(left(occured_time, 2),':', right(occured_time,2))
	end;


--- remove the extra spaces in the LOCATION column

update ReportedCrime set location =  
	case
		when len(location) < 10 then location
		else replace(trim(concat(trim(left(location, len(location) - len(right(location, 2)))),' ', right(location, 2))),'  ',' ')
end;

update reportedcrime set crime_desc =
CONCAT(UPPER(SUBSTRING(crime_desc, 1, 1)), LOWER(SUBSTRING(crime_desc, 2, LEN(crime_desc))));

update reportedcrime set location =
CONCAT(UPPER(SUBSTRING(location, 1, 1)), LOWER(SUBSTRING(location, 2, LEN(location))));

update reportedcrime set weapon_desc =
CONCAT(UPPER(SUBSTRING(weapon_desc, 1, 1)), LOWER(SUBSTRING(weapon_desc, 2, LEN(weapon_desc))));

update reportedcrime set location =
CONCAT(UPPER(SUBSTRING(location, 1, 1)), LOWER(SUBSTRING(location, 2, LEN(location))));

