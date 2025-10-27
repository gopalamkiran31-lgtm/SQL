--C. Conditional, CASE, and DECODE 
SELECT CUST_INCOME_LEVEL FROM SH.CUSTOMERS

--1.Categorize customers into income tiers: Platinum, Gold, Silver, Bronze.

SELECT
    CUST_ID,
    CUST_FIRST_NAME,
    CUST_LAST_NAME,
    CUST_INCOME_LEVEL,
    CASE
        WHEN CUST_INCOME_LEVEL >=  250000  THEN 'PLATINUM',
        WHEN CUST_INCOME_LEVEL >=  170000  THEN 'GOLD',
        WHEN CUST_INCOME_LEVEL >=  130000 THEN 'SILVER',
        ELSE THEN 'BRONZE',
    END AS INCOMETIRES
FROM 
    SH.CUSTOMERS


--2.Display “High”, “Medium”, or “Low” income categories based on credit limit.

SELECT CUST_CREDIT_LIMIT from sh.customers

SELECT 
    CUST_ID,
    CUST_CREDIT_LIMIT,
    CASE
        WHEN CUST_CREDIT_LIMIT > 10000 then 'high'
        WHEN CUST_CREDIT_LIMIT > 5000  THEN 'MEDIUM'
        ELSE 'LOW'
    END AS INCOME_CATEGORIES
FROM
    SH.CUSTOMERS
ORDER BY INCOME_CATEGORIES DESC;

--3.Replace NULL income levels with “Unknown” using NVL.

SELECT
    CUST_ID,
    CUST_FIRST_NAME,
    CUST_LAST_NAME,
    NVL(CUST_INCOME_LEVEL, 'Unknown') AS INCOME
FROM
    SH.CUSTOMERS

--4.Show customer details and mark whether they have above-average credit limit or not.

SELECT
    cust_id,
    cust_fIRST_name,
    cust_credit_limit,
    CASE
        WHEN cust_credit_limit > (SELECT AVG(cust_credit_limit) FROM sh.customers) THEN 'Above Average'
        ELSE 'Not Above Average'
    END AS credit_status
FROM
    sh.customers;
 

--5.Use DECODE to convert marital status codes (S/M/D) into full text.

SELECT
    cust_id,
    cust_marital_status,
    DECODE(cust_marital_status,
           'S', 'Single',
           'M', 'Married',
           'D', 'Divorced',
           'Unknown') AS marital_status_full
FROM
    sh.customers;

--6.Use CASE to show age group (≤30, 31–50, >50) from CUST_YEAR_OF_BIRTH.

SELECT
    cust_id,
    CUST_YEAR_OF_BIRTH,
    (EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) AS age,
    CASE
        WHEN (EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) <= 30 THEN '≤30'
        WHEN (EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) BETWEEN 31 AND 50 THEN '31–50'
        WHEN (EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) > 50 THEN '>50'
        ELSE 'Unknown'
    END AS age_group
FROM
    sh.customers;

--7.Label customers as “Old Credit Holder” or “New Credit Holder” based on year of birth < 1980.

SELECT
    cust_id,
    cust_first_name,
    CUST_YEAR_OF_BIRTH,
    CASE
        WHEN CUST_YEAR_OF_BIRTH < 1980 THEN 'Old Credit Holder'
        ELSE 'New Credit Holder'
    END AS credit_holder_type
FROM
    sh.customers;

--8.Create a loyalty tag — “Premium” if credit limit > 50,000 and income_level = ‘E’.

SELECT
    cust_id,
    cust_credit_limit,
    cust_income_level,
    CASE
        WHEN cust_credit_limit > 50000 AND cust_income_level = 'E' THEN 'Premium'
        ELSE 'Standard'
    END AS loyalty_tag
FROM
    sh.customers;

--9.Assign grades (A–F) based on credit limit range using CASE.

SELECT
    cust_id,
    cust_credit_limit,
    CASE
        WHEN cust_credit_limit >= 12000 THEN 'A'
        WHEN cust_credit_limit >= 10000  THEN 'B'
        WHEN cust_credit_limit >= 7000  THEN 'C'
        WHEN cust_credit_limit >= 5000  THEN 'D'
        ELSE 'F'
    END AS credit_grade
FROM
    sh.customers;

--10.Show country, state, and number of premium customers using conditional aggregation.

SELECT
    country_id,
    cust_state_province,
    SUM(
        CASE
            WHEN cust_credit_limit > 50000 AND cust_income_level = 'E' THEN 1
            ELSE 0
        END
    ) AS premium_customer_count
FROM
    sh.customers
GROUP BY
    country_id,
    cust_state_province
ORDER BY
    country_id,
    cust_state_province;