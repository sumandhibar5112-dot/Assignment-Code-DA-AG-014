##Question 6
-- Deletes the old database first
DROP DATABASE IF EXISTS ECommerceDB;

-- Creates it fresh
CREATE DATABASE ECommerceDB;
USE ECommerceDB;
-- Step 2: Create Tables
-- Note: Parent tables (Categories, Customers) are created first to satisfy Foreign Key constraints.

-- 2.1 Create Categories Table [cite: 34]
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,               -- [cite: 35]
    CategoryName VARCHAR(50) NOT NULL UNIQUE  -- [cite: 36]
);

-- 2.2 Create Customers Table [cite: 43]
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,               -- [cite: 44]
    CustomerName VARCHAR(100) NOT NULL,       -- [cite: 46]
    Email VARCHAR(100) UNIQUE,                -- [cite: 47]
    JoinDate DATE                             -- 
);

-- 2.3 Create Products Table [cite: 37]
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,                -- [cite: 38]
    ProductName VARCHAR(100) NOT NULL UNIQUE, -- [cite: 39]
    CategoryID INT,                           -- 
    Price DECIMAL(10,2) NOT NULL,             -- [cite: 41]
    StockQuantity INT,                        -- [cite: 42]
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) -- Links to Categories
);

-- 2.4 Create Orders Table [cite: 49]
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,                  -- [cite: 50]
    CustomerID INT,                           -- 
    OrderDate DATE NOT NULL,                  -- 
    TotalAmount DECIMAL(10,2),                -- [cite: 52]
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) -- Links to Customers
);

-- Step 3: Insert Records
-- Note: Data is inserted into Parent tables first.

-- 3.1 Insert Data into Categories [cite: 55]
INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Goods'),
(4, 'Apparel');

-- 3.2 Insert Data into Customers [cite: 61]
INSERT INTO Customers (CustomerID, CustomerName, Email, JoinDate) VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');

-- 3.3 Insert Data into Products [cite: 59]
INSERT INTO Products (ProductID, ProductName, CategoryID, Price, StockQuantity) VALUES
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook', 2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel: The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender X', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);

-- 3.4 Insert Data into Orders [cite: 66]
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 2, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);

##Question 7
SELECT 
    c.CustomerName, 
    c.Email, 
    COUNT(o.OrderID) AS TotalNumberofOrders
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID, c.CustomerName, c.Email
ORDER BY 
    c.CustomerName;
    
    #Question 8
    SELECT 
    p.ProductName, 
    p.Price, 
    p.StockQuantity, 
    c.CategoryName
FROM 
    Products p
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
ORDER BY 
    c.CategoryName ASC, 
    p.ProductName ASC;
    
    ##Question 9
    WITH ProductRankings AS (
    SELECT 
        c.CategoryName,
        p.ProductName,
        p.Price,
        RANK() OVER (PARTITION BY c.CategoryName ORDER BY p.Price DESC) as PriceRank
    FROM 
        Products p
    JOIN 
        Categories c ON p.CategoryID = c.CategoryID
)
SELECT 
    CategoryName, 
    ProductName, 
    Price
FROM 
    ProductRankings
WHERE 
    PriceRank <= 2;
    
    ##Question 10
 -- 1. Switch to the Sakila database
USE sakila;

-- 2. Run your query
SELECT 
    c.first_name, 
    c.last_name, 
    c.email, 
    SUM(p.amount) AS total_spent
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id
ORDER BY 
    total_spent DESC
LIMIT 5;