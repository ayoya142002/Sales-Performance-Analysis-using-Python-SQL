USE Sales;

-------------------------------
--General Sales KPIs
-------------------------------

-- Total Sales
SELECT SUM(Sales) AS Total_Sales
FROM train$;

-- Average Sales
SELECT AVG(Sales) AS Avg_Sales
FROM train$;

-- Total Orders
SELECT COUNT(DISTINCT [Order ID]) AS Total_Orders
FROM train$;


-------------------------------
-- Customer Analysis
-------------------------------

-- Top Customer by Sales
SELECT TOP(1) [Customer Name], SUM(Sales) AS Customer_Sales
FROM train$
GROUP BY [Customer Name]
ORDER BY Customer_Sales DESC;

-- Top Customer by Number of Orders
SELECT TOP(1) [Customer Name], COUNT(DISTINCT [Order ID]) AS Customer_Orders
FROM train$
GROUP BY [Customer Name]
ORDER BY Customer_Orders DESC;

-- Average Sales per Customer
SELECT [Customer Name], AVG(Sales) AS Avg_Sales
FROM train$
GROUP BY [Customer Name]
ORDER BY Avg_Sales DESC;

-- Customer Summary Table
SELECT [Customer Name],
       SUM(Sales) AS Total_Customer_Sales,
       COUNT(DISTINCT [Order ID]) AS Total_Customer_Orders,
       AVG(Sales) AS Avg_Customer_Sales
FROM train$
GROUP BY [Customer Name]
ORDER BY Total_Customer_Sales DESC;


-------------------------------
-- Product Analysis
-------------------------------

-- Top Product by Sales
SELECT TOP(1) [Product Name], SUM(Sales) AS Total_Sales
FROM train$
GROUP BY [Product Name]
ORDER BY Total_Sales DESC;

-- Top 5 Products by Quantity Sold
SELECT TOP(5) [Product Name], COUNT([Product ID]) AS Product_Quantity
FROM train$
GROUP BY [Product Name]
ORDER BY Product_Quantity DESC;


-------------------------------
-- Regional & Category Analysis
-------------------------------

-- Average Sales per City
SELECT City, AVG(Sales) AS Avg_Sales
FROM train$
GROUP BY City
ORDER BY Avg_Sales DESC;

-- Most Sold Category per Region
SELECT *
FROM (
    SELECT Category,
           Region,
           SUM(Sales) AS Total_Sales,
           ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS RN
    FROM train$
    GROUP BY Region, Category
) AS Ranked
WHERE RN = 1;


-------------------------------
-- Time Series Analysis
-------------------------------

-- Top Product by Year
SELECT *
FROM (
    SELECT YEAR([Order Date]) AS Year,
           [Product Name],
           SUM(Sales) AS Total_Sales,
           ROW_NUMBER() OVER (PARTITION BY YEAR([Order Date]) ORDER BY SUM(Sales) DESC) AS RN
    FROM train$
    GROUP BY YEAR([Order Date]), [Product Name]
) AS Ranked
WHERE RN = 1;


-------------------------------
-- Monthly Customer Sales Comparison
-------------------------------

SELECT 
    [Customer Name],
    MONTH([Order Date]) AS Order_Month,
    SUM(Sales) AS Monthly_Sales,
    LAG(SUM(Sales)) OVER (PARTITION BY [Customer Name] ORDER BY MONTH([Order Date])) AS Prev_Month_Sales
FROM train$
GROUP BY [Customer Name], MONTH([Order Date])
ORDER BY [Customer Name], Order_Month;
