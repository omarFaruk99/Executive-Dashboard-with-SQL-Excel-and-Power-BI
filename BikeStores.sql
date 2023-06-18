SELECT
    o.order_id,
    -- Concatenate customer's first name and last name to form full name
    concat(c.first_name, ' ', c.last_name) AS customers,
    c.city,
    c.state,
    TO_DATE(o.order_date, 'DD-MM-YY') AS order_date, -- Convert order_date to date with specific format
    -- Calculate total units for the order
    sum(oi.quantity) AS total_unit,
    -- Calculate revenue by multiplying quantity with list price and rounding to 2 decimal places
    round(sum(oi.quantity * oi.list_price::numeric), 2) AS revenue,
    p.product_name,
    ca.category_name,
    b.brand_name,
    s.store_name,
    -- Concatenate staff's first name and last name to form representative's name
    concat(stf.first_name, ' ', stf.last_name) AS rep_name
FROM
    orders o
    -- Join orders table with customers table using customer_id
    JOIN customers c ON c.customer_id = o.customer_id
    -- Join order_items table with orders table using order_id
    JOIN order_items oi ON o.order_id = oi.order_id
    -- Join products table with order_items table using product_id
    JOIN products p ON oi.product_id = p.product_id
    -- Join categories table with products table using category_id
    JOIN categories ca ON p.category_id = ca.category_id
    -- Join brands table with products table using brand_id
    JOIN brands b ON p.brand_id = b.brand_id
    -- Join stores table with orders table using store_id
    JOIN stores s ON o.store_id = s.store_id
    -- Join staffs table with orders table using staff_id
    JOIN staffs stf ON o.staff_id = stf.staff_id
GROUP BY
    o.order_id,
    -- Group by customer's full name, city, state, order date, product name, category name, brand name, store name, representative's name
    concat(c.first_name, ' ', c.last_name),
    c.city,
    c.state,
    TO_DATE(o.order_date, 'DD-MM-YY'), -- Convert order_date to date with specific format
    p.product_name,
    ca.category_name,
    b.brand_name,
    s.store_name,
    concat(stf.first_name, ' ', stf.last_name);
