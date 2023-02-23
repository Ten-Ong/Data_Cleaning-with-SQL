-- SQL Query Data Exploration and cleaning


-- Preview first 20 rows of the data
select * from cars.cars
limit 20;

-- count how many rows in dataset
select count(Make) as Total_num_of_cars
from cars.cars;

-- Show all the columns and data type in dataset  
show columns 
from cars.cars;

-- Looking at the distinct values in columns Year to see how many years of data being collected in this dataset.
select  Distinct (Year)
from cars.cars
order by Year;

-- Distinct values of make (car brands) 
select  Distinct (Make)
from cars.cars
order by Make;

-- distinct values of Used_Certified column
select  Distinct (Used_Certified)
from cars.cars;

/* 
	Noted: Used_Certified' column contient many different types of certified
	let change all these to displayed as "Certified"
*/
update cars.cars
set Used_Certified = 'Certified'
where Used_Certified LIKE "% Certified";

-- Check State distinct values
select  Distinct (State)
FROM cars.cars
order by State;

/*
	Noted: Suite and RT are in State column which is not appropriate values
	We can remove those data or do some research and fix those 
*/

select Make,  SellerType, SellerName, StreetName, State
from cars.cars
where State = 'RT';

-- Search those address on Google and All of the Dealer address are from MA. 
-- Update those into the database
update cars.cars
set State = 'MA'
where State = "RT";

-- remove rows with State = Suite
Delete from cars.cars
where State = 'Suite';

-- move on Fuel Type
select  Distinct (FuelType)
FROM cars.cars;

select make, Model, FuelType
FROM cars.cars
where FuelType = 'â€“';

/* 
 There are alot of Tesla with this misstake value. 
 Based on the same brand and its Model on this dataset, let fix those misstake
  - Change Tesla fuel type to Electric
  - Mercedes-Benz Model E class E 350 to Gasoline 
  - Dodge Model Durango SXT to Gasoline
  - Remove Dodge Model Grand Caravan GT and Model Durango Limited, Chrysler Model Town & Country Limited Platinum -- no record in this dataset 
*/
Update cars.cars
set FuelType = 'Electric'
where make = 'Tesla';

Update cars.cars
set FuelType = 'Gasoline'
where make = 'Mercedes-Benz' and Model= 'E-Class E 350';

Update cars.cars
set FuelType = 'Gasoline'
where make = 'Dodge' and Model= 'Durango SXT';

Delete from cars.cars
where  Make in('Dodge', 'Chrysler') 
	and Model in( 'Grand Caravan GT','Town & Country Limited Platinum','Durango Limited');
 
/* update: FuelType with Gasoline Fuel to Gasoline 
			Diesel Fuel to Diesel
*/

Update cars.cars
set FuelType =	Case when FuelType = 'Diesel Fuel' THEN 'Diesel'
		when FuelType = 'Gasoline Fuel' THEN 'Gasoline'
        ELSE FuelType
        END;

-- count how many rows in dataset
select count(Make) as Total_num_of_cars
from cars.cars;
 
-- count how many cars in each years
select Year,count(Make) as Total_num_of_cars
from cars.cars
group by Year
order by Year;

-- Creat View to store 5 full years of data from 2017 t0 2021 for later analysis and visualizations
create View  cars.carsdata2017_2021 as
select Year, Make, Model, Used_Certified, Price, ConsumerRating, ConsumerReviews, SellerType, 
State, DealType, ComfortRating, ReliabilityRating, MinMPG, MaxMPG, FuelType, Mileage
From cars.cars
where Year between '2017' And '2021';

show columns 
from  cars.carsdata2017_2021;

select * 
from  cars.carsdata2017_2021
order by Price Desc;

-- let see how many rows of data between 2017 to 2022
select  count(Make) as Total_num_of_cars 
from  cars.carsdata2017_2021;
 
-- count how many cars are in each brand per year
select year, Make, count(Make) as num_of_cars
from  cars.carsdata2017_2021
group by Make
order by year;

-- count how many used cars and certified per year
select year,  Used_Certified, count(Used_Certified)
from  cars.carsdata2017_2021
group by Used_Certified, Year
order by year;


select year, SellerType, count(SellerType)
from  cars.carsdata2017_2021
group by SellerType, Year
order by year;


-- top 5 most expense cars 
select Make, Model, Price, Mileage
from cars.carsdata2017_2021
order by Price Desc
limit 5;

-- top 5  cars with lowest price 
select Make, Model, Price, Mileage
from cars.carsdata2017_2021
order by Price asc
limit 5;

