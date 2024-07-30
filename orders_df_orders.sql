Select * from orders.df_orders;
-- Top 10 Highest Revenue Generating Products
SELECT product_id,sum(sale_price) as amount  FROM orders.df_orders
group by product_id 
Order by amount desc
Limit 10;

-- Top 5 Highest Selling Products in Each Region
with cte as (SELECT region,product_id,sum(sale_price) as amount  FROM orders.df_orders
group by region,product_id)
Select * from (Select *,
row_number() over(partition by region order by amount desc) as rn
from cte) as A
where rn<=5;

-- Find Month over Month growth comparison for 2022 and 2023 sales eg jan 2022 vs jan 2023
with cte as (Select year(order_date) as order_year,month(order_date) as order_month,sum(sale_price) as sales
 From orders.df_orders
 group by year(order_date),month(order_date))
 Select order_month,
 Sum(Case when order_year=2022 then sales else 0 End) as sales_2022,
 Sum(Case when order_year=2023 then sales else 0 End) as sales_2023
 From cte
 group by order_month
 order by order_month;
 
 -- For each category which month had highest sales
 with cte as (Select category,sum(sale_price) as sales,month(order_date) as month
 from orders.df_orders
 group by category,month)
Select * from (Select *,
row_number() over( partition by category order by sales desc) as rnk
 from cte) as B
 where rnk=1;
 
 -- Which category had highest growth by profit in 2023 compare to 2022
 with cte1 as (Select sub_category,sum(sale_price) as sales,year(order_date) as order_year from orders.df_orders
 group by sub_category,year(order_date))
 
 ,cte2 as (Select sub_category,
 Sum(Case when order_year= 2022 then sales else 0 End) as sales_2022,
 Sum(Case when order_year= 2023 then sales else 0 End) as sales_2023
 From cte1
 group by sub_category) 
 Select *, (((sales_2023/sales_2022)-1)*100) as growth from cte2
 order by (((sales_2023/sales_2022)-1)*100) desc
 limit 1;
 
 

