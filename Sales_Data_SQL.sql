CREATE DATABASE Sales_Data;

DESCRIBE Sales_Data_CSV;

SELECT * FROM Sales_Data_CSV LIMIT 10;

#Query 1:Calculate total sales and quantity sold for each product in January 2019
SELECT 
    `Product`, 
    SUM(`Quantity Ordered`) AS Total_Units_Sold, 
    SUM(`Sales Price`) AS Total_Revenue
FROM 
    Sales_Data_CSV
WHERE 
    `Order Date` BETWEEN '01-01-2019' AND '31-01-2019'
GROUP BY 
    `Product`
ORDER BY 
    Total_Units_Sold DESC;

#Query 2:Weekly sales for each product in January
SELECT 
    `Product`, 
    CASE 
        WHEN `Order Date` BETWEEN '01-01-2019' AND '06-01-2019' THEN 'Week 1'
        WHEN `Order Date` BETWEEN '07-01-2019' AND '13-01-2019' THEN 'Week 2'
        WHEN `Order Date` BETWEEN '14-01-2019' AND '20-01-2019' THEN 'Week 3'
        WHEN `Order Date` BETWEEN '21-01-2019' AND '27-01-2019' THEN 'Week 4'
        WHEN `Order Date` BETWEEN '28-01-2019' AND '31-01-2019' THEN 'Week 5'
        ELSE 'Unknown Week' 
    END AS Sales_Week,
    SUM(`Quantity Ordered`) AS Weekly_Units_Sold
FROM 
    Sales_Data_CSV
WHERE 
    `Order Date` BETWEEN '01-01-2019' AND '31-01-2019'
GROUP BY 
    `Product`, Sales_Week
ORDER BY 
    Sales_Week, `Product`;
    
#Query 3:Forecast demand for February based on January's weekly average- Assuming consistent Sells trend
SELECT 
    `Product`, 
    AVG(`Quantity Ordered`) * 4 AS Forecast_February_Units
FROM 
    Sales_Data_CSV
WHERE 
    `Order Date` BETWEEN '01-01-2019' AND '31-01-2019'
GROUP BY 
    `Product`;
    
#Query 4:Calculate daily sales and reorder point based on contribution to total revenue- Assuming lead time = 7 days
SELECT 
    `Product`, 
    SUM(`Quantity Ordered`) / 31 AS Avg_Daily_Units_Sold, 
    (SUM(`Quantity Ordered`) / 31) * 7 AS Reorder_Point, -- Lead time = 7 days
    SUM(`Quantity Ordered` * `Price Each`) AS Total_Revenue,
    (SUM(`Quantity Ordered` * `Price Each`) / (SELECT SUM(`Quantity Ordered` * `Price Each`) FROM Sales_Data_CSV)) * 100 AS Revenue_Contribution_Percentage
FROM 
    Sales_Data_CSV
WHERE 
    `Order Date` BETWEEN '01-01-2019' AND '31-01-2019'
GROUP BY 
    `Product`
ORDER BY 
    Total_Revenue DESC;
