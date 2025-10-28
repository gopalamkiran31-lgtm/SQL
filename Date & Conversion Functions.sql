-- Date & Conversion Functions

--1.Convert CUST_YEAR_OF_BIRTH to age as of today.

SELECT
    CUST_ID,
    CUST_YEAR_OF_BIRTH,
    EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH AS AGE
FROM SH.CUSTOMERS

--2.Display all customers born between 1980 and 1990.

SELECT * FROM SH.CUSTOMERS WHERE CUST_YEAR_OF_BIRTH between 1980 AND  1990

--3.Format date of birth into “Month YYYY” using TO_CHAR.

SELECT 
    CUST_ID,
    TO_CHAR(TO_DATE(CUST_YEAR_OF_BIRTH || '-01-01', 'YYYY-MM-DD'), 'Month YYYY') AS DOB_FORMATTED
FROM SH.CUSTOMERS;

--4.Convert income level text (like 'A: Below 30,000') to numeric lower limit.

SELECT 
    CUST_ID,
    CUST_INCOME_LEVEL,
    CASE
        WHEN CUST_INCOME_LEVEL LIKE 'A:%' THEN 0
        WHEN CUST_INCOME_LEVEL LIKE 'B:%' THEN TO_NUMBER(REGEXP_SUBSTR(CUST_INCOME_LEVEL, '[0-9,]+')) 
        WHEN CUST_INCOME_LEVEL LIKE 'C:%' THEN TO_NUMBER(REGEXP_SUBSTR(CUST_INCOME_LEVEL, '[0-9,]+'))
        ELSE NULL
    END AS INCOME_LOWER_LIMIT
FROM SH.CUSTOMERS;


--5.Display customer birth decades (e.g., 1960s, 1970s).

SELECT 
    CUST_ID,
    CUST_YEAR_OF_BIRTH,
    TO_CHAR(TRUNC(CUST_YEAR_OF_BIRTH / 10) * 10) || 's' AS BIRTH_DECADE
FROM SH.CUSTOMERS;

--6.Show customers grouped by age bracket (10-year intervals).

SELECT 
    TRUNC((EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) / 10) * 10 AS AGE_BRACKET_START,
    TRUNC((EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) / 10) * 10 + 9 AS AGE_BRACKET_END,
    COUNT(*) AS NUM_CUSTOMERS
FROM SH.CUSTOMERS
WHERE CUST_YEAR_OF_BIRTH IS NOT NULL
GROUP BY TRUNC((EXTRACT(YEAR FROM SYSDATE) - CUST_YEAR_OF_BIRTH) / 10) * 10
ORDER BY AGE_BRACKET_START;

--7.Convert country_id to uppercase and state name to lowercase.

SELECT
    CUST_ID,
    COUNTRY_ID,
    UPPER(COUNTRY_ID) AS COUNTRY_ID_UPPER,
    LOWER(CUST_STATE_PROVINCE) AS STATE_NAME_LOWER
FROM SH.CUSTOMERS;

--8.Show customers where credit limit > average of their birth decade.


SELECT 
    CUST_ID,
    cust_year_of_BIRTH,
    cust_CREDIT_LIMIT
FROM sh.CUSTOMERS 
WHERE cust_CREDIT_LIMIT > (
    SELECT AVG(cust_CREDIT_LIMIT)
    FROM sh.CUSTOMERS
    WHERE TRUNC(cust_year_of_BIRTH / 10) * 10 = TRUNC(cust_year_of_BIRTH / 10) * 10
);

--9.Convert all numeric credit limits to currency format $999,999.00.

SELECT
    cust_id,
    cust_CREDIT_LIMIT,
    TO_CHAR(cust_CREDIT_LIMIT, '$999,999.00') as credit
from sh.customers

--10.Find customers whose credit limit was NULL and replace with average (using NVL).

SELECT
    CUST_ID,
     NVL(
        CUST_CREDIT_LIMIT,
        (SELECT AVG(cust_CREDIT_LIMIT) 
        FROM SH.CUSTOMERS 
        WHERE CUST_CREDIT_LIMIT IS NOT NULL)
    ) AS CREDIT_LIMIT_FILLED
from SH.CUSTOMERS