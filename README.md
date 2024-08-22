# Supply Chain Management

## Project Overview

This project involves the development of a comprehensive **Supply Chain Management System** tailored for an e-commerce platform. The system is designed to efficiently manage customer orders, inventory, suppliers, shipping, and notifications. The database supports a large-scale operation, accommodating up to 50,000 customers, and includes robust mechanisms for ensuring the integrity and efficiency of order processing.

## Features

### 1. **Extensive E-commerce Database Design**
   - **Customer Data Management**: The system manages detailed customer information, including names, locales, payment details, and order histories.
   - **Order Processing**: Seamless order management, linking customers, products, and invoices while tracking order status.
   - **Inventory Management**: Real-time tracking of product quantities, including automated updates on stock levels post-purchase.
   - **Supplier and Shipping Integration**: Efficient supplier management and shipping coordination to ensure timely product delivery.

### 2. **SQL Triggers and Stored Procedures**
   - **Triggers**: Implemented SQL triggers to automatically update inventory levels and ensure synchronization between tables when orders are processed or shipped.
   - **Stored Procedures**: Developed stored procedures for creating orders and invoices, automating the workflow, and enforcing business rules such as checking product availability.

### 3. **Scalability**
   - **Database Support for 50K Customers**: The system is designed to handle large-scale customer bases with efficient query processing and data management.

## Database Schema Overview

### **1. Tables**
   - **Suppliers**: Manages supplier details.
   - **Shippers**: Manages shipping information.
   - **Customers**: Stores customer details.
   - **Sales**: Records sales data, linking customers with salespersons.
   - **Orders**: Tracks customer orders.
   - **Products**: Manages product information, including stock levels.
   - **Invoices**: Handles invoicing details.
   - **Order_Items**: Links products to specific orders.
   - **SupplierNotification**: Stores notifications to suppliers.
   - **CustomerAlerts**: Manages alerts sent to customers.
   - **CustomerServiceAlerts**: Logs alerts for customer service.
   - **Warehouse_Quantity**: Tracks product quantities in the warehouse.
   - **Invoice_Detail**: Stores detailed invoice information.

### **2. Sequences**
   - **Sequence Generation**: Sequences were created to auto-generate unique identifiers for invoices, orders, and order items.

### **3. Triggers**
   - **Inventory Management Trigger** (`trg_update_product_quantity`): Automatically updates product quantities when an order item is added.
   - **Warehouse Quantity Trigger** (`trg_update_warehouse_quantity`): Adjusts warehouse stock levels when an order is marked as shipped.

### **4. Stored Procedures**
   - **Order and Invoice Creation** (`create_order_and_invoice`): This procedure handles the complete order processing cycle, including:
     - Checking product availability.
     - Creating orders.
     - Generating invoices.
     - Inserting order items into the database.

## Installation

### **Prerequisites**
- MySQL or compatible SQL database system.
- SQL client or command-line tool for executing the provided SQL script.

### **Setup Instructions**
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/supply-chain-management-system.git
   cd supply-chain-management-system
   ```

2. **Database Setup:**
   - Use your SQL client to execute the SQL script included in this repository.
   --- CODE

3. **Populating the Database:**
   - The provided SQL script includes sample data inserts for suppliers, shippers, customers, products, and sales.
   - You can extend this by adding more records as required.

4. **Running the Procedures and Triggers:**
   - The `create_order_and_invoice` procedure can be executed to test the order processing flow.
   - Triggers will automatically activate when relevant tables are modified.

## Usage

### **Sample Queries**
- **View All Products:**
   ```sql
   SELECT * FROM Products;
   ```

- **Create an Order and Invoice:**
   ```sql
   BEGIN
    create_order_and_invoice(200, 1, 2, 120, 503);
  END;
   ```

- **Check Inventory Levels:**
   ```sql
   SELECT * FROM Warehouse_Quantity;
   ```

### **Database Maintenance**
- Ensure regular updates to the inventory and orders to keep the system accurate.
- Back up the database periodically to prevent data loss.

## Conclusion

This project demonstrates the design and implementation of a scalable and efficient supply chain management system for an e-commerce platform. With robust data structures, stored procedures, and triggers, the system ensures smooth end-to-end order processing, real-time inventory management, and timely notifications to both customers and suppliers.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Contributors

Kumaresh PV - [LinkedIn](https://www.linkedin.com/in/kumaresh-pv)
