-- Sample data for Customer Sales Analysis
-- Realistic transactional data spanning 2023-2025

-- Regions
INSERT INTO regions (region_id, region_name, country) VALUES
(1, 'North America', 'USA'),
(2, 'Western Europe', 'Germany'),
(3, 'Asia Pacific', 'Singapore'),
(4, 'Latin America', 'Brazil'),
(5, 'Middle East', 'UAE');

-- Employees (Sales Reps)
INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, region_id) VALUES
(1, 'Alice', 'Johnson', 'alice.j@company.com', '2021-03-15', 1),
(2, 'Bob', 'Smith', 'bob.s@company.com', '2020-07-22', 1),
(3, 'Clara', 'Mueller', 'clara.m@company.com', '2022-01-10', 2),
(4, 'David', 'Chen', 'david.c@company.com', '2019-11-05', 3),
(5, 'Elena', 'Silva', 'elena.s@company.com', '2021-09-18', 4),
(6, 'Frank', 'Al-Rashid', 'frank.a@company.com', '2023-02-28', 5),
(7, 'Grace', 'Lee', 'grace.l@company.com', '2020-05-12', 3),
(8, 'Henry', 'Wilson', 'henry.w@company.com', '2022-08-30', 1);

-- Categories
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Software', 'Enterprise and SaaS software licenses'),
(2, 'Hardware', 'Servers, networking and endpoint devices'),
(3, 'Cloud Services', 'IaaS, PaaS and managed cloud offerings'),
(4, 'Consulting', 'Professional services and implementation'),
(5, 'Support & Maintenance', 'Annual support contracts and SLAs'),
(6, 'Training', 'Certification and onboarding programs');

-- Products
INSERT INTO products (product_id, product_name, category_id, unit_price, units_in_stock, discontinued) VALUES
(101, 'Enterprise CRM Suite', 1, 12500.00, 150, 0),
(102, 'Analytics Platform Pro', 1, 8900.00, 200, 0),
(103, 'Security Gateway Appliance', 2, 4500.00, 80, 0),
(104, 'High-Performance Server Node', 2, 7800.00, 45, 0),
(105, 'Cloud Compute Bundle (Annual)', 3, 24000.00, 999, 0),
(106, 'Data Lake Storage Tier', 3, 6500.00, 999, 0),
(107, 'Implementation Services (per day)', 4, 1800.00, 999, 0),
(108, 'Strategy Workshop Package', 4, 9500.00, 50, 0),
(109, 'Premium Support Contract', 5, 4200.00, 300, 0),
(110, '24/7 Critical Support Add-on', 5, 2800.00, 200, 0),
(111, 'Admin Certification Track', 6, 2200.00, 120, 0),
(112, 'End-User Training Bundle', 6, 1500.00, 180, 0),
(113, 'Legacy Reporting Module', 1, 3200.00, 10, 1),  -- discontinued
(114, 'Edge IoT Gateway', 2, 2100.00, 60, 0);

-- Customers (mix of segments and regions)
INSERT INTO customers (customer_id, company_name, contact_name, email, phone, city, region_id, customer_segment, registration_date) VALUES
(1001, 'TechNova Inc', 'Sarah Patel', 'spatel@technova.com', '+1-415-555-0101', 'San Francisco', 1, 'Enterprise', '2022-04-12'),
(1002, 'GreenLeaf Solutions', 'Marcus Green', 'mgreen@greenleaf.io', '+1-312-555-0142', 'Chicago', 1, 'SMB', '2023-01-20'),
(1003, 'Alpine Manufacturing', 'Ingrid Bauer', 'ibauer@alpine.de', '+49-89-555-0199', 'Munich', 2, 'Enterprise', '2021-11-05'),
(1004, 'Pacific Digital', 'Wei Zhang', 'wzhang@pacificdig.sg', '+65-6555-0188', 'Singapore', 3, 'Enterprise', '2022-07-18'),
(1005, 'Sunrise Retail Group', 'Carlos Mendes', 'cmendes@sunrise.br', '+55-11-555-0177', 'São Paulo', 4, 'SMB', '2023-03-09'),
(1006, 'Desert Horizon LLC', 'Omar Hassan', 'ohassan@deserthorizon.ae', '+971-4-555-0166', 'Dubai', 5, 'Startup', '2024-02-14'),
(1007, 'Quantum Labs', 'Priya Sharma', 'psharma@quantumlabs.com', '+1-617-555-0155', 'Boston', 1, 'Startup', '2023-08-22'),
(1008, 'Nordic Systems AB', 'Erik Lindqvist', 'elindqvist@nordic.se', '+46-8-555-0144', 'Stockholm', 2, 'SMB', '2022-09-30'),
(1009, 'Orient Logistics', 'Yuki Tanaka', 'ytanaka@orientlog.jp', '+81-3-555-0133', 'Tokyo', 3, 'Enterprise', '2021-06-15'),
(1010, 'Andes Consulting', 'Lucia Vargas', 'lvargas@andes.cl', '+56-2-555-0122', 'Santiago', 4, 'SMB', '2024-01-08'),
(1011, 'CloudFirst Partners', 'James Okonkwo', 'jokonkwo@cloudfirst.com', '+1-206-555-0111', 'Seattle', 1, 'Enterprise', '2020-12-01'),
(1012, 'BrightStart App', 'Sophie Martin', 'smartin@brightstart.fr', '+33-1-555-0100', 'Paris', 2, 'Startup', '2024-05-19'),
(1013, 'Metro Health Systems', 'Robert Chen', 'rchen@metrohealth.com', '+1-212-555-0190', 'New York', 1, 'Enterprise', '2022-02-28'),
(1014, 'Urban Mobility Co', 'Fatima Al-Sayed', 'falsayed@urbanmob.ae', '+971-2-555-0180', 'Abu Dhabi', 5, 'SMB', '2023-11-11'),
(1015, 'DataPulse Analytics', 'Liam O''Brien', 'lobrien@datapulse.ie', '+353-1-555-0170', 'Dublin', 2, 'Startup', '2024-03-25');

-- Orders (spanning 2023-2025)
INSERT INTO orders (order_id, customer_id, employee_id, order_date, required_date, shipped_date, ship_via, freight, status) VALUES
(5001, 1001, 1, '2023-02-15', '2023-03-01', '2023-02-20', 'Express', 250.00, 'Delivered'),
(5002, 1003, 3, '2023-03-22', '2023-04-10', '2023-03-28', 'Standard', 180.00, 'Delivered'),
(5003, 1004, 4, '2023-05-10', '2023-05-25', '2023-05-14', 'Express', 320.00, 'Delivered'),
(5004, 1002, 2, '2023-06-18', '2023-07-05', '2023-06-25', 'Standard', 95.00, 'Delivered'),
(5005, 1007, 1, '2023-08-05', '2023-08-20', '2023-08-09', 'Express', 150.00, 'Delivered'),
(5006, 1009, 7, '2023-09-12', '2023-09-30', '2023-09-18', 'Standard', 410.00, 'Delivered'),
(5007, 1011, 8, '2023-10-28', '2023-11-15', '2023-11-02', 'Express', 275.00, 'Delivered'),
(5008, 1005, 5, '2023-12-03', '2023-12-20', '2023-12-08', 'Standard', 220.00, 'Delivered'),
(5009, 1001, 1, '2024-01-15', '2024-02-01', '2024-01-19', 'Express', 190.00, 'Delivered'),
(5010, 1006, 6, '2024-02-20', '2024-03-10', '2024-02-25', 'Standard', 350.00, 'Delivered'),
(5011, 1008, 3, '2024-03-08', '2024-03-25', '2024-03-12', 'Express', 140.00, 'Delivered'),
(5012, 1013, 2, '2024-04-22', '2024-05-10', '2024-04-27', 'Express', 210.00, 'Delivered'),
(5013, 1004, 4, '2024-05-17', '2024-06-05', '2024-05-22', 'Standard', 380.00, 'Delivered'),
(5014, 1010, 5, '2024-06-30', '2024-07-15', '2024-07-05', 'Standard', 165.00, 'Delivered'),
(5015, 1007, 8, '2024-07-14', '2024-07-30', '2024-07-18', 'Express', 120.00, 'Delivered'),
(5016, 1012, 3, '2024-08-09', '2024-08-25', NULL, 'Standard', 90.00, 'Shipped'),
(5017, 1003, 3, '2024-09-21', '2024-10-10', '2024-09-26', 'Express', 230.00, 'Delivered'),
(5018, 1011, 1, '2024-10-05', '2024-10-25', '2024-10-09', 'Express', 280.00, 'Delivered'),
(5019, 1014, 6, '2024-11-12', '2024-11-30', '2024-11-16', 'Standard', 195.00, 'Delivered'),
(5020, 1002, 2, '2024-12-01', '2024-12-20', '2024-12-06', 'Express', 110.00, 'Delivered'),
(5021, 1001, 1, '2025-01-10', '2025-01-28', '2025-01-14', 'Express', 240.00, 'Delivered'),
(5022, 1009, 7, '2025-02-18', '2025-03-05', '2025-02-22', 'Standard', 450.00, 'Delivered'),
(5023, 1015, 3, '2025-03-07', '2025-03-22', '2025-03-11', 'Express', 130.00, 'Delivered'),
(5024, 1005, 5, '2025-04-15', '2025-05-01', NULL, 'Standard', 175.00, 'Pending'),
(5025, 1013, 8, '2025-05-20', '2025-06-05', '2025-05-24', 'Express', 300.00, 'Delivered'),
(5026, 1004, 4, '2025-06-11', '2025-06-28', '2025-06-15', 'Express', 360.00, 'Delivered'),
(5027, 1006, 6, '2025-07-03', '2025-07-20', '2025-07-08', 'Standard', 280.00, 'Delivered'),
(5028, 1008, 3, '2025-08-19', '2025-09-05', NULL, 'Express', 155.00, 'Shipped'),
(5029, 1011, 1, '2025-09-02', '2025-09-20', '2025-09-06', 'Express', 265.00, 'Delivered'),
(5030, 1007, 2, '2025-09-10', '2025-09-25', NULL, 'Standard', 100.00, 'Pending');

-- Order Details (line items with realistic quantities and occasional discounts)
INSERT INTO order_details (order_id, product_id, unit_price, quantity, discount) VALUES
-- 5001 TechNova
(5001, 101, 12500.00, 2, 0.05),
(5001, 109, 4200.00, 2, 0.00),
(5001, 107, 1800.00, 10, 0.10),
-- 5002 Alpine
(5002, 105, 24000.00, 1, 0.00),
(5002, 108, 9500.00, 1, 0.05),
-- 5003 Pacific Digital
(5003, 102, 8900.00, 3, 0.08),
(5003, 106, 6500.00, 2, 0.00),
(5003, 111, 2200.00, 5, 0.00),
-- 5004 GreenLeaf
(5004, 103, 4500.00, 4, 0.00),
(5004, 112, 1500.00, 8, 0.10),
-- 5005 Quantum Labs
(5005, 101, 12500.00, 1, 0.00),
(5005, 107, 1800.00, 5, 0.00),
-- 5006 Orient Logistics
(5006, 104, 7800.00, 3, 0.05),
(5006, 109, 4200.00, 3, 0.00),
(5006, 105, 24000.00, 1, 0.10),
-- 5007 CloudFirst
(5007, 105, 24000.00, 2, 0.05),
(5007, 106, 6500.00, 4, 0.00),
(5007, 109, 4200.00, 2, 0.00),
-- 5008 Sunrise Retail
(5008, 103, 4500.00, 6, 0.08),
(5008, 114, 2100.00, 10, 0.00),
-- 5009 TechNova (repeat)
(5009, 102, 8900.00, 2, 0.00),
(5009, 110, 2800.00, 2, 0.00),
-- 5010 Desert Horizon
(5010, 101, 12500.00, 1, 0.00),
(5010, 107, 1800.00, 8, 0.05),
-- 5011 Nordic Systems
(5011, 102, 8900.00, 1, 0.00),
(5011, 109, 4200.00, 1, 0.00),
(5011, 111, 2200.00, 3, 0.00),
-- 5012 Metro Health
(5012, 105, 24000.00, 1, 0.00),
(5012, 108, 9500.00, 2, 0.05),
(5012, 109, 4200.00, 1, 0.00),
-- 5013 Pacific Digital
(5013, 104, 7800.00, 2, 0.00),
(5013, 106, 6500.00, 3, 0.08),
-- 5014 Andes Consulting
(5014, 107, 1800.00, 12, 0.10),
(5014, 112, 1500.00, 6, 0.00),
-- 5015 Quantum Labs
(5015, 102, 8900.00, 1, 0.00),
(5015, 110, 2800.00, 1, 0.00),
-- 5016 BrightStart
(5016, 101, 12500.00, 1, 0.10),
(5016, 111, 2200.00, 2, 0.00),
-- 5017 Alpine
(5017, 105, 24000.00, 1, 0.00),
(5017, 109, 4200.00, 2, 0.00),
-- 5018 CloudFirst
(5018, 106, 6500.00, 5, 0.05),
(5018, 107, 1800.00, 15, 0.00),
-- 5019 Urban Mobility
(5019, 103, 4500.00, 3, 0.00),
(5019, 114, 2100.00, 5, 0.05),
-- 5020 GreenLeaf
(5020, 102, 8900.00, 1, 0.00),
(5020, 112, 1500.00, 4, 0.00),
-- 5021 TechNova
(5021, 101, 12500.00, 3, 0.08),
(5021, 109, 4200.00, 3, 0.00),
(5021, 110, 2800.00, 3, 0.00),
-- 5022 Orient Logistics
(5022, 104, 7800.00, 4, 0.05),
(5022, 105, 24000.00, 1, 0.00),
-- 5023 DataPulse
(5023, 102, 8900.00, 2, 0.00),
(5023, 107, 1800.00, 4, 0.00),
-- 5024 Sunrise Retail
(5024, 103, 4500.00, 5, 0.00),
(5024, 114, 2100.00, 8, 0.00),
-- 5025 Metro Health
(5025, 105, 24000.00, 2, 0.05),
(5025, 108, 9500.00, 1, 0.00),
-- 5026 Pacific Digital
(5026, 101, 12500.00, 1, 0.00),
(5026, 106, 6500.00, 2, 0.00),
(5026, 109, 4200.00, 1, 0.00),
-- 5027 Desert Horizon
(5027, 107, 1800.00, 10, 0.08),
(5027, 111, 2200.00, 4, 0.00),
-- 5028 Nordic Systems
(5028, 102, 8900.00, 1, 0.00),
(5028, 110, 2800.00, 1, 0.00),
-- 5029 CloudFirst
(5029, 105, 24000.00, 1, 0.00),
(5029, 106, 6500.00, 3, 0.05),
(5029, 109, 4200.00, 2, 0.00),
-- 5030 Quantum Labs
(5030, 101, 12500.00, 1, 0.05),
(5030, 107, 1800.00, 3, 0.00);

-- Payments (most completed, a few pending/refunded for realism)
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, status) VALUES
(9001, 5001, '2023-02-16', 31210.00, 'Bank Transfer', 'Completed'),
(9002, 5002, '2023-03-23', 33025.00, 'Credit Card', 'Completed'),
(9003, 5003, '2023-05-11', 41828.00, 'Bank Transfer', 'Completed'),
(9004, 5004, '2023-06-19', 28800.00, 'Credit Card', 'Completed'),
(9005, 5005, '2023-08-06', 21500.00, 'PayPal', 'Completed'),
(9006, 5006, '2023-09-13', 54660.00, 'Bank Transfer', 'Completed'),
(9007, 5007, '2023-10-29', 72400.00, 'Credit Card', 'Completed'),
(9008, 5008, '2023-12-04', 45840.00, 'Bank Transfer', 'Completed'),
(9009, 5009, '2024-01-16', 23400.00, 'Credit Card', 'Completed'),
(9010, 5010, '2024-02-21', 25940.00, 'Bank Transfer', 'Completed'),
(9011, 5011, '2024-03-09', 19700.00, 'Credit Card', 'Completed'),
(9012, 5012, '2024-04-23', 46550.00, 'Bank Transfer', 'Completed'),
(9013, 5013, '2024-05-18', 33540.00, 'Credit Card', 'Completed'),
(9014, 5014, '2024-07-01', 28440.00, 'Bank Transfer', 'Completed'),
(9015, 5015, '2024-07-15', 11700.00, 'PayPal', 'Completed'),
(9016, 5016, '2024-08-10', 15650.00, 'Credit Card', 'Pending'),
(9017, 5017, '2024-09-22', 32400.00, 'Bank Transfer', 'Completed'),
(9018, 5018, '2024-10-06', 57925.00, 'Credit Card', 'Completed'),
(9019, 5019, '2024-11-13', 23475.00, 'Bank Transfer', 'Completed'),
(9020, 5020, '2024-12-02', 14900.00, 'Credit Card', 'Completed'),
(9021, 5021, '2025-01-11', 52800.00, 'Bank Transfer', 'Completed'),
(9022, 5022, '2025-02-19', 53640.00, 'Credit Card', 'Completed'),
(9023, 5023, '2025-03-08', 25000.00, 'PayPal', 'Completed'),
(9024, 5024, '2025-04-16', 39300.00, 'Bank Transfer', 'Pending'),
(9025, 5025, '2025-05-21', 55100.00, 'Credit Card', 'Completed'),
(9026, 5026, '2025-06-12', 27400.00, 'Bank Transfer', 'Completed'),
(9027, 5027, '2025-07-04', 25360.00, 'Credit Card', 'Completed'),
(9028, 5028, '2025-08-20', 11700.00, 'PayPal', 'Pending'),
(9029, 5029, '2025-09-03', 47250.00, 'Bank Transfer', 'Completed'),
(9030, 5030, '2025-09-11', 17275.00, 'Credit Card', 'Pending');
