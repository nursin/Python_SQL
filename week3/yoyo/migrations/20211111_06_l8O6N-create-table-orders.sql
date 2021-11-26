-- create table orders
-- depends: 20211111_05_UosA8-customers-rename-date-of-birth-to-dob
CREATE TABLE orders (
    id SERIAL,
    dollar_amount_spent NUMERIC,
    customer_id INT NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_orders_customers
        FOREIGN KEY(customer_id)
        REFERENCES customers(id)
        ON DELETE CASCADE
);
