-- orders drop constraint fk_orders_customers
-- depends: 20211111_06_l8O6N-create-table-orders
ALTER TABLE orders 
    DROP CONSTRAINT fk_orders_customers;
