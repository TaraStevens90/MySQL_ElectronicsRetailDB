/* Script prepared by: Tara Stevens
   Course: CIS261 - SQL I
   Assignment: Final Project
   Instructor: Professor Gaspard Mucundanyi
   Institution: Pierce College
   Quarter: Winter 2026
   

   Title: ElectronicsRetailDB
   Purpose: A sample database for an electronics retail business. The database
            includes four core tables (Customers, Products, Orders, and OrderItems)
            and is populated with realistic sample data. The schema follows best 
            practices, including IDENTITY primary keys, NOT NULL constraints, and properly
            defined foreign key relationships. */

USE master; 
GO

/* Drop the database if it already exists.
   This ensures the script can be run repeatedly during testing without errors.
   I had to include single-user and roll back as I kept getting a DB currently in use error. */
IF DB_ID('ElectronicsRetailDB') IS NOT NULL
BEGIN
    ALTER DATABASE ElectronicsRetailDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ElectronicsRetailDB;
END

/* Create Database */
CREATE DATABASE ElectronicsRetailDB;
GO

/* Switch to correct database after it is created. */
USE ElectronicsRetailDB;
GO


/* Design Notes:
   • All primary keys use IDENTITY to auto-generate unique values.
   • Columns have been defined with NOT NULL to enforce data integrity.
   • Table-level foreign keys are used to maintain referential integrity between tables.
   • DECIMAL was chosen as a more precise datatype for currency rather than MONEY to 
     reduce rounding errors.
   • Only essential constraints are included. I wanted to keep the design a simple 
     introductory SQL project.
   • The default collation is used and indexing was kept minimal focusing
     only on foreign keys.   Tara S. */


/* Create Customers table. */
CREATE TABLE dbo.Customers ( 
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL UNIQUE
);

/* Create Products table. */
CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    ListPrice DECIMAL(10,2) NOT NULL
);

/* Create Orders table. */
CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL, /* Only a date as I didn't think time was a necessary inclusion. */
    Subtotal DECIMAL(10,2) NOT NULL, /* 2 decimal places. */
    Tax DECIMAL(10,2) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_Orders_Customers /* This is an optional name given to the foreign key below. Decided to keep foreign keys at table-level rather than in-line for best practice. */
            FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);

/* Create OrderItems table. */
CREATE TABLE dbo.OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL, /* Did not chose money datatype. */
        CONSTRAINT FK_OrderItems_Orders /* Same as above, table‑level foreign key constraint with a custom name. */
            FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
        CONSTRAINT FK_OrderItems_Products
            FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO


/* Orders foreign key indexes */
CREATE INDEX IX_Orders_CustomerID 
    ON dbo.Orders(CustomerID);

CREATE INDEX IX_Orders_OrderDate 
    ON dbo.Orders(OrderDate);

/* OrderItems foreign key indexes */
CREATE INDEX IX_OrderItems_OrderID 
    ON dbo.OrderItems(OrderID);

CREATE INDEX IX_OrderItems_ProductID 
    ON dbo.OrderItems(ProductID);
GO


/* Insert 53 customers into Customers table. */
INSERT INTO dbo.Customers
    (FirstName, LastName, EmailAddress)
VALUES 
    ('John', 'Doe', 'john.doe@example.com'),
    ('Jane', 'Smith', 'jane.smith@example.com'),
    ('Alice', 'Johnson', 'alice.johnson@example.com'),
    ('Olivia', 'Hartman', 'olivia.hartman@example.com'),
    ('Marcus', 'Delaney', 'marcus.delaney@example.com'),
    ('Priya', 'Shah', 'priya.shah@example.com'),
    ('Ethan', 'Caldwell', 'ethan.caldwell@example.com'),
    ('Sofia', 'Ramirez', 'sofia.ramirez@example.com'),
    ('Daniel', 'Whitaker', 'daniel.whitaker@example.com'),
    ('Amina', 'Yusuf', 'amina.yusuf@example.com'),
    ('Lucas', 'Brenner', 'lucas.brenner@example.com'),
    ('Naomi', 'Fletcher', 'naomi.fletcher@example.com'),
    ('Gabriel', 'Montes', 'gabriel.montes@example.com'),
    ('Hannah', 'Kimura', 'hannah.kimura@example.com'),
    ('Julian', 'Price', 'julian.price@example.com'),
    ('Talia', 'Nguyen', 'talia.nguyen@example.com'),
    ('Xavier', 'Brooks', 'xavier.brooks@example.com'),
    ('Lila', 'Sorenson', 'lila.sorenson@example.com'),
    ('Andre', 'Baptiste', 'andre.baptiste@example.com'),
    ('Mei', 'Zhang', 'mei.zhang@example.com'),
    ('Rowan', 'Pierce', 'rowan.pierce@example.com'),
    ('Selene', 'Vargas', 'selene.vargas@example.com'),
    ('Carter', 'Ellison', 'carter.ellison@example.com'),
    ('Jasmine', 'Patel', 'jasmine.patel@example.com'),
    ('Owen', 'Gallagher', 'owen.gallagher@example.com'),
    ('Bianca', 'Costa', 'bianca.costa@example.com'),
    ('Hiro', 'Tanaka', 'hiro.tanaka@example.com'),
    ('Elena', 'Markovic', 'elena.markovic@example.com'),
    ('Caleb', 'Jennings', 'caleb.jennings@example.com'),
    ('Fatima', 'Al-Sayed', 'fatima.alsayed@example.com'),
    ('Noah', 'Stein', 'noah.stein@example.com'),
    ('Ruby', 'O''Connell', 'ruby.oconnell@example.com'),
    ('Jorge', 'Castillo', 'jorge.castillo@example.com'),
    ('Amara', 'Okafor', 'amara.okafor@example.com'),
    ('Declan', 'Murphy', 'declan.murphy@example.com'),
    ('Sienna', 'Blake', 'sienna.blake@example.com'),
    ('Tobias', 'Richter', 'tobias.richter@example.com'),
    ('Maya', 'Kapoor', 'maya.kapoor@example.com'),
    ('Zane', 'Holloway', 'zane.holloway@example.com'),
    ('Isabella', 'Duarte', 'isabella.duarte@example.com'),
    ('Rafael', 'Mendes', 'rafael.mendes@example.com'),
    ('Chloe', 'Armstrong', 'chloe.armstrong@example.com'),
    ('Darius', 'Coleman', 'darius.coleman@example.com'),
    ('Helena', 'Fischer', 'helena.fischer@example.com'),
    ('Arjun', 'Mehta', 'arjun.mehta@example.com'),
    ('Vivian', 'Cross', 'vivian.cross@example.com'),
    ('Miles', 'Harrington', 'miles.harrington@example.com'),
    ('Keiko', 'Mori', 'keiko.mori@example.com'),
    ('Sergio', 'Alvarez', 'sergio.alvarez@example.com'),
    ('Tessa', 'Monroe', 'tessa.monroe@example.com'),
    ('Brandon', 'Holt', 'brandon.holt@example.com'),
    ('Nadia', 'Petrova', 'nadia.petrova@example.com'),
    ('Elliot', 'Chambers', 'elliot.chambers@example.com');


/* Insert 50 electronic products into the Products table. */
INSERT INTO dbo.Products 
    (ProductName, ListPrice)
VALUES
    ('Wireless Mouse', 24.99),
    ('Mechanical Keyboard', 89.50),
    ('USB-C Charging Cable', 12.99),
    ('27-inch LED Monitor', 199.99),
    ('Bluetooth Headphones', 59.95),
    ('Laptop Stand', 34.50),
    ('Webcam 1080p', 49.99),
    ('Portable SSD 1TB', 129.00),
    ('Ergonomic Office Chair', 249.99),
    ('Smartphone Tripod', 22.50),
    ('Noise-Cancelling Earbuds', 79.99),
    ('Gaming Controller', 54.99),
    ('Wireless Charger Pad', 18.99),
    ('4K Action Camera', 149.00),
    ('LED Desk Lamp', 27.99),
    ('Graphics Tablet', 89.00),
    ('Smartwatch Band', 14.99),
    ('HDMI Cable 6ft', 9.99),
    ('Portable Bluetooth Speaker', 39.99),
    ('USB Flash Drive 64GB', 11.49),
    ('External Hard Drive 2TB', 79.00),
    ('Wireless Presenter Remote', 24.50),
    ('Adjustable Standing Desk', 329.99),
    ('Noise-Isolation Headset', 69.99),
    ('USB-C Hub 6-in-1', 34.99),
    ('1080p Portable Projector', 159.00),
    ('Smart LED Light Strip', 19.99),
    ('Bluetooth Numeric Keypad', 17.99),
    ('Gaming Mouse Pad XL', 14.50),
    ('Wi-Fi Range Extender', 39.50),
    ('Portable Power Bank 20,000mAh', 29.99),
    ('Smart Home Plug', 12.49),
    ('Wireless Doorbell Camera', 89.99),
    ('USB Microphone', 59.00),
    ('Laptop Cooling Pad', 21.99),
    ('Bluetooth Car Adapter', 16.99),
    ('4-Port USB Wall Charger', 13.99),
    ('Smart Thermostat', 129.99),
    ('VR Headset', 249.00),
    ('Portable Photo Printer', 99.00),
    ('LED Ring Light', 25.99),
    ('Wireless Barcode Scanner', 74.99),
    ('Smartwatch Charging Dock', 15.99),
    ('USB-C to HDMI Adapter', 11.99),
    ('Bluetooth Trackball Mouse', 49.50),
    ('Mechanical Pencil Set', 8.99),
    ('Desk Organizer Tray', 12.99),
    ('Noise-Reducing Foam Panels', 29.99),
    ('Portable Document Scanner', 119.00),
    ('Rechargeable AA Battery Pack', 24.99);

/* Insert 75 sample orders into the Orders table. */
INSERT INTO dbo.Orders 
    (CustomerID, OrderDate, Subtotal, Tax, Amount) /* Standard WA Tax rate of 8.9% used. */
VALUES
    (12, '2022-03-14', 90.96, 8.10, 99.06),
    (7,  '2022-06-02', 148.98, 13.26, 162.24),
    (12, '2023-01-22', 107.92, 9.61, 117.53),
    (3,  '2023-09-10', 218.98, 19.49, 238.47),
    (19, '2024-02-05', 150.95, 13.43, 164.38),
    (4,  '2022-11-18', 104.95, 9.35, 114.30),
    (22, '2023-03-09', 84.98, 7.56, 92.54),
    (4,  '2023-07-21', 180.97, 16.11, 197.08),
    (15, '2024-01-11', 177.94, 15.84, 193.78),
    (9,  '2024-04-03', 158.96, 14.15, 173.11),
    (6,  '2022-12-04', 72.96, 6.49, 79.45),
    (14, '2023-02-17', 89.93, 8.00, 97.93),
    (6,  '2023-08-29', 154.99, 13.79, 168.78),
    (28, '2024-03-14', 158.96, 14.15, 173.11),
    (10, '2024-05-22', 235.96, 21.00, 256.96),
    (17, '2022-10-07', 99.96, 8.90, 108.86),
    (30, '2023-04-11', 85.94, 7.65, 93.59),
    (17, '2023-10-19', 160.48, 14.28, 174.76),
    (11, '2024-02-28', 255.96, 22.78, 278.74),
    (26, '2024-06-12', 141.95, 12.63, 154.58),
    (8,  '2022-09-03', 72.96, 6.49, 79.45),
    (24, '2023-03-27', 89.93, 8.00, 97.93),
    (8,  '2023-11-08', 166.48, 14.82, 181.30),
    (32, '2024-02-19', 122.97, 10.95, 133.92),
    (5,  '2024-06-30', 261.95, 23.31, 285.26),
    (13, '2022-08-15', 70.96, 6.32, 77.28),
    (21, '2023-04-02', 92.93, 8.27, 101.20),
    (13, '2023-10-25', 153.48, 13.66, 167.14),
    (29, '2024-03-08', 156.96, 13.97, 170.93),
    (2,  '2024-07-14', 270.95, 24.12, 295.07),
    (16, '2022-07-22', 69.96, 6.23, 76.19),
    (23, '2023-05-14', 89.93, 8.00, 97.93),
    (16, '2023-11-03', 154.99, 13.79, 168.78),
    (20, '2024-03-01', 135.96, 12.10, 148.06),
    (7,  '2024-07-09', 258.95, 23.05, 282.00),
    (18, '2022-06-11', 60.96, 5.43, 66.39),
    (27, '2023-04-30', 101.93, 9.07, 111.00),
    (18, '2023-10-12', 166.48, 14.82, 181.30),
    (33, '2024-02-07', 135.96, 12.10, 148.06),
    (4,  '2024-07-02', 258.95, 23.05, 282.00),
    (31, '2022-05-29', 57.96, 5.16, 63.12),
    (12, '2023-04-18', 101.93, 9.07, 111.00),
    (31, '2023-11-14', 166.48, 14.82, 181.30),
    (22, '2024-02-11', 135.96, 12.10, 148.06),
    (14, '2024-07-18', 258.95, 23.05, 282.00),
    (25, '2022-04-21', 60.96, 5.43, 66.39),
    (9,  '2023-05-02', 101.93, 9.07, 111.00),
    (25, '2023-11-22', 166.48, 14.82, 181.30),
    (6,  '2024-02-15', 135.96, 12.10, 148.06),
    (18, '2024-07-26', 258.95, 23.05, 282.00),
    (10, '2022-03-19', 57.96, 5.16, 63.12),
    (28, '2023-04-09', 101.93, 9.07, 111.00),
    (10, '2023-11-27', 166.48, 14.82, 181.30),
    (19, '2024-02-22', 135.96, 12.10, 148.06),
    (33, '2024-07-30', 258.95, 23.05, 282.00),
    (7,  '2022-04-04', 60.96, 5.43, 66.39),
    (20, '2023-05-19', 101.93, 9.07, 111.00),
    (7,  '2023-12-03', 166.48, 14.82, 181.30),
    (16, '2024-03-04', 135.96, 12.10, 148.06),
    (30, '2024-08-01', 258.95, 23.05, 282.00),
    (11, '2022-05-12', 57.96, 5.16, 63.12),
    (26, '2023-06-08', 101.93, 9.07, 111.00),
    (11, '2023-12-14', 166.48, 14.82, 181.30),
    (34, '2024-03-18', 135.96, 12.10, 148.06),
    (15, '2024-08-09', 258.95, 23.05, 282.00),
    (22, '2022-06-27', 60.96, 5.43, 66.39),
    (29, '2023-06-22', 101.93, 9.07, 111.00),
    (22, '2023-12-19', 166.48, 14.82, 181.30),
    (17, '2024-03-26', 135.96, 12.10, 148.06),
    (8,  '2024-08-14', 258.95, 23.05, 282.00),
    (5,  '2022-07-08', 57.96, 5.16, 63.12),
    (14, '2023-07-03', 101.93, 9.07, 111.00),
    (5,  '2023-12-28', 166.48, 14.82, 181.30),
    (23, '2024-04-02', 135.96, 12.10, 148.06),
    (32, '2024-08-20', 258.95, 23.05, 282.00);


/* Inserted 241 OrderItems to the OrderItems table to compliment 75 orders total. */
INSERT INTO dbo.OrderItems 
    (OrderID, ProductID, Quantity, Price)
VALUES
    (1, 1, 2, 24.99),
    (1, 3, 1, 12.99),
    (1, 15, 1, 27.99),
    (2, 8, 1, 129.00),
    (2, 18, 2, 9.99),
    (2, 27, 1, 19.99),
    (2, 35, 1, 21.99),
    (3, 8, 1, 129.00),
    (4, 4, 1, 199.99),
    (4, 13, 1, 18.99),
    (5, 11, 1, 79.99),
    (5, 31, 1, 29.99),
    (5, 47, 1, 12.99),
    (5, 37, 2, 13.99),
    (6, 7, 1, 49.99),
    (6, 1, 1, 24.99),
    (6, 18, 3, 9.99),
    (7, 12, 1, 54.99),
    (7, 31, 1, 29.99),
    (8, 8, 1, 129.00),
    (8, 27, 2, 19.99),
    (8, 44, 1, 11.99),
    (9, 5, 1, 59.95),
    (9, 40, 1, 99.00),
    (9, 13, 1, 18.99),
    (10, 21, 1, 79.00),
    (10, 1, 2, 24.99),
    (10, 36, 1, 16.99),
    (10, 47, 1, 12.99),
    (11, 3, 2, 12.99),
    (11, 1, 1, 24.99),
    (11, 35, 1, 21.99),
    (12, 5, 1, 59.95),
    (12, 27, 1, 19.99),
    (12, 18, 1, 9.99),
    (13, 8, 1, 129.00),
    (13, 41, 1, 25.99),
    (14, 11, 1, 79.99),
    (14, 31, 2, 29.99),
    (14, 13, 1, 18.99),
    (15, 47, 1, 12.99),
    (16, 1, 1, 24.99),
    (16, 12, 1, 54.99),
    (16, 18, 2, 9.99),
    (17, 5, 1, 59.95),
    (17, 41, 1, 25.99),
    (18, 8, 1, 129.00),
    (18, 27, 1, 19.99),
    (18, 20, 1, 11.49),
    (19, 4, 1, 199.99),
    (19, 31, 1, 29.99),
    (19, 47, 2, 12.99),
    (20, 11, 1, 79.99),
    (20, 36, 1, 16.99),
    (20, 13, 1, 18.99),
    (20, 3, 2, 12.99),
    (21, 1, 1, 24.99),
    (21, 3, 2, 12.99),
    (21, 35, 1, 21.99),
    (22, 5, 1, 59.95),
    (22, 18, 1, 9.99),
    (22, 27, 1, 19.99),
    (23, 8, 1, 129.00),
    (23, 41, 1, 25.99),
    (23, 20, 1, 11.49),
    (24, 11, 1, 79.99),
    (24, 31, 1, 29.99),
    (24, 47, 1, 12.99),
    (25, 4, 1, 199.99),
    (25, 13, 1, 18.99),
    (25, 36, 1, 16.99),
    (25, 3, 2, 12.99),
    (26, 1, 1, 24.99),
    (26, 18, 2, 9.99),
    (26, 41, 1, 25.99),
    (27, 5, 1, 59.95),
    (27, 27, 1, 19.99),
    (27, 3, 1, 12.99),
    (28, 8, 1, 129.00),
    (28, 20, 1, 11.49),
    (28, 47, 1, 12.99),
    (29, 11, 1, 79.99),
    (29, 31, 2, 29.99),
    (29, 36, 1, 16.99),
    (30, 4, 1, 199.99),
    (30, 13, 1, 18.99),
    (30, 3, 2, 12.99),
    (30, 41, 1, 25.99),
    (31, 1, 1, 24.99),
    (31, 3, 1, 12.99),
    (31, 35, 1, 21.99),
    (31, 18, 1, 9.99),
    (32, 5, 1, 59.95),
    (32, 27, 1, 19.99),
    (32, 18, 1, 9.99),
    (33, 8, 1, 129.00),
    (33, 41, 1, 25.99),
    (34, 11, 1, 79.99),
    (34, 31, 1, 29.99),
    (34, 47, 1, 12.99),
    (34, 3, 1, 12.99),
    (35, 4, 1, 199.99),
    (35, 13, 1, 18.99),
    (35, 36, 1, 16.99),
    (35, 20, 2, 11.49),
    (36, 1, 1, 24.99),
    (36, 3, 2, 12.99),
    (36, 18, 1, 9.99),
    (37, 5, 1, 59.95),
    (37, 27, 1, 19.99),
    (37, 35, 1, 21.99),
    (38, 8, 1, 129.00),
    (38, 41, 1, 25.99),
    (38, 20, 1, 11.49),
    (39, 11, 1, 79.99),
    (39, 31, 1, 29.99),
    (39, 47, 1, 12.99),
    (39, 3, 1, 12.99),
    (40, 4, 1, 199.99),
    (40, 13, 1, 18.99),
    (40, 36, 1, 16.99),
    (40, 20, 2, 11.49),
    (41, 1, 1, 24.99),
    (41, 3, 1, 12.99),
    (41, 18, 2, 9.99),
    (42, 5, 1, 59.95),
    (42, 27, 1, 19.99),
    (42, 35, 1, 21.99),
    (43, 8, 1, 129.00),
    (43, 41, 1, 25.99),
    (43, 20, 1, 11.49),
    (44, 11, 1, 79.99),
    (44, 31, 1, 29.99),
    (44, 47, 1, 12.99),
    (44, 3, 1, 12.99),
    (45, 4, 1, 199.99),
    (45, 13, 1, 18.99),
    (45, 36, 1, 16.99),
    (45, 20, 2, 11.49),
    (46, 1, 1, 24.99),
    (46, 3, 2, 12.99),
    (46, 18, 1, 9.99),
    (47, 5, 1, 59.95),
    (47, 27, 1, 19.99),
    (47, 35, 1, 21.99),
    (48, 8, 1, 129.00),
    (48, 41, 1, 25.99),
    (48, 20, 1, 11.49),
    (49, 11, 1, 79.99),
    (49, 31, 1, 29.99),
    (49, 47, 1, 12.99),
    (49, 3, 1, 12.99),
    (50, 4, 1, 199.99),
    (50, 13, 1, 18.99),
    (50, 36, 1, 16.99),
    (50, 20, 2, 11.49),
    (51, 1, 1, 24.99),
    (51, 3, 1, 12.99),
    (51, 18, 2, 9.99),
    (52, 5, 1, 59.95),
    (52, 27, 1, 19.99),
    (52, 35, 1, 21.99),
    (53, 8, 1, 129.00),
    (53, 41, 1, 25.99),
    (53, 20, 1, 11.49),
    (54, 11, 1, 79.99),
    (54, 31, 1, 29.99),
    (54, 47, 1, 12.99),
    (54, 3, 1, 12.99),
    (55, 4, 1, 199.99),
    (55, 13, 1, 18.99),
    (55, 36, 1, 16.99),
    (55, 20, 2, 11.49),
    (56, 11, 1, 79.99),
    (56, 31, 1, 29.99),
    (56, 47, 1, 12.99),
    (56, 3, 1, 12.99),
    (57, 4, 1, 199.99),
    (57, 13, 1, 18.99),
    (57, 36, 1, 16.99),
    (57, 20, 2, 11.49),
    (58, 1, 1, 24.99),
    (58, 3, 2, 12.99),
    (58, 18, 1, 9.99),
    (59, 5, 1, 59.95),
    (59, 27, 1, 19.99),
    (59, 35, 1, 21.99),
    (60, 8, 1, 129.00),
    (60, 41, 1, 25.99),
    (60, 20, 1, 11.49),
    (61, 11, 1, 79.99),
    (61, 31, 1, 29.99),
    (61, 47, 1, 12.99),
    (61, 3, 1, 12.99),
    (62, 4, 1, 199.99),
    (62, 13, 1, 18.99),
    (62, 36, 1, 16.99),
    (62, 20, 2, 11.49),
    (63, 1, 1, 24.99),
    (63, 3, 1, 12.99),
    (63, 18, 2, 9.99),
    (64, 5, 1, 59.95),
    (64, 27, 1, 19.99),
    (64, 35, 1, 21.99),
    (65, 8, 1, 129.00),
    (65, 41, 1, 25.99),
    (65, 20, 1, 11.49),
    (66, 11, 1, 79.99),
    (66, 31, 1, 29.99),
    (66, 47, 1, 12.99),
    (66, 3, 1, 12.99),
    (67, 4, 1, 199.99),
    (67, 13, 1, 18.99),
    (67, 36, 1, 16.99),
    (67, 20, 2, 11.49),
    (68, 1, 1, 24.99),
    (68, 3, 2, 12.99),
    (68, 18, 1, 9.99),
    (69, 5, 1, 59.95),
    (69, 27, 1, 19.99),
    (69, 35, 1, 21.99),
    (70, 8, 1, 129.00),
    (70, 41, 1, 25.99),
    (70, 20, 1, 11.49),
    (71, 11, 1, 79.99),
    (71, 31, 1, 29.99),
    (71, 47, 1, 12.99),
    (71, 3, 1, 12.99),
    (72, 4, 1, 199.99),
    (72, 13, 1, 18.99),
    (72, 36, 1, 16.99),
    (72, 20, 2, 11.49),
    (73, 1, 1, 24.99),
    (73, 3, 2, 12.99),
    (73, 18, 1, 9.99),
    (74, 5, 1, 59.95),
    (74, 27, 1, 19.99),
    (74, 35, 1, 21.99),
    (75, 8, 1, 129.00),
    (75, 41, 1, 25.99),
    (75, 20, 1, 11.49);