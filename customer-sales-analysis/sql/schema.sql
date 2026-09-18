-- Customer Sales Analysis - Database Schema
-- 8 relational tables for a realistic sales database

-- 1. Regions
CREATE TABLE regions (
    region_id INTEGER PRIMARY KEY,
    region_name TEXT NOT NULL UNIQUE,
    country TEXT NOT NULL
);

-- 2. Employees (Sales Representatives)
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    hire_date DATE,
    region_id INTEGER,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

-- 3. Customers
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    company_name TEXT NOT NULL,
    contact_name TEXT,
    email TEXT,
    phone TEXT,
    city TEXT,
    region_id INTEGER,
    customer_segment TEXT CHECK(customer_segment IN ('Enterprise', 'SMB', 'Startup', 'Individual')),
    registration_date DATE,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

-- 4. Categories
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- 5. Products
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER,
    unit_price DECIMAL(10,2) NOT NULL,
    units_in_stock INTEGER DEFAULT 0,
    discontinued BOOLEAN DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 6. Orders
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    employee_id INTEGER,
    order_date DATE NOT NULL,
    required_date DATE,
    shipped_date DATE,
    ship_via TEXT,
    freight DECIMAL(10,2) DEFAULT 0,
    status TEXT CHECK(status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 7. Order Details (line items)
CREATE TABLE order_details (
    order_id INTEGER,
    product_id INTEGER,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL CHECK(quantity > 0),
    discount DECIMAL(4,2) DEFAULT 0 CHECK(discount >= 0 AND discount <= 1),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 8. Payments
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_method TEXT CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash', 'Check')),
    status TEXT CHECK(status IN ('Completed', 'Pending', 'Failed', 'Refunded')) DEFAULT 'Completed',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Indexes for performance on common join/filter columns
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_employee ON orders(employee_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_details_product ON order_details(product_id);
CREATE INDEX idx_customers_region ON customers(region_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_payments_order ON payments(order_id);
