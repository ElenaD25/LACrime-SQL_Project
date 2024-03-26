<h2>LA Crimes </h2>

<h3> Introduction</h3>
The LA police are facing a significant challenge when it comes to reducing the number of incidents reported from 2020 to the present. To make informed decisions about firing more agents, doing something about the weapons law, strengthening patrols, and any other actions. The police from LA have turned to you to help them identify the reasons why the number of crimes increased like crazy. So, they entrusted you with a comprehensive dataset that contains all the records about the incidents that took place in LA and are waiting for you to come up with some conclusions and help them make important decisions when it comes to reducing those kinds of incidents and protecting the residents.

<h4><b>Dataset format:</b></h4>
<p>The dataset is composed of 28 columns: </p>
<li> DR_NO</li>
<li> Date_Rptd</li>
<li> DATE_OCC</li>
<li> TIME_OCC</li>
<li> AREA</li>
<li> AREA_NAME</li>
<li> Rpt_Dist_No</li>
<li> Part_1_2</li>
<li> Crm_Cd</li>
<li> Crm_Cd_Desc</li>
<li> Mocodes</li>
<li> Vict_Age</li>
<li> Vict_Sex</li>
<li> Vict_Descent</li>
<li> Premis_Cd</li>
<li> Premis_Desc</li>
<li> Weapon_Used_Cd</li>
<li> Weapon_Desc</li>
<li> Status</li>
<li> Status_Desc</li>
<li> Crm_Cd_1</li>
<li> Crm_Cd_1</li>
<li> Crm_Cd_1</li>
<li> Crm_Cd_1</li>
<li> Location</li>
<li> Cross_Street</li>
<li> Lat</li>
<li> Lon</li>

<p>and with a total of <b>815882</b> rows.</p>



<h3>🎯 My purpose</h3>
Through this analysis, our goal is to unravel mysteries and address the most pressing questions, ultimately guiding us toward a more effective approach to protecting the residents.

<h3>📖 This project consists in 2 parts:</h3>
<ol>
    <li>Data cleaning</li>
    <li>Exploratory Data Analysis</li>
</ol>

<hr></hr>

<h3>🕵️‍♀️ Let's begin</h3>

<h4> PART I: Data cleaning</h4>
<p> Receiving the dataset from the police doesn't mean it's already ready for analysis and insight extraction, so I had to perform the most known process - data cleaning.</p>
<p><b> Actions done:</b></p>
<ol>
  <li> Searched for duplicated values (did not find any)</li>
  <li> Replaced NULL values with something more appropriate, such as: "Unknown", "Not specified" etc.</li>
  <li> Removed unnecessary columns</li>
  <li> Replaced single character values with the full version of it (eq: F-female, B-black for race, and many more)</li>
  <li> Change the column data type (Reported Date, Occured Date from string to datetime data type)</li>
  <li> Rename columns for readability</li>
</ol>

<h4> PART II: Exploratory Data Analysis (EDA)</h4>
<p> After cleaning the dataset, the next step is to uncover valuable insights.</p>
<p><b> Questions answered:</b></p>
<ol>
  <li> What are the most affected racial groups? </li>
  <li> Which are the top 10 weapons most commonly associated with reported cases? </li>
  <li> What types of incidents are reported most frequently? </li>
  <li> Which genre experiences the highest incidence of cases? </li>
  <li> What age range is disproportionately affected? </li>
  <li> When do incidents most commonly occur? (Day of the month, Time of day, Month of year)</li>
  <li> What are the statuses of the reported cases? </li>
  <li> Which areas are considered the least safe?  </li>
  <li> What are the most common crimes per year? </li>
  <li> What are the dangerous zones for each race/ age range? </li>
  <li> What are the dangerous areas for each gender? (female/male) </li>
  <li> Are there specific crime types where weapons are frequently used? </li>
  <li> What are most types of crimes based on the area? </li>
</ol>

<hr></hr>

<h3>💁‍♀️ Conclusion and Insights</h3>

<p>After finishing the EDA I came up with the following conclusions:</p>
<ol>
    <!--<li> The top three most vulnerable races based on the frequency of attacks in Los Angeles (LA), with Hispanics being the most frequently attacked group, followed by White and Black individuals. In the first place are Hispanics who represent a percent of almost 31 out of the total reported cases. </li>
    <li> The statistics showed that not having strict laws anyone could own a gun, which led to multiple reported cases where one of the used weapons was a physical force, followed unfortunately by weapons, verbal threats, and handguns</li> 
    <li> </li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>-->
</ol>


