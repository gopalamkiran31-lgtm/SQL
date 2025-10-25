--B. Analytical / Window Functions
SELECT * FROM SH.CUSTOMERS

--1.Assign row numbers to customers ordered by credit limit descending. 

SELECT 
    CUST_ID,
    CUST_LAST_NAME,
    CUST_CREDIT_LIMIT,
    ROW_NUMBER() OVER (ORDER BY CUST_CREDIT_LIMIT DESC) AS ROW_NUM
FROM 
    SH.CUSTOMERS;

--2.Rank customers within each state by credit limit.  

SELECT 
    CUST_ID,
    CUST_STATE_PROVINCE, 
    RANK() OVER(PARTITION BY CUST_STATE_PROVINCE ORDER BY CUST_CREDIT_LIMIT DESC) AS CUST_RANK
FROM
    SH.CUSTOMERS

--3.Use DENSE_RANK() to find the top 5 credit holders per country.  

SELECT *
FROM (
    SELECT
        CUST_ID,
        CUST_LAST_NAME,
        COUNTRY_ID,
        CUST_CREDIT_LIMIT,
        DENSE_RANK() OVER (
            PARTITION BY COUNTRY_ID
            ORDER BY CUST_CREDIT_LIMIT DESC
        ) AS CREDIT_RANK
    FROM
        SH.CUSTOMERS
)
WHERE CREDIT_RANK <= 5;

--4.Divide customers into 4 quartiles based on their credit limit using NTILE(4).

SELECT
    CUST_ID,
    CUST_LAST_NAME,
    CUST_FIRST_NAME,
    CUST_CREDIT_LIMIT,
    NTILE(4) OVER (ORDER BY CUST_CREDIT_LIMIT DESC) AS CREDIT_QUARTILE
FROM
    SH.CUSTOMERS;

--5.Calculate a running total of credit limits ordered by customer_id.

SELECT 
    CUST_ID,
    CUST_CREDIT_LIMIT,
    SUM(CUST_CREDIT_LIMIT) OVER(PARTITION BY CUST_CREDIT_LIMIT ORDER BY CUST_ID) 
    AS TOTAL_CREDIT
FROM 
    SH.CUSTOMERS

--6.Show cumulative average credit limit by country.

SELECT
    CUST_ID,
    COUNTRY_ID,
    CUST_CREDIT_LIMIT,
    AVG(CUST_CREDIT_LIMIT) OVER(ORDER BY COUNTRY_ID) AS cumulative
FROM
    SH.CUSTOMERS

--7.Compare each customer’s credit limit to the previous one using LAG().

SELECT
    CUST_ID,
    CUST_CREDIT_LIMIT,
    LAG(CUST_CREDIT_LIMIT) OVER(ORDER BY CUST_CREDIT_LIMIT) AS previous,
    CUST_CREDIT_LIMIT -  LAG(CUST_CREDIT_LIMIT) OVER(ORDER BY CUST_CREDIT_LIMIT) AS DIFF
FROM
    SH.customers

--8.Show next customer’s credit limit using LEAD().

SELECT
    CUST_ID,
    CUST_CREDIT_LIMIT,
    LEAD(CUST_CREDIT_LIMIT) OVER(ORDER BY CUST_CREDIT_LIMIT) AS nextCUST
FROM
    SH.CUSTOMERS

--9.Display the difference between each customer’s credit limit and the previous one.

SELECT
    CUST_ID,
    CUST_CREDIT_LIMIT,
    LAG(CUST_CREDIT_LIMIT) OVER(ORDER BY CUST_CREDIT_LIMIT) AS PREVIOUS,
    CUST_CREDIT_LIMIT - LAG(CUST_CREDIT_LIMIT) OVER(ORDER BY CUST_CREDIT_LIMIT) AS DIFF
FROM
    SH.CUSTOMERS

--10.For each country, display the first and last credit limit using FIRST_VALUE() and LAST_VALUE().

SELECT  
    CUST_ID,
    COUNTRY_ID,
    CUST_CREDIT_LIMIT,
    FIRST_VALUE(CUST_CREDIT_LIMIT) OVER (PARTITION BY COUNTRY_ID ORDER BY CUST_ID) AS FIRSTVALUE,
    LAST_VALUE(CUST_CREDIT_LIMIT) OVER (PARTITION BY COUNTRY_ID ORDER BY CUST_ID) AS LASTVALUE
FROM
    SH.CUSTOMERS

--11.Compute percentage rank (PERCENT_RANK()) of customers based on credit limit.

SELECT 
    CUST_ID,
    CUST_CREDIT_LIMIT,
    PERCENT_RANK() OVER(ORDER BY CUST_CREDIT_LIMIT) AS PERCENTAGE 
FROM 
    SH.CUSTOMERS

--12.Show each customer’s position in percentile (CUME_DIST() function).

SELECT
    CUST_ID,
    CUME_DIST() OVER (ORDER BY CUST_CREDIT_LIMIT) AS positionCUST
FROM
    SH.CUSTOMERS

--13.Display the difference between the maximum and current credit limit for each customer.

SELECT
    CUST_ID,
    CUST_CREDIT_LIMIT,
    MAX(CUST_CREDIT_LIMIT) OVER() AS MAX_CUST_CREDIT_LIMIT,
    MAX(CUST_CREDIT_LIMIT) OVER() - CUST_CREDIT_LIMIT AS difference
FROM
    SH.CUSTOMERS

--14.Rank income levels by their average credit limit.

SELECT
    CUST_INCOME_LEVEL,
    AVG(CUST_CREDIT_LIMIT) AS AVG_CUST_CREDIT_LIMIT,
    RANK() OVER(ORDER BY AVG(CUST_CREDIT_LIMIT)) AS RANKS
FROM
    SH.CUSTOMERS
GROUP BY 
    CUST_INCOME_LEVEL

--15.Calculate the average credit limit over the last 10 customers (sliding window).

SELECT
    CUST_ID,
    CUST_CREDIT_LIMIT,
    AVG(CUST_CREDIT_LIMIT) OVER (
        ORDER BY CUST_ID
        ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
    ) AS AVG_LAST_10
FROM
    SH.CUSTOMERS;


--16.For each state, calculate the cumulative total of credit limits ordered by city.

SELECT
    CUST_STATE_PROVINCE,
    CUST_CITY,
    CUST_CREDIT_LIMIT,
    SUM(CUST_CREDIT_LIMIT) OVER(
        PARTITION BY CUST_STATE_PROVINCE 
        ORDER BY CUST_CITY
        ) AS CUMETOTAL 
FROM
    SH.CUSTOMERS

--17.Find customers whose credit limit equals the median credit limit (use PERCENTILE_CONT(0.5)).

SELECT *
FROM (
    SELECT
        c.*,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CUST_credit_limit) 
            OVER () AS median_CUST_credit_limit
    FROM SH.customers c
)
WHERE CUST_credit_limit = median_CUST_credit_limit;

--18.Display the highest 3 credit holders per state using ROW_NUMBER() and PARTITION BY.

SELECT
    cust_id,
    CUST_LAST_name,
    CUST_state_PROVINCE,
    CUST_credit_limit
FROM (
    SELECT
        cust_id,
        CUST_LAST_name,
        CUST_state_PROVINCE,
        CUST_credit_limit,
        ROW_NUMBER() OVER (PARTITION BY CUST_state_PROVINCE ORDER BY CUST_credit_limit DESC) AS rn
    FROM SH.customers
) sub
WHERE rn <= 3
ORDER BY CUST_state_PROVINCE, rn;

--19.Identify customers whose credit limit increased compared to previous row (using LAG).

SELECT *
FROM (
    SELECT
        cust_id,
        CUST_FIRST_name,
        CUST_credit_limit,
        LAG(CUST_credit_limit) OVER (
            ORDER BY cust_id 
            ) AS prev_credit_limit
    FROM SH.customers
) sub
WHERE CUST_credit_limit > prev_credit_limit;

--20.Calculate moving average of credit limits with a window of 3.

SELECT
    cust_id,
    CUST_LAST_name,
    CUST_credit_limit,
    AVG(CUST_credit_limit) OVER (
        ORDER BY cust_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM SH.customers;

--21.Show cumulative percentage of total credit limit per country.

SELECT 
    COUNTRY_ID,
    TOTAL_CREDIT,
    ROUND(SUM(TOTAL_CREDIT) OVER (ORDER BY TOTAL_CREDIT DESC) /
          SUM(TOTAL_CREDIT) OVER () * 100, 2) AS CUMULATIVE_PERCENTAGE
FROM (
    SELECT 
        COUNTRY_ID,
        SUM(CUST_CREDIT_LIMIT) AS TOTAL_CREDIT
    FROM 
        SH.CUSTOMERS
    GROUP BY 
        COUNTRY_ID
)
ORDER BY 
    TOTAL_CREDIT DESC;

--22.Rank customers by age (derived from CUST_YEAR_OF_BIRTH).

SELECT 
    CUST_ID,
    CUST_FIRST_NAME,
    CUST_LAST_NAME,
    CUST_YEAR_OF_BIRTH,
    EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH AS AGE,
    RANK() OVER (ORDER BY CUST_YEAR_OF_BIRTH ASC) AS AGE_RANK
FROM 
    SH.CUSTOMERS
ORDER BY 
    AGE_RANK;

--23.Calculate difference in age between current and previous customer in the same state.

SELECT
    CUST_ID,
    CUST_FIRST_NAME,
    CUST_LAST_NAME,
    CUST_STATE_PROVINCE,
    EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH AS AGE,
    LAG(EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) 
        OVER (PARTITION BY CUST_STATE_PROVINCE ORDER BY CUST_YEAR_OF_BIRTH ASC) AS PREV_AGE,
    (EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) - 
    LAG(EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) 
        OVER (PARTITION BY CUST_STATE_PROVINCE ORDER BY CUST_YEAR_OF_BIRTH ASC) 
        AS AGE_DIFF_FROM_PREV
FROM 
    SH.CUSTOMERS
ORDER BY 
    CUST_STATE_PROVINCE,
    CUST_YEAR_OF_BIRTH;


--25.Compare each state’s average credit limit with country average using window partition.

SELECT
    CUST_ID,
    CUST_STATE_PROVINCE,
    COUNTRY_ID,
    CUST_CREDIT_LIMIT,
    ROUND(AVG(CUST_CREDIT_LIMIT) OVER (
        PARTITION BY CUST_STATE_PROVINCE), 2) AS AVG_STATE_CREDIT_LIMIT,
    
    ROUND(AVG(CUST_CREDIT_LIMIT) OVER (
        PARTITION BY COUNTRY_ID), 2) AS AVG_COUNTRY_CREDIT_LIMIT,
    
    ROUND(
        AVG(CUST_CREDIT_LIMIT) OVER (PARTITION BY CUST_STATE_PROVINCE) -
        AVG(CUST_CREDIT_LIMIT) OVER (PARTITION BY COUNTRY_ID), 2
    ) AS STATE_VS_COUNTRY_DIFF

FROM 
    SH.CUSTOMERS
ORDER BY 
    COUNTRY_ID, CUST_STATE_PROVINCE;


--26.Show total credit per state and also its rank within each country.

SELECT
    COUNTRY_ID,
    CUST_STATE_PROVINCE,
    SUM(CUST_CREDIT_LIMIT) AS TOTAL_CREDIT,
    RANK() OVER (
        PARTITION BY COUNTRY_ID 
        ORDER BY SUM(CUST_CREDIT_LIMIT) DESC
    ) AS STATE_RANK_IN_COUNTRY
FROM
    SH.CUSTOMERS
GROUP BY
    COUNTRY_ID,
    CUST_STATE_PROVINCE
ORDER BY
    COUNTRY_ID,
    STATE_RANK_IN_COUNTRY;

--27.Find customers whose credit limit is above the 90th percentile of their income level.xxx

SELECT
    cust_id,
    cust_income_level,
    cust_credit_limit,
FROM (
    SELECT cust_id,
           cust_income_level,
           cust_credit_limit,
           PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY cust_income_level desc) 
               OVER () AS income_90th_percentile
    FROM sh.customers
)
WHERE cust_credit_limit > income_90th_percentile;


--28.Display top 3 and bottom 3 customers per country by credit limit.

WITH ranked_customers AS (
    SELECT cust_id,
           country_id,
           cust_credit_limit,
           ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY cust_credit_limit DESC) AS rn_desc,
           ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY cust_credit_limit ASC) AS rn_asc
    FROM sh.customers
)
SELECT cust_id, country_id, cust_credit_limit
FROM ranked_customers
WHERE rn_desc <= 3 OR rn_asc <= 3
ORDER BY country_id, cust_credit_limit DESC;

--29.Calculate rolling sum of 5 customers’ credit limit within each country.

SELECT cust_id,
       country_id,
       cust_credit_limit,
       SUM(cust_credit_limit) OVER (
         PARTITION BY country_id 
         ORDER BY cust_id 
         ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
       ) AS rolling_sum_5
FROM sh.customers
ORDER BY country_id, cust_id;

--30.For each marital status, display the most and least wealthy customers using analytical functions.

WITH ranked_customers AS (
  SELECT cust_id,
         cust_marital_status,
         ROW_NUMBER() OVER (PARTITION BY cust_marital_status ORDER BY cust_income_level DESC) AS rn_highest,
         ROW_NUMBER() OVER (PARTITION BY cust_marital_status ORDER BY cust_income_level ASC) AS rn_lowest
  FROM sh.customers
)
SELECT cust_id,
       cust_marital_status,
       CASE 
         WHEN rn_highest = 1 THEN 'Most Wealthy'
         WHEN rn_lowest = 1 THEN 'Least Wealthy'
       END AS wealth_rank
FROM sh.customers
WHERE rn_highest = 1 || || rn_lowest = 1
ORDER BY cust_marital_status;