create database zomato;
use zomato;
SELECT * FROM zomato.zomato;

-- Creating Staging Tables
-- 1. Staging table for main restaurant data
create table stg_main as
select *
from zomato;

-- Total Restaurants, Cities, and Countries
SELECT 
    COUNT(DISTINCT RestaurantID) AS Total_Restaurants,
    COUNT(DISTINCT City) AS Total_Cities,
    COUNT(DISTINCT CountryCode) AS Total_Countries
FROM zomato;

-- Average Rating & Average Cost (in Local Currency)SELECT 
select
round(avg(Rating), 2) as Avg_Rating,
round(avg(Average_Cost_for_two), 2) as Avg_Cost_For_Two
from stg_main
where Rating is not null;

-- Restaurants by country
select
   NameCountry,
   count(RestaurantID) as Restaurant_Count
from stg_main
Group by NameCountry
Order by Restaurant_Count desc;   

-- Top 10 Cities by Restaurant Count 
select
   City,
   Count(RestaurantID) as Number_of_Restaurants
from stg_main
group by City
order by Number_of_Restaurants desc limit 10;  

-- Highest Rated Restaurant in Each City
select City, RestaurantName, max(Rating) as Highest_Rating
from stg_main
where Rating is not null
group by 1, 2
Order by Highest_Rating desc;
   
-- Average Cost for two by City
select City,
       round(Avg(Average_Cost_for_two), 2) as Avg_Cost_for_two
from stg_main
group by City
order by Avg_Cost_for_two desc;

-- Most Affordable Cuisines(Lowest Avg Cost)
select Cuisines,
	   round(Avg(Average_Cost_for_two), 2) as Avg_Cost_for_two
from stg_main
group by Cuisines
order by Avg_Cost_for_two asc
limit 10;       

-- Restaurants Opening by Year 
select 
    Year_Opening,
    Count(*) as Restaurants_Opened
from stg_main
where Year_Opening is not null
group by Year_Opening
order by Year_Opening;

-- Delivery vs Dine-in (Cross Analysis)
select
    Has_Table_booking,
    Has_Online_delivery,
    count(*) as Restaurant_Count
from stg_main
group by Has_Table_booking, Has_Online_delivery;

-- Which cuisine combinations are most common
select
    Cuisines,
    Count(*) as Count
from stg_main
where Cuisines like '%,%'
group by Cuisines
order by Count desc
limit 10;

-- Which Countries have widest cuisines variety 
select
   CountryCode,
   Count(distinct Cuisines) as Cuisine_Variety,
   count(*) as Total_Restaurants
from stg_main
group by CountryCode
order by Cuisine_Variety desc;   

-- Restaurant growth rate by year
WITH yearly_counts AS (
    SELECT 
        Year_Opening,
        COUNT(*) AS Restaurants_Opened
    FROM stg_main
    WHERE Year_Opening IS NOT NULL
    GROUP BY Year_Opening
)
SELECT 
    Year_Opening,
    Restaurants_Opened,
    ROUND(
        (Restaurants_Opened - LAG(Restaurants_Opened) OVER (ORDER BY Year_Opening)) /
        LAG(Restaurants_Opened) OVER (ORDER BY Year_Opening) * 100,
        2
    ) AS Growth_Percentage
FROM yearly_counts
ORDER by Year_Opening;

-- Premium fine-dinning restaurants
select
	RestaurantName,
    City,
    Cuisines,
    Rating,
    Average_Cost_for_two
from stg_main
where Rating >= 4.5 and Average_Cost_for_two >3000
order by Rating desc, Average_Cost_for_two desc;

-- Most loved restaurant per City
select
   City,
   Restaurantname,
   Max(Votes) as Max_Votes
from stg_main
group by City, RestaurantName
order by Max_Votes desc;
   
    

















    







      



















