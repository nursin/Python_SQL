-- Part 1: Filters

-- 1.1
-- Select all columns from the categories table.
-- Use an order by clause to sort the results by category_id.
SELECT * FROM categories
ORDER BY category_id ASC;

-- 1.2
-- Select each city from the employees table without any duplicates
-- and sort in descending order.
SELECT DISTINCT city FROM employees
ORDER BY city DESC;

-- 1.3
-- Select product_id and product_name of all discontinued products
-- and sort by the product_id.
--
-- Hint: only include products for which the discontinued column is true.
SELECT product_id, product_name
FROM products
WHERE discontinued = true
ORDER BY product_id;

-- 1.4
-- Select the first_name and last_name of employees who do not have anyone to report to
-- (i.e. their reports_to field is blank).
-- Sort by employee_id.
SELECT employee_id, first_name, last_name, reports_to
FROM employees
WHERE reports_to IS NULL
ORDER BY employee_id;

-- 1.5
-- Select the product_name of each product where the units_in_stock is less than
-- or equal to the reorder_level.
-- You only need the products that are not discontinued and only include
-- products that have more than 0 units_on_order.
-- Sort the results by product_id.
--
-- Hint: start simple, do the select without any restrictions and confirm you're
-- getting the data you expect. Then add each of the restrictions one by one.
SELECT product_name
FROM products
WHERE units_in_stock <= reorder_level AND discontinued = false
AND units_on_order > 0
ORDER BY product_id;


-- Part 2: Functions, Grouping
-- Here are some real queries you might be asked on a day-to-day basis.
-- Sometimes SQL is the fastest and most elegant way to get this data.

-- 2.1
-- How many orders have been made?
SELECT COUNT(*) FROM orders;

-- 2.2
-- How many orders has each customer made?
-- For each customer, select customer_id and the count of their orders.
-- Sort first by the order-count (greatest to least), then customer_id (alphabetically)
SELECT customer_id, COUNT(customer_id) as order_count
FROM orders
GROUP BY customer_id
ORDER BY order_count, customer_id;
-- ** i thought the instruction meant sort separately but i see now its sorting primary and secondary. ** --

-- 2.3
-- Where are we shipping a lot of orders to?
-- Select the ship_address and the count of orders for the ship_address that
-- has received the most orders.
--
-- Note: consider how we might extend this query, applying it to each customer. 
-- Combined with a location-based mapping service, you could easily see where you're selling a lot of products,
-- and where you might want to focus more advertising - a great data science application!
-- We will take a closer look at data science and data visualizations in a future lesson.
SELECT customer_id, ship_address, COUNT(ship_address) as ship_destination_count
FROM orders
GROUP BY ship_address, customer_id
ORDER BY ship_destination_count DESC;
--***having some trouble selecting MAX after grouping***

-- 2.4
-- Who could we offer our new freight discount campaign to?
-- For each customer, select customer_id and the total amount spent on freight
-- across all of their orders. Only include those who have spent more than $500.
-- Sort by customer_id.
SELECT customer_id, SUM(freight) as freight_cost
FROM orders
GROUP BY customer_id
HAVING SUM(freight) > 500
ORDER BY customer_id;

-- 2.5
-- We want to offer white glove shipping to our best customers.
-- But first, do we need to consolidate the shippers we use? How many different
-- shippers do our customers normally deal with?
-- For each customer, count how many shippers have ever sent them an order.
-- Then, select the average of those counts.
--
-- Hint: ship_via is a foreign key on orders that references shippers.
SELECT ship_via
FROM orders
LEFT JOIN shippers
ON shippers.ship_via;
--*** Not completed***

-- Part 3: Mix and Match

-- 3.1
-- Let's review our product categories.
-- List each product_name and its corresponding category_name.
-- Do not include products that have a null category_id
-- Sort by product_id.
--
-- Hint: check which join type you should use in this situation
SELECT p.product_name, c.category_name 
FROM categories c
JOIN products p
ON c.category_id = p.category_id
ORDER BY p.product_id;

-- 3.2
-- HR wants to do a staff audit across the regions.
-- List region_description, territory_description, employee last_name,
-- and employee first_name for each territory and region an employee works in.
--
-- To make it easier for them, remove duplicate results and also sort first by
-- region_description, then territory description, then last name, and finally first name.
--
-- Hint: joins can only take two tables at a time, but you use multiple joins in
-- one query by listing each after the other.
-- Try an inner join on employees -> employee_territories -> territories -> region
SELECT DISTINCT e.last_name, e.first_name, t.territory_description, r.region_description
FROM employees e
INNER JOIN employee_territories et
ON et.employee_id = e.employee_id
INNER JOIN territories t
ON et.territory_id = t.territory_id
INNER JOIN region r
ON t.region_id = r.region_id
ORDER BY r.region_description, t.territory_description, e.last_name, e.first_name;
-- ***HAVING HARD TIME REMOVING DUPLICATES*** --

-- 3.3
-- Finance wants to audit the sales tax rates we've applied so need a list of
-- each customer in the different states.
-- List state_name, state_abbr, and company_name for all customers in the U.S. states
-- If a state has no customers, still include it in the result with a NULL
-- placeholder for the company_name.
-- Sort by state_name.
--
-- Hint: match the customer's region on the state's abbreviation
SELECT c.region, c.company_name, s.state_name, s.state_abbr
FROM customers c
LEFT JOIN us_states s
ON c.region = s.state_abbr
ORDER BY s.state_name;

-- 3.4
-- Time for the yearly bonus! and associated thank you email.
-- To generate the email salutations, query the following:
--
-- List territory_description, employee title_of_courtesy, and employee last_name for all
-- territories and any assigned employees.
-- If a territory has no employees assigned, list its description with
-- NULL filled in for the relevant employee fields.
-- Sort first by territory_description, then employee_id.
SELECT DISTINCT t.territory_description, e.title_of_courtesy, e.last_name
FROM employees e
RIGHT JOIN employee_territories et
ON e.employee_id = et.employee_id
RIGHT JOIN territories t
ON et.territory_id = t.territory_id
ORDER BY t.territory_description, e.last_name;

-- 3.5
-- Management needs a list of all suppliers and customers contact information 
-- for the holiday greeting cards!
-- Select company_name, address, city, region, postal_code, and country 
-- for all suppliers and all customers.
-- Sort by company_name.
SELECT company_name, address, city, region, postal_code, country
FROM suppliers
UNION ALL
SELECT company_name, address, city, region, postal_code, country
FROM customers
ORDER BY company_name;

-- 3.6
-- And of course, our famous holiday gift baskets go out to our best customers.
-- Get customer company_name and the total quantity of products ever ordered by
-- said customer. Only select those that have ordered a total quantity of at
-- least 500.
-- Sort by total quantity in descending order.
SELECT order_id, SUM(quantity) AS order_quantity
FROM order_details
GROUP BY order_details.order_id
ORDER BY order_quantity DESC;
--*** Having trouble joining order_details to orders table ***--