-- =========================================
-- Staff + payments (amount per staff)
-- =========================================
SELECT s.first_name, s.last_name, p.amount
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id;

-- =========================================
-- Store revenue (store_id + SUM(payment.amount))
-- =========================================
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN customer c
ON s.store_id = c.store_id
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY 1;

-- =========================================
-- Top customer by spend (also customer-focused, but revenue focused too)
-- =========================================
SELECT CONCAT(c.first_name, ' ' , c.last_name) AS full_name, SUM(p.amount) AS total_amount_spent
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1
ORDER BY total_amount_spent DESC
LIMIT 1;

-- =========================================
-- Staff rentals + total revenue
-- =========================================
SELECT CONCAT(first_name,' ', last_name) AS staff_name, COUNT(r.rental_id) AS rental_count, SUM(p.amount) AS total_revenue
FROM staff s
JOIN rental r
ON s.staff_id = r.staff_id
JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY 1;

-- =========================================
-- Payments ranked by amount with ROW_NUMBER() (window function + revenue; 
-- =========================================
SELECT payment_id, customer_id, amount, ROW_NUMBER()
OVER(ORDER BY amount desc) AS rownumber
FROM payment;

-- =========================================
-- Running total revenue
-- =========================================
WITH cust_running_total AS (SELECT concat(c.first_name, ' ', c.last_name) AS customer_name, SUM(p.amount)
OVER(ORDER BY amount desc) AS running_total
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id)
SELECT customer_name, running_total
FROM cust_running_total
WHERE running_total > 150;
