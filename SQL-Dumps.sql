CREATE TABLE Suppliers (
    Supplier_ID INT PRIMARY KEY,
    Supplier_Name VARCHAR(255),
    Location_Code INT,
    Contact_Person VARCHAR(255),
    Other_Details VARCHAR(255)
);

DESC Suppliers;

CREATE TABLE Shippers (
    Shipper_ID INT PRIMARY KEY,
    Shipper_Name VARCHAR(255)
);

DESC Shippers;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Cust_Name VARCHAR(255),
    Cust_Locale INT,
    Payment_Code INT,
    Cust_Details VARCHAR(255)
);

DESC Customers;

CREATE TABLE Sales (
    Sales_ID INT PRIMARY KEY,
    Salesperson INT,
    Order_Status VARCHAR(50),
    Customer_ID INT REFERENCES Customers(Customer_ID)
);

DESC sales;

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Order_Status VARCHAR(50),
    Sales_ID INT REFERENCES Sales(Sales_ID)
);

DESC Orders;

CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(255),
    Product_Description VARCHAR(255),
    Price INT,
    Supplier_ID INT REFERENCES Suppliers(Supplier_ID),
    Status VARCHAR(50)
);

DESC Products;

CREATE TABLE Invoices (
    Invoice_ID INT PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Invoice_Amt DECIMAL(10,2),
    Inv_Date DATE,
    Shipper_ID INT REFERENCES Shippers(Shipper_ID),
    Order_ID INT REFERENCES Orders(Order_ID)
);

DESC Invoices;

CREATE TABLE Order_Items (
    Order_Items_ID INT PRIMARY KEY,
    Order_ID INT REFERENCES Orders(Order_ID),
    Invoice_ID INT REFERENCES Invoices(Invoice_ID),
    Product_ID INT REFERENCES Products(Product_ID),
    Quantity INT
);

DESC Order_Items;

--------------------------------------------------------------------------------
INSERT INTO Suppliers (Supplier_ID, Supplier_Name, Location_Code, Contact_Person, Other_Details)
VALUES (1, 'Electronics Hub', 101, 'John Smith', 'Main electronics supplier');
INSERT INTO Suppliers (Supplier_ID, Supplier_Name, Location_Code, Contact_Person, Other_Details)
VALUES (2, 'Fashion Trends', 102, 'Alice Johnson', 'Supplier for clothing and accessories');
INSERT INTO Suppliers (Supplier_ID, Supplier_Name, Location_Code, Contact_Person, Other_Details)
VALUES (3, 'Tech Gadgets', 103, 'Robert Brown', 'Specialized in cutting-edge gadgets');

Select * from Suppliers;




INSERT INTO Shippers (Shipper_ID, Shipper_Name) VALUES (100, 'UPS');
INSERT INTO Shippers (Shipper_ID, Shipper_Name) VALUES (110, 'DHL');
INSERT INTO Shippers (Shipper_ID, Shipper_Name) VALUES (120, 'FedEx');

Select * from shippers;

INSERT INTO Customers (Customer_ID, Cust_Name, Cust_Locale, Payment_Code, Cust_Details)
VALUES (200, 'Bhuvan', 201, 301, 'Regular customer');
INSERT INTO Customers (Customer_ID, Cust_Name, Cust_Locale, Payment_Code, Cust_Details)
VALUES (201, 'Alice', 202, 302, 'New customer');
INSERT INTO Customers (Customer_ID, Cust_Name, Cust_Locale, Payment_Code, Cust_Details)
VALUES (202, 'Robert', 203, 303, 'Tech enthusiast');

select * from Customers;

INSERT INTO Sales (Sales_ID, Salesperson, Order_Status, Customer_ID)
VALUES (501, 101, 'Pending', 200);
INSERT INTO Sales (Sales_ID, Salesperson, Order_Status, Customer_ID)
VALUES    (502, 102, 'Shipped', 201);
INSERT INTO Sales (Sales_ID, Salesperson, Order_Status, Customer_ID)
VALUES (503, 103, 'Processing', 200);

Select * from sales;


INSERT INTO Products (Product_ID, Product_Name, Product_Description, Price, Supplier_ID, Status) VALUES (1, 'Laptop', 'High-performance laptop', 1200.00, 1, 'Available');
INSERT INTO Products (Product_ID, Product_Name, Product_Description, Price, Supplier_ID, Status) VALUES (2, 'T-Shirt', 'Cotton T-shirt', 20.00, 2, 'In stock');
INSERT INTO Products (Product_ID, Product_Name, Product_Description, Price, Supplier_ID, Status) VALUES (3, 'Bluetooth Speaker', 'Portable speaker with Bluetooth', 50.00, 3, 'Available');

SELECT * FROM Products;

select * from orders;

select * from order_items;


CREATE SEQUENCE seq_invoices
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_order_items
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_orders
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;



ALTER TABLE PRODUCTS ADD QUANTITY_ON_HAND INT;

SELECT * FROM PRODUCTS;

UPDATE SALES SET Salesperson = '';

COMMIT;

ALTER TABLE SALES MODIFY Salesperson VARCHAR(30);

UPDATE SALES SET Salesperson = 'LOKI' WHERE sales_id = 501;
UPDATE SALES SET Salesperson = 'RAMU' WHERE sales_id = 502;
UPDATE SALES SET Salesperson = 'ANJI' WHERE sales_id = 503;



 COMMIT;

SELECT * FROM SALES; 

-- --Inserting values to Suppliers
INSERT INTO Suppliers (Supplier_ID, Supplier_Name, Location_Code, Contact_Person, Other_Details)
VALUES (4, 'Office Supply', 104, 'Ram', 'All Office Supply Items');

commit;

select * from suppliers;

-- --Inserting values to Products 
INSERT INTO Products (Product_ID, Product_Name, Product_Description, Price, Supplier_ID, Status,QUANTITY_ON_HAND) 
VALUES (4, 'Sticky Note', 'Office Supply', 20.00, 4, 'Available',50);

commit;

select * from Products;





CREATE OR REPLACE PROCEDURE create_order_and_invoice(
    p_customer_id IN NUMBER,
    p_product_id IN NUMBER,
    p_quantity IN NUMBER,
    p_shipper_id IN NUMBER,
    p_sales_id IN NUMBER
) AS
    v_order_id NUMBER;
    v_invoice_id NUMBER;
    v_invoice_amt NUMBER;
    v_available_quantity NUMBER;
BEGIN
    -- Start the transaction
    BEGIN
        -- Check if the requested quantity is available
        SELECT QUANTITY_ON_HAND
        INTO v_available_quantity
        FROM Products
        WHERE Product_ID = p_product_id;

        IF p_quantity > v_available_quantity THEN
            -- Raise an exception if the requested quantity is not available
            RAISE_APPLICATION_ERROR(-20001, 'Requested quantity is out of stock');
        END IF;

        -- Insert into Orders table
        INSERT INTO Orders (Order_ID, Customer_ID, Order_Status, Sales_ID)
        VALUES (seq_orders.nextval, p_customer_id, 'Pending', p_sales_id)
        RETURNING Order_ID INTO v_order_id;

        -- Calculate invoice amount (you may need to adjust this calculation)
        SELECT p.Price * p_quantity
        INTO v_invoice_amt
        FROM Products p
        WHERE p.Product_ID = p_product_id;

        -- Insert into Invoices table
        INSERT INTO Invoices (Invoice_ID, Customer_ID, Invoice_Amt, Inv_Date, Shipper_ID, Order_ID)
        VALUES (seq_invoices.nextval, p_customer_id, v_invoice_amt, SYSDATE, p_shipper_id, v_order_id)
        RETURNING Invoice_ID INTO v_invoice_id;

        -- Insert into Order_Items table
        INSERT INTO Order_Items (Order_Items_ID, Order_ID, Invoice_ID, Product_ID, Quantity)
        VALUES (seq_order_items.nextval, v_order_id, v_invoice_id, p_product_id, p_quantity);

        -- Commit the transaction
        COMMIT;
    EXCEPTION
        -- Rollback the transaction in case of any exception
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;
END create_order_and_invoice;
/


BEGIN
    create_order_and_invoice(202,3, 1, 120,503); 
END;

SELECT * FROM ORDERS;

SELECT * FROM ORDER_ITEMS;

SELECT * FROM INVOICES;

COMMIT;


CREATE OR REPLACE TRIGGER trg_update_product_quantity
AFTER INSERT ON Order_Items
FOR EACH ROW
DECLARE
    v_new_quantity NUMBER;
BEGIN
    -- Retrieve the current quantity
    SELECT QUANTITY_ON_HAND INTO v_new_quantity
    FROM Products
    WHERE Product_ID = :NEW.Product_ID;

    -- Calculate the new quantity
    v_new_quantity := v_new_quantity - :NEW.Quantity;

    -- Update the product quantity
    UPDATE Products
    SET QUANTITY_ON_HAND = v_new_quantity
    WHERE Product_ID = :NEW.Product_ID;
    
    -- Commit the update
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if needed
        NULL;
END;
/

select * from products;




BEGIN
    create_order_and_invoice(200,4, 2, 120,503); 
END;

select * from orders;

select * from order_items;

select * from invoices;

select * from products;

SELECT o.Order_ID, o.Customer_ID, oi.Product_ID, p.Product_Name, oi.Quantity,i.shipper_id
FROM Orders o INNER JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
INNER JOIN products p ON o.Order_ID = p.product_id INNER JOIN invoices i on o.Order_ID = i.order_id
where p.product_id = 4;

CREATE TABLE SupplierNotification (
    Notification_ID INT PRIMARY KEY,
    Supplier_ID INT REFERENCES Suppliers(Supplier_ID),
    Message VARCHAR(300),
    NotificationDate DATE
);

INSERT INTO SupplierNotification (Notification_ID,Supplier_ID, Message,NotificationDate)
VALUES (1,4,'The product_id 4 Sticky Note of quantity 2 is removed from supply inventry','08-DEC-2023');

select * from suppliernotification;


UPDATE ORDERS SET ORDER_STATUS='Shipped' WHERE ORDER_ID='1';

SELECT * FROM ORDERS;

commit;

SELECT * FROM ORDER_ITEMS;

CREATE TABLE CustomerAlerts (
    Alert_ID INT PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Message VARCHAR2(255),
    AlertDate DATE
);

INSERT INTO CustomerAlerts (Alert_ID,Customer_ID,Message, AlertDate)
VALUES(1,200,'Your Product is Shipped','09-DEC-2023');

commit;

SELECT * FROM CustomerAlerts;

UPDATE SALES
SET ORDER_STATUS = 'Shipped'
WHERE SALES_ID = (SELECT SALES_ID FROM ORDERS WHERE ORDER_ID = '1');

SELECT * FROM SALES;

CREATE TABLE CustomerServiceAlerts (
    Alert_ID INT PRIMARY KEY,
    Order_ID INT REFERENCES Orders(Order_ID),
    Message VARCHAR2(255),
    AlertDate DATE
);

INSERT INTO CustomerServiceAlerts (Alert_ID, Order_ID, Message, AlertDate)
VALUES (1, 1, 'Customer order processed; contact customer upon delivery.', SYSDATE);

SELECT * FROM customerservicealerts;

SELECT * FROM  ORDERS;


--Remove order_status from the sales table
ALTER TABLE SALES DROP COLUMN ORDER_STATUS;
ALTER TABLE SALES DROP COLUMN Customer_ID;

SELECT * FROM SALES; 

--Add Shipping ID to order table
ALTER TABLE ORDERS ADD Shipper_ID INT ;

ALTER TABLE ORDERS
ADD CONSTRAINT FK_SHIPPER_ID
FOREIGN KEY (Shipper_ID) REFERENCES SHIPPERS(Shipper_ID);

SELECT * FROM ORDERS;

CREATE TABLE Warehouse_Quantity (
    Product_ID INT PRIMARY KEY REFERENCES Products(Product_ID),
    Quantity_On_Hand INT,
    LastUpdated DATE
);

INSERT INTO Warehouse_Quantity (Product_ID ,Quantity_On_Hand,LastUpdated)
VALUES (4,50,SYSDATE);

Select * From Warehouse_Quantity;

select * from order_items;


CREATE OR REPLACE TRIGGER trg_update_warehouse_quantity
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    -- Check if the Order_Status is changed to 'Shipped'
    IF :new.Order_Status = 'Shipped'  THEN
        -- Update the Warehouse_Quantity table after items are shipped
        FOR order_item IN (
            SELECT oi.Product_ID, oi.Quantity
            FROM Order_Items oi
            WHERE oi.Order_ID = :new.Order_ID
        )
        LOOP
            UPDATE Warehouse_Quantity
            SET Quantity_On_Hand = Quantity_On_Hand - order_item.Quantity,
                LastUpdated = SYSDATE
            WHERE Product_ID = order_item.Product_ID;
        END LOOP;
    END IF;
END;
/

update orders set order_status = 'Shipped' where order_id = 1;

Select * From Warehouse_Quantity;

select * from order_items;

select * from orders;

update orders set order_status = 'Shipped' where order_id = 1;

select * from Warehouse_Quantity;


CREATE TABLE Invoice_Detail (
    Invoice_Detail_ID INT PRIMARY KEY,
    Invoice_ID INT REFERENCES Invoices(Invoice_ID),
    Product_ID INT REFERENCES Products(Product_ID),
    Quantity INT,
    Amount DECIMAL(10, 2),
    Tax DECIMAL(10, 2),
    Discount DECIMAL(10, 2)
);

DESC Invoice_Detail;

SELECT * FROM SALES;

COMMIT;


-- Analysis

ALTER TABLE SALES ADD SALES INT;
ALTER TABLE SALES ADD YEAR INT;


UPDATE SALES SET SALES = 170, YEAR = 2023 WHERE SALES_ID='501';
UPDATE SALES SET SALES = 180, YEAR = 2023 WHERE SALES_ID='502';
UPDATE SALES SET SALES = 200, YEAR = 2023 WHERE SALES_ID='503';
UPDATE SALES SET SALES = 180.24, YEAR = 2021 WHERE SALES_ID='504';

INSERT INTO SALES VALUES (505, 'LOKI', 220.12, 2021);
INSERT INTO SALES VALUES (506, 'LOKI', 160.36, 2022);


SELECT * FROM SALES;


-- Set the last year sales using LAG function
UPDATE SALES s
SET LAST_YEAR_SALES = LAG(SALES) OVER (PARTITION BY SALESPERSON ORDER BY YEAR);

-- Display the results
SELECT 
	SALES_ID,
	YEAR, 
	SALES,
	LAG(SALES) OVER ( ORDER BY YEAR) LAST_YEAR_SALES,SALES - LAG(SALES) OVER ( ORDER BY YEAR) Sales_Performance
FROM 
	SALES
WHERE
	SALESPERSON = 'LOKI';











































