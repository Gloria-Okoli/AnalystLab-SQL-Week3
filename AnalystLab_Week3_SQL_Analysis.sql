-- ============================================================
-- AnalystLab Africa Data Analytics Internship — Batch B 2026
-- Week 3: SQL & Data Querying
-- Prepared by: Gloria Okoli | June 2026
-- ============================================================

-- ============================================================
-- DATASET 1: CHINOOK DATABASE (Music Store)
-- ============================================================

USE Chinook;

-- Query 1: View all customersS
SELECT * FROM Customer;

-- Query 2: Top 10 countries by customer count
SELECT TOP 10 Country, COUNT(*) AS TotalCustomers
FROM Customer
GROUP BY Country
ORDER BY TotalCustomers DESC;

-- Query 3: Top 10 customers by total spending (INNER JOIN)
SELECT TOP 10 c.CustomerId, c.FirstName, c.LastName,
SUM(i.Total) AS TotalSpent
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY TotalSpent DESC;

-- Query 4: Total revenue by country
SELECT BillingCountry, SUM(Total) AS TotalRevenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC;

-- Query 5: Top 10 best selling tracks (INNER JOIN)
SELECT TOP 10 t.Name AS TrackName,
SUM(il.Quantity) AS TotalSold
FROM Track t
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY t.Name
ORDER BY TotalSold DESC;

-- Query 6: Revenue by genre (Multiple JOINs)
SELECT g.Name AS Genre,
SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM Genre g
INNER JOIN Track t ON g.GenreId = t.GenreId
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY g.Name
ORDER BY TotalRevenue DESC;

-- Query 7: Customers who spent above average (Subquery)
SELECT c.FirstName, c.LastName, SUM(i.Total) AS TotalSpent
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName
HAVING SUM(i.Total) > (SELECT AVG(Total) FROM Invoice)
ORDER BY TotalSpent DESC;

-- Query 8: Rank customers by total spending (Window Function)
SELECT c.FirstName, c.LastName,
SUM(i.Total) AS TotalSpent,
RANK() OVER (ORDER BY SUM(i.Total) DESC) AS SpendingRank
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName;

-- Query 9: Monthly revenue trend
SELECT FORMAT(InvoiceDate, 'yyyy-MM') AS Month,
SUM(Total) AS MonthlyRevenue
FROM Invoice
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY Month ASC;


-- ============================================================
-- DATASET 2: SALES DATASET (AdventureWorks/Kaggle)
-- ============================================================

USE SalesData;

-- Query 1: Total revenue by product line
SELECT PRODUCTLINE, SUM(SALES) AS TotalRevenue
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY TotalRevenue DESC;

-- Query 2: Top 10 customers by revenue
SELECT TOP 10 CUSTOMERNAME, SUM(SALES) AS TotalSpent
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY TotalSpent DESC;

-- Query 3: Total revenue by year
SELECT YEAR_ID, SUM(SALES) AS AnnualRevenue
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY YEAR_ID ASC;

-- Query 4: Orders by status
SELECT STATUS, COUNT(*) AS TotalOrders
FROM sales_data_sample
GROUP BY STATUS
ORDER BY TotalOrders DESC;

-- Query 5: Revenue by country
SELECT COUNTRY, SUM(SALES) AS TotalRevenue
FROM sales_data_sample
GROUP BY COUNTRY
ORDER BY TotalRevenue DESC;

-- Query 6: Average order value by deal size
SELECT DEALSIZE, AVG(SALES) AS AvgOrderValue,
COUNT(*) AS TotalOrders
FROM sales_data_sample
GROUP BY DEALSIZE
ORDER BY AvgOrderValue DESC;

-- Query 7: Rank customers by revenue (Window Function)
SELECT CUSTOMERNAME, SUM(SALES) AS TotalRevenue,
RANK() OVER (ORDER BY SUM(SALES) DESC) AS RevenueRank
FROM sales_data_sample
GROUP BY CUSTOMERNAME;

-- Query 8: Product lines above average sales (Subquery)
SELECT PRODUCTLINE, SUM(SALES) AS TotalRevenue
FROM sales_data_sample
GROUP BY PRODUCTLINE
HAVING SUM(SALES) > (SELECT AVG(SALES) FROM sales_data_sample)
ORDER BY TotalRevenue DESC;
