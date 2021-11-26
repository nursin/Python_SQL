-- orders drop constraint fk_orders_customers
-- depends: 20211111_06_l8O6N-create-table-orders
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(id)
ON DELETE CASCADE;
