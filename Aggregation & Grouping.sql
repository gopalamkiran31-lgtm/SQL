--A. Aggregation & Grouping

--1. Find the total, average, minimum, and maximum credit limit of all customers.

SELECT
    SUM(cust_credit_limit) AS total_credit_limit,
    AVG(cust_credit_limit) AS average_credit_limit,
    MIN(cust_credit_limit) AS minimum_credit_limit,
    MAX(cust_credit_limit) AS maximum_credit_limit
FROM SH.customers;

--2.Count the number of customers in each income level.

select cust_income_level, count(*) as cust_count FROM SH.customers group by cust_income_level; 

--3.Show total credit limit by state and country.

SELECT cust_state_province, country_id,sum(cust_credit_limit) as total_credit_limit
From SH.CUSTOMERS group by CUST_STATE_PROVINCE, COUNTRY_ID;

--4.Display average credit limit for each marital status and gender combination.

SELECT cust_marital_status, cust_gender, avg(cust_credit_limit) as average_credit_limit
FROM SH.CUSTOMERS GROUP BY CUST_MARITAL_STATUS, cust_gender;

--5.Find the top 3 states with the highest average credit limit.

SELECT cust_state_province, AVG(cust_credit_limit) AS avg_credit_limit
FROM sh.customers GROUP BY cust_state_province ORDER BY avg_credit_limit DESC
FETCH FIRST 3 ROWS ONLY;

--6.Find the country with the maximum total customer credit limit.

SELECT COUNTRY_ID, SUM(cust_credit_limit) AS total_credit_limit
FROM SH.CUSTOMERS GROUP BY country_id order by total_credit_limit desc
FETCH FIRSt  ROW ONLY;

--7.Show the number of customers whose credit limit exceeds their state average.

SELECT COUNT(*) AS num_customers_above_state_avg
FROM (
    SELECT cust_credit_limit,
           AVG(cust_credit_limit) OVER (PARTITION BY cust_state_province) AS state_avg
    FROM sh.customers
) 
WHERE cust_credit_limit > state_avg;


--8.Calculate total and average credit limit for customers born after 1980.

SELECT 
    SUM(cust_credit_limit) as total_credit_limit,
    avg(cust_credit_limit) as avg_credit_limit
from SH.CUSTOMERS where cust_year_of_birth > 1980;    

--9.Find states having more than 50 customers.

SELECT CUST_STATE_PROVINCE, COUNT(*) AS CUST_COUNT
FROM SH.CUSTOMERS GROUP BY CUST_STATE_PROVINCE HAVING COUNT(*) > 50;

--10.List countries where the average credit limit is higher than the global average.

SELECT COUNTRY_ID FROM SH.CUSTOMERS GROUP BY COUNTRY_ID 
HAVING AVG(CUST_CREDIT_LIMIT) > (SELECT AVG(CUST_CREDIT_LIMIT) FROM SH.CUSTOMERS);

--11.Calculate the variance and standard deviation of customer credit limits by country.

SELECT country_id,
       VAR_SAMP(cust_credit_limit) AS credit_limit_variance,
       STDDEV_SAMP(cust_credit_limit) AS credit_limit_stddev
FROM sh.CUSTOMERS
GROUP BY country_id;

--12.Find the state with the smallest range (max–min) in credit limits.

SELECT cust_state_province,
    max(cust_credit_limit)- min(cust_credit_limit) as credit_limit 
From sh.customers group by CUST_STATE_PROVINCE order by credit_limit asc
fetch first row only; 

--13.Show the total number of customers per income level and the percentage contribution of each.

SELECT 
    cust_income_level,
    COUNT(*) AS cust_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_contribution
FROM sh.customers
GROUP BY cust_income_level;

--14.For each income level, find how many customers have NULL credit limits.

SELECT cust_income_level, count(*) as cust_count from sh.CUSTOMERS 
where CUST_CREDIT_LIMIT is null group by cust_income_level ORDER BY CUST_COUNT DESC;

--15.Display countries where the sum of credit limits exceeds 10 million.
SELECT 
    Country_ID,
    SUM(CUST_Credit_Limit) AS TotalCreditLimit
FROM 
    SH.Customers
GROUP BY 
    Country_ID
HAVING 
    SUM(CUST_Credit_Limit) > 10000000;

--16.Find the state that contributes the highest total credit limit to its country.

SELECT CUST_STATE_PROVINCE, SUM(CUST_CREDIT_LIMIT) AS total_credit_limit
FROM SH.CUSTOMERS GROUP BY CUST_STATE_PROVINCE ORDER BY total_credit_limit DESC
FETCH FIRST ROW ONLY;

--17.Show total credit limit per year of birth, sorted by total descending.
SELECT 
    CUST_YEAR_OF_BIRTH,
    SUM(CUST_CREDIT_LIMIT) AS TotalCreditLimit
FROM 
    SH.CUSTOMERS
GROUP BY 
    CUST_YEAR_OF_BIRTH
ORDER BY 
    TotalCreditLimit DESC;

--18.Identify customers who hold the maximum credit limit in their respective country.

SELECT COUNTRY_ID, MAX(CUST_CREDIT_LIMIT) AS CREDIT_LIMIT 
FROM SH.CUSTOMERS GROUP BY COUNTRY_ID ORDER BY CREDIT_LIMIT DESC;

--19.Show the difference between maximum and average credit limit per country.

SELECT COUNTRY_ID, MAX(CUST_CREDIT_LIMIT) - AVG(CUST_CREDIT_LIMIT) AS DIFFERENCE
FROM SH.CUSTOMERS GROUP BY COUNTRY_ID; 

--20.Display the overall rank of each state based on its total credit limit (using GROUP BY + analytic rank).

WITH EACH_STATE AS (
    SELECT CUST_STATE_PROVINCE, SUM(CUST_CREDIT_LIMIT) AS  CREDIT_LIMIT
    FROM SH.CUSTOMERS WHERE CUST_CREDIT_LIMIT IS NOT NULL
    GROUP BY CUST_STATE_PROVINCE
)
SELECT CUST_STATE_PROVINCE, 
RANK() OVER(ORDER BY CREDIT_LIMIT DESC) AS overall_RANK
FROM EACH_STATE;