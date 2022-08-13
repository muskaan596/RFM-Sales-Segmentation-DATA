-- inspecting data
select * from data_for_sales

--checking unique values

select distinct year_id from data_for_sales
-- data available is on;y of 3 years viz 2003,2004,2005

select distinct status from data_for_sales
-- total 5 kind of status for orders viz resolved,on hold,cancelled,shipped,disputed,in process

select distinct PRODUCTLINE from data_for_sales
-- total 7 different product lines available  viz trains,motorcycles,ships,trucks and buses,vintage cars,classic cars,planes

select distinct city from data_for_sales
-- total 9 distinct cities are there

select distinct country from data_for_sales   -- 19 distinct countries
select distinct territory from data_for_sales -- 4 distinct territory
select distinct DEALSIZE from data_for_sales

--ANALYSIS
--Lets start by grouping sales by productline

--which product did the most sales
select productline,sum(sales) 
from data_for_sales
group by PRODUCTLINE
order by 2 desc

--in which year the sales were most and of which product
select year_id,sum(sales) 
from data_for_sales
group by year_id
order by 2 desc
-- in 2004 sales were most
-- why were the sales in 2005 very low
-- lets see how many months the sales happened for each year
select distinct month_id
from data_for_sales 
where year_id='2003' --12

select distinct month_id
from data_for_sales 
where year_id='2004' --12

select distinct month_id
from data_for_sales 
where year_id='2005' --5


--in any year which product has the most sales


select year_id,productline,sum(sales) total_sales
from data_for_sales 
group by year_id, productline
order by 1,3 desc


--which dealsize generates the most revenue
select dealsize,sum(sales) from data_for_sales
group by dealsize
order by 2
--medium dealsize generates the most revenue followed by small

-- what was the best month for sales in a specific year? how much was earned that month

select year_id,month_id,total_sales 
from 
(select year_id,month_id,sum(sales) total_sales 
from data_for_sales group by year_id,month_id) a
where 
total_sales in 
(select max(total_s) 
from 
(select year_id,sum(sales) total_s from data_for_sales group by year_id,month_id) b
group by year_id)

2003	11	1029837.66271973
2005	5	457861.06036377
2004	11	1089048.00762939

--november seems to be the month with increased sales for 2003 and 2004'

select year_id,month_id,total_sales,productline
from 
(select year_id,month_id,sum(sales) total_sales ,productline 
from data_for_sales group by year_id,month_id,productline) a
where total_sales in 
(select max(total_s) 
from 
(select year_id,sum(sales) total_s from data_for_sales group by year_id,month_id,productline) b
group by year_id)


2005	5	184385.109558105	Classic Cars
2003	11	452924.371887207	Classic Cars
2004	11	372231.88861084  	Classic Cars

-- classic cars are sold in the months where there is high amount of sales





--explain rfm ?
-- Recency-Frequency-Monetary
-- 1) It is an indexing technique that uses past purchase behavior to segment customers
-- 2) An RFM report is a way of segmenting customers using three key metrics:
--     a) recency - how long ago their last purchase was  (LAST ORDER DATE)
--     b) frequency - how often they purchase  (COUNT OF TOTAL ORDERS)
--     c) monetary value - how much they spent  (TOTAL SPEND)


-- --who is our best customer (this could be best answered with RFM)

--SELECT THE CUSTOMER WITH MOST ORDERS
DROP TABLE IF EXISTS #RFM

WITH RFM AS
(
SELECT 
	CUSTOMERNAME ,
	COUNT(ORDERNUMBER) FREQUENCY, 
	SUM(SALES) MONETARYVALUE,
	MAX(ORDERDATE) LAST_ORDER_DATE, 
	(SELECT MAX(ORDERDATE) FROM DATA_FOR_SALES) MAX_ORDER_DATE,
	DATEDIFF(DD,MAX(ORDERDATE),(SELECT MAX(ORDERDATE) FROM DATA_FOR_SALES MAX_ORDER_DATE)) RECENCY
FROM data_for_sales
GROUP BY CUSTOMERNAME
),
RFM_CALC AS
(
SELECT R.* , 
       NTILE(4) OVER (ORDER BY RECENCY) RFM_RECENCY,
	   NTILE(4) OVER (ORDER BY FREQUENCY) RFM_FREQ,
	   NTILE(4) OVER (ORDER BY MONETARYVALUE) RFM_MONETARY
FROM RFM R)

SELECT 
	C.*,RFM_RECENCY+RFM_FREQ+RFM_MONETARY RFM_CELL,
	CAST(RFM_RECENCY AS VARCHAR)+CAST(RFM_FREQ AS VARCHAR)+CAST(RFM_MONETARY AS VARCHAR) RFM_CELL_STRING
INTO #RFM
FROM RFM_CALC C

421 412 312 232 423 334 344 
SELECT * FROM #RFM

--1) A customer is lost when low recency ,freq could be high or low and monetary could be high or low 
-- ie 1,2 for recency and 1 to 4 for freq and monetary
--2) A customer is slipping away if recency is intemdiate and freq and monetary is high
--ie 1,2,3 for recency, and 3,4 for freq and monetary
--3) A customer is new if recency is high ie 3,4 and freq and monetary is low ie 1
--4) a customer is potential churn if recency is intermediate ie 2,3 and monetary and freq is intermediate ie 2,3
--5) a customer is active if recency and freq is high ie 3,4 and monetary could be low or high ie 1,2,3
--6) a customer is loyal if recency ,freq,monetary is high ie 3,4

select customername,rfm_recency,rfm_freq,rfm_monetary,
case 
when  rfm_cell_string in (111,112,113,114,121,122,123,124,132,141,211,212) then 'lost_customer'
when  rfm_cell_string in (133,134,143,144,233,244,234,243) then 'slipping away cannot lose'
when  rfm_cell_string in (311,331,411,421,412,312) then 'new customer'
when  rfm_cell_string in (222,223,233,322,232) then 'potential churner'
when  rfm_cell_string in (323,333,321,422,332,432,334,344) then 'active'
when  rfm_cell_string in (433,434,443,444,423) then 'loyal'
end rfm_segment

from #rfm



--what  products are most often sold together?



select ordernumber, count(*) rn
from data_for_sales
where status='Shipped'
group by ordernumber


select distinct OrderNumber, stuff(

	(select ',' + PRODUCTCODE
	from data_for_sales p
	where ORDERNUMBER in 
		(

			select ORDERNUMBER
			from (
				select ORDERNUMBER, count(*) rn
				FROM data_for_sales
				where STATUS = 'Shipped'
				group by ORDERNUMBER
			)m
			where rn >3
		)
		and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path (''))

		, 1, 1, '') ProductCodes

from data_for_sales s
order by 2 desc












