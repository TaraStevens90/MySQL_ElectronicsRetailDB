/* Procedure 3: ASCII-Style Printed Receipt Output
                Script produces a single result set formatted as a retail printed receipt. */

/*  MUST RUN THIS IN "RESULTS TO TEXT" MODE FOR PROPER RECEIPT FORMAT.
    Instructions: Query → Results To → Results to Text → Execute (2nd time) */

/* Delete the procedure if it exists, I am running it multiple times for testing. */
DROP PROCEDURE IF EXISTS GetReceiptPaperASCII;
GO

/*Create the actual procedure */
CREATE PROCEDURE GetReceiptPaperASCII
    @OrderID INT

AS
BEGIN
    WITH ReceiptData AS (
        SELECT 
            c.FirstName + ' ' + c.LastName AS CustomerName,
            c.EmailAddress,
            o.OrderID,
            o.OrderDate,
            o.Subtotal,
            o.Tax,
            o.Amount,
            p.ProductName,
            oi.Quantity,
            oi.Price
        FROM Orders o
            JOIN Customers c
                ON o.CustomerID = c.CustomerID
            JOIN OrderItems oi
                ON o.OrderID = oi.OrderID
            JOIN Products p
                ON oi.ProductID = p.ProductID
        WHERE o.OrderID = @OrderID
    )

/* The SELECT/UNION ALL chain constructs a single ASCII‑formatted 
   receipt output instead of returning multiple relational result sets. 
   This builds a vertically structured, printer‑style receipt 
   similar to what a customer would receive at a retail checkout. */

    SELECT '========================================'
        UNION ALL SELECT '        Customer Purchase Receipt' /* Receipt header with decorative separators */
        UNION ALL SELECT '========================================'
        UNION ALL SELECT 'Customer:  ' + rd.CustomerName FROM ReceiptData rd GROUP BY rd.CustomerName  /*usually SELECT, FROM, and GROUP BY are seperate lines. */
        UNION ALL SELECT 'Email:     ' + rd.EmailAddress FROM ReceiptData rd GROUP BY rd.EmailAddress
        UNION ALL SELECT 'Order ID:  ' + CAST(rd.OrderID AS VARCHAR) FROM ReceiptData rd GROUP BY rd.OrderID
        UNION ALL SELECT 'Date:      ' + FORMAT(rd.OrderDate, 'yyyy-MM-dd') FROM ReceiptData rd GROUP BY rd.OrderDate /* GROUP BY is required because the source (ReceiptData CTE) 
                                                                                                                        contains multiple rows—one per product. GROUP BY ensures 
                                                                                                                        each header value appears only once. */
        UNION ALL SELECT '----------------------------------------'
        UNION ALL SELECT 'Qty        Product Name           Total'
        UNION ALL SELECT '----------------------------------------'
        UNION ALL SELECT 
          CAST(rd.Quantity AS VARCHAR) + '      ' + 
          LEFT(rd.ProductName, 24) + 
          SPACE(24 - LEN(LEFT(rd.ProductName, 24))) + ' ' +
          RIGHT(SPACE(1) + FORMAT(rd.Quantity * rd.Price, 'C2'), 10) /* LEFT() and SPACE() are used to align product names to a fixed width.
                                                                         RIGHT() ensures the line total is right‑aligned. */
    FROM ReceiptData rd
        UNION ALL SELECT '----------------------------------------'
        UNION ALL SELECT 'Subtotal:                       ' + FORMAT(rd.Subtotal, 'C2') FROM ReceiptData rd GROUP BY rd.Subtotal
        UNION ALL SELECT 'Tax:                             ' + FORMAT(rd.Tax, 'C2') FROM ReceiptData rd GROUP BY rd.Tax
        UNION ALL SELECT 'Total Amount:                   ' + FORMAT(rd.Amount, 'C2') FROM ReceiptData rd GROUP BY rd.Amount /* GROUP BY is again used to avoid duplicate rows */

        UNION ALL SELECT '========================================'
        UNION ALL SELECT 'Printed on:         ' + FORMAT(GETDATE(), 'yyyy-MM-dd hh:mm tt'); /* A Closing separator and a timestamp indicating when the receipt was generated. */
END;
GO

EXEC GetReceiptPaperASCII @OrderID = 29; /* Random test customer */