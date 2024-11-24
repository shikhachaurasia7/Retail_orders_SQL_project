create database retail_orders;
use retail_orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(20),
    segment VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_id VARCHAR(50),
    quantity INT,
    discount DECIMAL(7,2),
    sale_price DECIMAL(7,2),
    profit DECIMAL(7,2)
);
select * from orders;
-- Find top 10 highest revenue generating products.
select product_id,sum(sale_price) as revenue from orders group by product_id order by revenue desc limit 10;

-- Find top 5 highest selling products in each region.
with cte as (select region,product_id,sum(sale_price) as sale from orders group by region ,product_id )
select * from (select *,row_number() over(partition by region order by sale desc) as top_5 from cte ) as A where top_5 <=5;

-- Find month over month growth comparsion for 2022 & 2023 sales eg: jan 2022 vs jan 2023.
with cte as(select year(order_date) as order_year , month (order_date) as order_month,sum(sale_price) as sales from orders group by
 order_year , order_month )
select order_month 
,sum(case when order_year=2022 then sales else 0 end )as sales_2022
,sum(case when order_year=2023 then sales else 0 end) as sales_2023
 from cte group by order_month order by order_month;
 
 -- for each category which month had highest sales.
with cte as (select  month(order_date) as order_month,year(order_date) as order_year,category ,sum(sale_price) as sales from orders group by order_month, 
order_year, category)
select * from (select * ,row_number() over(partition by category order by sales desc) as rk from cte) a where rk <=1;

-- which sub category had highest growth by profit in 2023 compare to 2022.
with cte as(select sub_category,year(order_date) as order_year , sum(sale_price) as sales from orders group by  
order_year, sub_category)
,cte2 as(
select sub_category,
sum(case when order_year=2022 then sales else 0 end)as sales_2022,
sum(case when order_year=2023 then sales else 0 end)as sales_2023
from cte group by sub_category )
select * , (sales_2023-sales_2022)as profit_compare_2023_2022 from cte2 order by profit_compare_2023_2022  desc limit 1;



