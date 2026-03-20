/* Some common retail stored procedures. */

/* Switch to ElectronicsRetailDB */
USE ElectronicsRetailDB;
GO


/* Daily sales summary for specific day */
DROP PROCEDURE IF EXISTS GetDailySalesSummary; /* always using drop first since I am running script multiple times. */
GO

CREATE PROCEDURE GetDailySalesSummary /* Create the actual procedure */
    @Date DATE
AS
BEGIN
    SELECT
        @Date AS SalesDate,
        COUNT(*) AS TotalOrders,
        FORMAT(SUM(Amount), 'C2') AS TotalSales, /* formated currency in most procedures below. This is not ideal in production environment as it impacts performance. */
        FORMAT(AVG(Amount), 'C2') AS AverageOrderAmount
    FROM Orders
    WHERE CAST(OrderDate AS DATE) = @Date;
END;
GO

EXEC GetDailySalesSummary '2024-05-22'; /* Random date */



/* A monthly sales summary for a specific month of a year. */
DROP PROCEDURE IF EXISTS GetSalesByMonth;
GO

CREATE PROCEDURE GetSalesByMonth
    @Year INT,
    @Month INT
AS
BEGIN
    SELECT
        @Year AS SalesYear,
        DATENAME(MONTH, DATEFROMPARTS(@Year, @Month, 1)) AS SalesMonth,
        COUNT(*) AS TotalOrders,
        FORMAT(SUM(Amount), 'C2') AS TotalSales,
        FORMAT(AVG(Amount), 'C2') AS AverageOrderAmount
    FROM Orders
    WHERE YEAR(OrderDate) = @Year
      AND MONTH(OrderDate) = @Month;
END;
GO

EXEC GetSalesByMonth 2024, 7; /* Random month and year */



/* Yearly sales summary for a specific year */
DROP PROCEDURE IF EXISTS GetSalesByYear;
GO

CREATE PROCEDURE GetSalesByYear
    @Year INT
AS
BEGIN
    SELECT
        @Year AS SalesYear,
        COUNT(*) AS TotalOrders,
        FORMAT(SUM(Amount), 'C2') AS TotalSales,
        FORMAT(AVG(Amount), 'C2') AS AverageOrderAmount
    FROM Orders
    WHERE YEAR(OrderDate) = @Year;
END;
GO

EXEC GetSalesByYear 2024; /* Random year */



/* Total all-time sale w/ average order amount */
DROP PROCEDURE IF EXISTS GetTotalSales;
GO

CREATE PROCEDURE GetTotalSales
AS
BEGIN
    SELECT 
        FORMAT(SUM(Amount), 'C2') AS AllTimeTotalSales,
        FORMAT(AVG(Amount), 'C2') AS AverageOrderAmount
    FROM Orders;
END;
GO

EXEC GetTotalSales;


/* Product sales summary w/units sold and total revenue */
DROP PROCEDURE IF EXISTS GetProductSalesSummary;
GO

CREATE PROCEDURE GetProductSalesSummary
AS
BEGIN
    SELECT
        p.ProductName,
        SUM(oi.Quantity) AS TotalUnitsSold,
        FORMAT(SUM(oi.Quantity * oi.Price), 'C2') AS TotalRevenue
    FROM OrderItems oi
        JOIN Products p 
            ON oi.ProductID = p.ProductID
    GROUP BY p.ProductName
    ORDER BY SUM(oi.Quantity * oi.Price) DESC;  /* Results sorted by revenue */
END;
GO

EXEC GetProductSalesSummary;



/* Report of top 5 best-selling products */
DROP PROCEDURE IF EXISTS GetTop5BestSellingProducts;
GO

CREATE PROCEDURE GetTop5BestSellingProducts
AS
BEGIN
    SELECT TOP 5
        p.ProductName,
        SUM(oi.Quantity) AS Top5TotalUnitsSold,
        FORMAT(SUM(oi.Quantity * oi.Price), 'C2') AS Top5TotalRevenue
    FROM OrderItems oi
        JOIN Products p 
            ON oi.ProductID = p.ProductID
    GROUP BY p.ProductName
    ORDER BY SUM(oi.Quantity) DESC;
END;
GO

 EXEC GetTop5BestSellingProducts;


/* A customer spend summary */
DROP PROCEDURE IF EXISTS GetCustomerSpendSummary;
GO

CREATE PROCEDURE GetCustomerSpendSummary
AS
BEGIN
    SELECT
        c.CustomerID,
        c.FirstName + ' ' + c.LastName AS CustomerName, /* Concatenated customer First and Last name. */
        c.EmailAddress,
        COUNT(o.OrderID) AS OrderCount,
        FORMAT(SUM(o.Amount), 'C2') AS TotalSpent,
        FORMAT(AVG(o.Amount), 'C2') AS AvgOrderAmount,
        FORMAT(MAX(o.Amount), 'C2') AS MaxOrderAmount,
        FORMAT(MIN(o.Amount), 'C2') AS MinOrderAmount
    FROM Orders o
        JOIN Customers c 
            ON o.CustomerID = c.CustomerID
    GROUP BY 
        c.CustomerID, 
        c.FirstName, 
        c.LastName, 
        c.EmailAddress
    ORDER BY c.CustomerID;
END;
GO

EXEC GetCustomerSpendSummary;


/* Specific customer spend summary */
DROP PROCEDURE IF EXISTS GetCustomerPurchaseHistory;
GO

CREATE PROCEDURE GetCustomerPurchaseHistory
    @CustomerID INT
AS
BEGIN
    SELECT
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.EmailAddress,
        o.OrderID,
        o.OrderDate,
        FORMAT(o.Amount, 'C2') AS TotalAmount
    FROM Orders o
        JOIN Customers c 
            ON o.CustomerID = c.CustomerID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate DESC;
END;
GO

EXEC GetCustomerPurchaseHistory 12; /* Random customer */