--QUESTION 1
-- Assuming the ProductDetail table:
CREATE TABLE ProductDetail (
  OrderID INT,
  CustomerName VARCHAR(50),
  Products VARCHAR(255)
);

-- Sample data:
INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Query to achieve 1NF by splitting products into individual rows
SELECT 
  OrderID,
  CustomerName,
  TRIM(product) AS Product
FROM
  ProductDetail,
  JSON_TABLE(
    CONCAT('["', REPLACE(Products, ',', '","'), '"]'),
    '$[*]' COLUMNS(product VARCHAR(50) PATH '$')
  ) AS jt;


--QUESTION 2
-- Create Orders table with no partial dependencies
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(50)
);

-- Create OrderDetails table with full dependency on composite key (OrderID, Product)
CREATE TABLE OrderDetails (
  OrderID INT,
  Product VARCHAR(50),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert distinct orders into Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM OrderDetailsRaw;

-- Insert details into OrderDetails table
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM OrderDetailsRaw;



