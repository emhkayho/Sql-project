#Diabetes Health indicator
LOAD DATA LOCAL INFILE "C:\Users\User\Desktop\Sql project\diabetees\diabetes_012_health_indicators_BRFSS2015.csv" INTO TABLE DHI
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;#this query was ran on mysql command prompt line due to restrictions o workbench

CREATE TABLE DHI(
     Diabetes_012 int,
     HighBP int,
     HighChol int,
     CholCheck int,
     BMI int,
     Smoker int,
     Stroke int,
     HeartDiseaseorAttack int,
     PhysActivity int,
     Fruits int,
     Veggies int,
     HvyAlcoholConsump int,
     AnyHealthcare int,
     NoDocbcCost int,
     GenHlth int,
     MentHlth int, 
     PhysHlth int,
     DiffWalk int,
	Sex int,
	Age int,
    Education int,
    Income int
);

select * from DHI;
#How many records are there in dataset
select format(count(*),0) as 'Total Records'
from dhi;

#What are the column names and data types in the dataset
describe DHI;
show columns from dhi;

#what is the average age of the individuals in the dataset
select round(avg(age),2) as 'Average age'
from dhi;

#How many individuals have been diagnosed with diabetes
select format(count(*),0) as "Diagnosed with diabetes"
from dhi
where Diabetes_012 = 2;

SELECT format(count(*),0) as "Diagnosed with diabetes",
round(((COUNT(*) / (SELECT COUNT(*) FROM DHI)) * 100),2) AS "Percentage diabetes"
FROM dhi
group by Diabetes_012;

#What is the distribution of diabetes among age groups
select
	case
		when age = 1 then "18-24"
		when age = 2 then "25-30"
		when age = 3 then "31-36"
		when age = 4 then "37-42"
		when age = 5 then "43-48"
		when age = 6 then "49-54"
		when age = 7 then "55-61"
		when age = 8 then "62-67"
		when age = 9 then "68-73"
		when age = 10 then "74-75"
		when age = 11 then "76-78 "
		when age = 12 then "79"
		when age = 13 then "80 or older"
		else 'Unknown'
	end as Age_group,age, count(*) as Diabetes_Count
from dhi
where Diabetes_012 = 2
group by age_group
order by Diabetes_Count desc;

#How many individual have high blood pressure
select format(count(*),0) as "High Blood Pressure"
from dhi
where HighBP = 1;

#What is the average BMI(Body Mass Index) of the individuals?
select round(avg(bmi),2) as "Average BMI",
min(bmi) as MinBMI,
max(bmi) as MaxBMI
from dhi;

#How many individuals have undergone a cholesterol level measurement?
select format(count(CholCheck),0) as "Undergone Cholestrol Measurment"
from dhi;

#What is the correlation between age and blood pressure?
select ((count(*) * sum(age * HighBP) - (sum(age) *sum(HighBP))))/
(sqrt((count(*)*sum(age*age))-(sum(age)*sum(age)))*sqrt((count(*)*sum(HighBP*HighBP))-(sum(HighBP) * sum(HighBP)))) as "Age to Blood Pressure correlation"
from dhi;

#How many individuals have a BMI greater than 25 and less than 29(overweight)
select
	case
		when bmi < 18 then "Underweight"
		when bmi >= 18 and bmi <= 24 then "Healthy weight"
        when bmi >= 25 and bmi <= 29 then "Overweight"
        when bmi >= 30 then "Obese"
        else "Unknown"
	end as BMI_Category,
	format(count(*),0) as "BMI Range", round(((COUNT(*) / (SELECT COUNT(*) FROM DHI)) * 100),2) AS "Percentage BMI"
from dhi
group by BMI_Category
order by count(*) desc;

#what is the correlation between physical health and diabetes
select ((count(*) * sum(PhysActivity * Diabetes_012) - (sum(PhysActivity) *sum(Diabetes_012))))/
(sqrt((count(*)*sum(physactivity*physactivity))-(sum(physactivity)*sum(physactivity)))*sqrt((count(*)*sum(Diabetes_012*Diabetes_012))-(sum(Diabetes_012) * sum(Diabetes_012)))) as "Physical activity to Diabetes correlation"
from dhi;

#how many missing values do we have
select count(*) as "Missing Values"
from dhi
where Diabetes_012 is Null or HighBP is Null or HighChol is Null or Age is Null;