/* Stored Procedures to Generate a Receipt */

/* Switch to ElectronicsRetailDB */
USE ElectronicsRetailDB;
GO

/* Prevent duplication and errors as the script is tested. */
DROP PROCEDURE IF EXISTS GetReceiptTraditional;
GO

/* Procedure 1: Traditional SQL join receipt output (Standard Relational Format).
                Script produces one row per product purchased, customer name, product details, unit price, and total amount.
                Purpose: Demonstrates the traditional SQL join output used in normalized databases. */
CREATE PROCEDURE GetReceiptTraditional
    @OrderID INT
AS
BEGIN
    SELECT 
        c.FirstName + ' ' + c.LastName AS CustomerName, /* Concatenated the First and Last name fields into one column. */
        c.EmailAddress,
        o.OrderID,
        o.OrderDate,
        p.ProductName,
        oi.Quantity,
        FORMAT(oi.Price, 'C2') AS Price, /* Since this is a receipt I FORMATTED the currency but this is not best practice for performance. */
        FORMAT(oi.Quantity * oi.Price, 'C2') AS LineTotal,
        FORMAT(o.Subtotal, 'C2') AS Subtotal,
        FORMAT(o.Tax, 'C2') AS Tax,
        FORMAT(o.Amount, 'C2') AS TotalAmount
    FROM Orders o
        JOIN Customers c
            ON o.CustomerID = c.CustomerID
        JOIN OrderItems oi
            ON o.OrderID = oi.OrderID
        JOIN Products p
            ON oi.ProductID = p.ProductID
    WHERE o.OrderID = @OrderID
    ORDER BY p.ProductName;
END;
GO

EXEC GetReceiptTraditional 29; /* Random customer for testing */



/* Prevent duplication and errors as the script is tested. */     
DROP PROCEDURE IF EXISTS GetReceiptReadable;
GO

/* Procedure 2: Formats the receipt into a more human-readable style.
                The script uses three SELECT statements for: 
                 1) Customer + order info
                 2) Product list with quantities and line totals
                 3) Subtotal, tax, and total amount */
CREATE PROCEDURE GetReceiptReadable
    @OrderID INT
AS
BEGIN
    /* Customer and Order Info */
    SELECT 
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.EmailAddress,
        o.OrderID,
        o.OrderDate
    FROM Orders o
        JOIN Customers c
            ON o.CustomerID = c.CustomerID
    WHERE o.OrderID = @OrderID;

    /* Product List that is only one row per item and includes a LineTotal. */
    SELECT
        p.ProductName,
        oi.Quantity,
        FORMAT(oi.Price, 'C2') AS UnitPrice,
        FORMAT(oi.Quantity * oi.Price, 'C2') AS LineTotal
    FROM OrderItems oi
        JOIN Products p
            ON oi.ProductID = p.ProductID
    WHERE oi.OrderID = @OrderID
    ORDER BY p.ProductName;


    /* Totals on single row. */
    SELECT
        FORMAT(o.Subtotal, 'C2') AS Subtotal,
        FORMAT(o.Tax, 'C2') AS Tax,
        FORMAT(o.Amount, 'C2') AS TotalAmount
    FROM Orders o
    WHERE o.OrderID = @OrderID;
END;
GO

EXEC GetReceiptReadable 29; /* Same random customer */

/* See also ASCII_Style_StoredProcedures.sql in FinalProject Folder. */