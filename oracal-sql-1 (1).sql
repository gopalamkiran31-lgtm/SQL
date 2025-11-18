1  --Find customers born after the year 1990.

select * from sh.customers where CUST_YEAR_OF_BIRTH > 1990

2  --List all male customers (`CUST_GENDER = 'M'`).

select * from sh.customers where cust_gender = 'M';

3  --Retrieve all female customers (`CUST_GENDER = 'F'`) living in Sydney.

select * from Sh.customers where cust_gender = 'F' AND cust_city = 'Sydney';

4   --Find customers with income level `"G: 130,000 - 149,999"`.

select * from Sh.customers where cust_income_level = 'G: 130,000 - 149,999';

5   --Get all customers with a credit limit above 10,000.

select * from Sh.customers where cust_credit_limit ='10000';

6   --Retrieve customers from the state "California".

select * from Sh.customers where cust_state_province = 'CA';

7   --Find customers who have provided an email address.

select * from Sh.customers where cust_email is not null

8   --List customers with missing marital status.

select * from Sh.customers where cust_marital_status is  null

9   --Find customers whose postal code starts with "53".

select * from sh.customers where cust_postal_code like '53%';

10  --Get customers born before 1980 with a credit limit above 5,000.


select * from sh.customers where CUST_YEAR_OF_BIRTH < 1980 and cust_credit_limit > 5000;

11  --Retrieve customers from Almere or Amersfoort.

select * from sh.customers where cust_city = 'Almere' or cust_city = 'Amersfoort';

select * from sh.customers where cust_city IN ('Almere', 'Amersfoort');

12  --Find customers who do not have a credit limit.

select * from Sh.customers where cust_credit_limit is null;

13  --List customers whose phone number starts with "487".

select * from sh.customers where cust_main_phone_number like '487%';

14  --Find married customers with income level `"Medium"`. 

select * from sh.customers where cust_marital_status = 'married' AND cust_income_level ='Medium' ;

15  --Get customers whose last name starts with "G".

select * from sh.customers where cust_last_name like 'G%';

16  --Find customers with city_id = 51057.

select * from sh.customers where cust_city_id = '51057';

17  -- Retrieve all customers who are valid (`CUST_VALID = 'A'`).

select * from sh.customers where cust_valid = 'A';

18  --Find customers whose effective start date (`CUST_EFF_FROM`) is after 2020.

select * from sh.customers where cust_eff_from > date '2020-12-31';

19  --Retrieve customers whose effective end date (`CUST_EFF_TO`) is before 2021.

select * from sh.customers where cust_eff_to < date '2021-01-01';

20  --Find customers with credit limit between 5,000 and 9,000.

select * from sh.customers where cust_credit_limit between 5000 and 9000;

21  --Get all customers from country_id = 101.

select * from sh.customers where country_id = '101';

22  --Find customers whose email ends with `"@company.example.com"`.

select * from sh.customers where cust_email like '%@company.example.com';

23  --List customers with `CUST_TOTAL_ID = 52772`.

select * from  sh.customers where CUST_TOTAL_ID = '52772';

24  --Find customers with `CUST_SRC_ID` in (10, 20, 30).

select * from sh.customers where CUST_SRC_ID IN(10, 20, 30);

25  --Retrieve customers who either do not have email or do not have a credit limit.

select * from sh.customers where cust_email is null or cust_credit_limit is null;


-----Questions on GROUP BY and HAVING

26  --Count the number of customers in each city.

select cust_city, Count(*) AS cust_count from sh.customers group by cust_city;

27  --Find cities with more than 100 customers.

select cust_city, count(*) AS cust_count from sh.customers  
group by cust_city Having count(*) > 100;

28  --Count the number of customers in each state.

select cust_state_province, count(*) as cust_count from sh.customers 
group by cust_state_province;

29  --Find states with fewer than 50 customers.

select cust_state_province, count(*) as cust_count from sh.customers 
group by cust_state_province having count(*) < 50;

30  --Calculate the average credit limit of customers in each city.

SELECT cust_city, AVG(cust_credit_limit) AS average_credit_limit FROM sh.customers 
GROUP BY cust_city;

31  --Find cities with average credit limit greater than 8,000.

SELECT cust_city, AVG(cust_credit_limit) AS average_credit_limit FROM sh.customers 
GROUP BY cust_city having AVG(cust_credit_limit) > 8000;

32  --Count customers by marital status.

select cust_marital_status, count(*) as cust_count from sh.customers 
group by cust_marital_status; 

33  --Find marital statuses with more than 200 customers.

select cust_marital_status, count(*) as cust_count from sh.customers 
group by cust_marital_status having count(*) > 200;

34  --Calculate the average year of birth grouped by gender.

select cust_gender, avg(CUST_YEAR_OF_BIRTH) as average_year_of_Birth 
from Sh.customers group by cust_gender;

35  --Find genders with average year of birth after 1990.

SELECT cust_gender, AVG(cust_YEAR_OF_BIRTH) AS avg_cust_year_of_birth FROM sh.customers 
GROUP BY cust_gender HAVING AVG(cust_YEAR_OF_BIRTH) > 1990;

36  --Count the number of customers in each country. 

select COUNTRY_ID, count(*) as cust_count from sh.customers group by COUNTRY_ID;

37  --Find countries with more than 1,000 customers. 

select COUNTRY_ID, count(*) as cust_count from sh.customers group by COUNTRY_ID having count(*) > 1000;

38  --Calculate the total credit limit per state.

select cust_state_province, sum(cust_credit_limit) as total_credit_limit 
from sh.customers group by cust_state_province;

39  --Find states where the total credit limit exceeds 100,000.

select cust_state_province, sum(cust_credit_limit) as total_credit_limit 
from sh.customers group by cust_state_province having total_credit_limit > 100000; 

40  --Find the maximum credit limit for each income level.

select cust_income_level, max(cust_credit_limit) as max_credit_limit 
from sh.customers group by cust_income_level;

41  --Find income levels where the maximum credit limit is greater than 15,000.

select cust_income_level, max(cust_credit_limit) as max_cust_credit_limit 
from sh.customers group by cust_income_level having max_cust_credit_limit > 15000;

-42 -Count customers by year of birth.

select CUST_YEAR_OF_BIRTH, count(*) as cust_total from sh.customers group by CUST_YEAR_OF_BIRTH;

43  --Find years of birth with more than 50 customers.

select CUST_YEAR_OF_BIRTH, count(*) as cust_total from sh.customers 
group by CUST_YEAR_OF_BIRTH having count(*) > 50;

44  --Calculate the average credit limit per marital status.

select cust_marital_status, avg(cust_credit_limit) as average_cust_credit_limit 
from sh.customers group by cust_marital_status;

45  --Find marital statuses with average credit limit less than 5,000

select cust_marital_status, avg(cust_credit_limit) as avg_cust_credit_limit 
from sh.customers group by cust_marital_status having avg_cust_credit_limit < 5000;

46  --Count the number of customers by email domain (e.g., `company.example.com`)

select cust_email, count(*) as cust_count from sh.customers group by cust_email;

47  --Find email domains with more than 300 customers.

select cust_email, count(*) as tota_cust from sh.customers group by cust_email having count(*) > 300;

48  --Calculate the average credit limit by validity (`CUST_VALID`).

select CUST_VALID, avg(cust_credit_limit) as avg_cust_credit_limit from sh.customers group by cust_valid;

49  --Find validity groups where the average credit limit is greater than 7,000.

select CUST_VALID, avg(cust_credit_limit) as avg_cust_credit_limit from sh.customers 
group by CUST_VALID having avg(cust_credit_limit) > 7000;

50  --Count the number of customers per state and city combination where there are more than 50 customers.

select cust_city, cust_state_province, count(*) as cust_count from sh.customers 
group by cust_city, cust_state_province having count(*) > 50;