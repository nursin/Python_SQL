-- kill other connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'week1_workshop' AND pid <> pg_backend_pid();
-- (re)create the database
DROP DATABASE IF EXISTS week1_workshop;
CREATE DATABASE week1_workshop;
-- connect via psql
\c week1_workshop

-- database configuration
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_tablespace = '';
SET default_with_oids = false;


---
--- CREATE tables
---

CREATE TABLE products (
    product_id SERIAL,
    name TEXT NOT NULL,
    discontinued BOOLEAN NOT NULL,
    supplier_id INT,
    category_id INT,
    PRIMARY KEY(product_id)
);

CREATE TABLE categories (
    category_id SERIAL,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    picture TEXT,
    PRIMARY KEY(category_id)
);

CREATE TABLE suppliers (
    supplier_id SERIAL,
    name TEXT NOT NULL,
    PRIMARY KEY(supplier_id)
);

CREATE TABLE customers (
    customer_id SERIAL,
    company_name TEXT NOT NULL,
    PRIMARY KEY(customer_id)
);

CREATE TABLE employees (
    employee_id SERIAL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    PRIMARY KEY(employee_id),
    reports_to INTEGER NULL
);

CREATE TABLE orders (
    order_id SERIAL,
    date DATE NULL,
    last_name TEXT NOT NULL,
    PRIMARY KEY(order_id),
    employee_id INT NULL,
    customer_id INT NOT NULL
);

CREATE TABLE orders_products (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    PRIMARY KEY(order_id, product_id),
    discount NUMERIC NOT NULL,
    quantity INTEGER NOT NULL
);

CREATE TABLE territories (
    territory_id SERIAL,
    description TEXT NOT NULL,
    PRIMARY KEY(territory_id)
);

CREATE TABLE employees_territories (
    employee_id INTEGER NOT NULL,
    territory_id INTEGER NOT NULL,
    PRIMARY KEY(employee_id, territory_id)
);

CREATE TABLE offices (
    office_id INTEGER NOT NULL,
    adress_line TEXT NOT NULL,
    PRIMARY KEY(office_id),
    territory_id INT NOT NULL
);

CREATE TABLE us_states (
    us_states_id SERIAL,
    name TEXT NOT NULL UNIQUE,
    abbreviation CHARACTER(2) NOT NULL UNIQUE,
    PRIMARY KEY(us_states_id)
);

-- TODO create more tables here...


---
--- Add foreign key constraints
---

ALTER TABLE products
ADD CONSTRAINT fk_products_categories 
FOREIGN KEY(category_id) 
REFERENCES categories;

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY(customer_id)
REFERENCES customers;

ALTER TABLE orders
ADD CONSTRAINT fk_orders_employees
FOREIGN KEY(employee_id)
REFERENCES employees;

ALTER TABLE products
ADD CONSTRAINT fk_products_suppliers
FOREIGN KEY(supplier_id)
REFERENCEs suppliers;

ALTER TABLE orders_products
ADD CONSTRAINT fk_orders_products_orders
FOREIGN KEY(order_id)
REFERENCES orders;

ALTER TABLE orders_products
ADD CONSTRAINT fk_orders_products_products
FOREIGN KEY(product_id)
REFERENCES products;

ALTER TABLE employees_territories
ADD CONSTRAINT fk_employees_territories_employees
FOREIGN KEY(employee_id)
REFERENCES employees;

ALTER TABLE employees_territories
ADD CONSTRAINT fk_employees_territories_territories
FOREIGN KEY(territory_id)
REFERENCES territories;

ALTER TABLE offices
ADD CONSTRAINT fk_offices_territories
FOREIGN KEY(territory_id)
REFERENCES territories;

ALTER TABLE employees
ADD CONSTRAINT fk_employees_reports_to
FOREIGN KEY(reports_to)
REFERENCES employees;

-- TODO create more constraints here...

