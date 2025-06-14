-- Total revenue by country
SELECT ship_country, ROUND(CAST(sum(od.unit_price) as NUMERIC), 0)
FROM order_details od
JOIN orders ods ON od.order_id = ods.order_id
GROUP BY ship_country
ORDER BY 2 DESC;  

-- top 3 products by total sales revenue
SELECT p.product_name, 
ROUND(CAST(SUM(od.unit_price*od.quantity) as NUMERIC), 0) as revenue
FROM products p
JOIN order_details od on p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 3;

-- sales by month
SELECT EXTRACT(MONTH from o.shipped_date) as month, 
SUM(unit_price) as sales
FROM orders o
JOIN order_details od on  o.order_id = od.order_id
WHERE o.shipped_date BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY month
ORDER BY month;

-- Spending by Customer
SELECT c.contact_name, c.company_name,
ROUND(CAST(SUM(od.unit_price*od.quantity) as NUMERIC), 0) as total_purchases
FROM customers c
JOIN orders o on c.customer_id = o.customer_id
JOIN order_details od on o.order_id = od.order_id
GROUP BY 1, 2
ORDER BY 3 DESC;

-- performance of most expensive items
SELECT p.product_name, ROUND(CAST(p.unit_price as NUMERIC), 0) as item_price,
ROUND(CAST(SUM(od.unit_price*od.quantity) as NUMERIC), 0) as total_sales
FROM products p 
JOIN order_details od on p.product_id = od.product_id
GROUP BY 1, 2
ORDER BY 2 DESC
LIMIT 5;

--backorders and suppliers
SELECT p.product_name, s.company_name,
SUM( p.units_on_order - p.units_in_stock) as backordered_qty
FROM PRODUCTS p
JOIN suppliers s on p.supplier_id = s.supplier_id 
GROUP BY 1, 2
HAVING SUM(units_on_order - units_in_stock) >0
ORDER BY 3 DESC;
