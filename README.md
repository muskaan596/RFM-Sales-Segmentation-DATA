# RFM-Sales-Segmentation-DATA
The Dataset has 2832 rows and 25 columns. Data is available for 3 years viz 2003,2004,2005.
DataExploration has been done using SQL 
## Following insights were drawn:
- In 2004, the sales were the most , followed by 2003
- The reason that in 2005 the sales were poor because the data available for 2005 is only upto 5th month of the year
- Classic cars is the most sold product in all the years.
- Medium dealsize generates the most revenue and large dealsize generates the least revenue
- year            month            total_sales
  2003	           11	           1029837.66271973
  2005	            5	            457861.06036377
  2004	           11	           1089048.00762939
- November seems to be the month with most sales 

-    year         month            sales           product
     2005	          5	         184385.109558105	  Classic Cars
     2003	          11	       452924.371887207	  Classic Cars
     2004	          11	       372231.88861084  	Classic Cars
- classic cars are most sold in the months where there is huge amount of sales
## Who is the best customer ? 
This could be answered by RFM
# Explain RFM ?
-- Recency-Frequency-Monetary
-- 1) It is an indexing technique that uses past purchase behavior to segment customers
-- 2) An RFM report is a way of segmenting customers using three key metrics:
--     a) recency - how long ago their last purchase was  (LAST ORDER DATE)
--     b) frequency - how often they purchase  (COUNT OF TOTAL ORDERS)
--     c) monetary value - how much they spent  (TOTAL SPEND)
1) A customer is lost when low recency ,freq could be high or low and monetary could be high or low 
 ie 1,2 for recency and 1 to 4 for freq and monetary
2) A customer is slipping away if recency is intemdiate and freq and monetary is high
ie 1,2,3 for recency, and 3,4 for freq and monetary
3) A customer is new if recency is high ie 3,4 and freq and monetary is low ie 1
4) a customer is potential churn if recency is intermediate ie 2,3 and monetary and freq is intermediate ie 2,3
5) a customer is active if recency and freq is high ie 3,4 and monetary could be low or high ie 1,2,3
6) a customer is loyal if recency ,freq,monetary is high ie 3,4

