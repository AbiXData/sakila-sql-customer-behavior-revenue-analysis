-- =========================================
-- ROW_NUMBER() over payment amounts
-- =========================================
SELECT payment_id, customer_id, amount, ROW_NUMBER()
OVER(ORDER BY amount desc) AS rownumber
FROM payment;

-- =========================================
-- RANK() over rental_duration
-- =========================================
SELECT film_id, title, rental_duration, RANK()
OVER(ORDER BY rental_duration desc) AS rank_row
FROM film;

-- =========================================
-- DENSE_RANK() partition by category (also category performance)
-- =========================================
SELECT name, f.title, f.rental_rate, DENSE_RANK()
OVER(PARTITION BY name ORDER BY rental_rate desc) AS dense_rank_row
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id;

-- =========================================
-- ROW_NUMBER() partition by rating (top 3 per rating)
-- =========================================
WITH rownumber_per_rating AS (SELECT title, replacement_cost, rating, 
ROW_NUMBER() OVER(PARTITION BY rating) ranknumber
FROM film)
SELECT title, replacement_cost, rating
FROM rownumber_per_rating
WHERE ranknumber <= 3
ORDER BY rating, replacement_cost desc;

-- =========================================
-- LAG() previous payment amount (also customer analysis)
-- =========================================
SELECT first_name, last_name, payment_date, amount, lag(amount, 1,0) 
over(partition by c.customer_id order by payment_date) previous_amount
from customer c
join payment p
on c.customer_id = p.customer_id;

-- =========================================
-- running total attempt (we’ll rewrite properly)
-- =========================================
WITH cust_running_total AS (SELECT concat(c.first_name, ' ', c.last_name) AS customer_name, SUM(p.amount)
OVER(ORDER BY amount desc) AS running_total
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id)
SELECT customer_name, running_total
FROM cust_running_total
WHERE running_total > 150;

-- =========================================
-- nested CTE + DENSE_RANK() per store (also store analysis)
-- =========================================
WITH ranked_store AS (WITH film_rank AS (SELECT i.store_id, title, COUNT(r.rental_id) AS rental_count
FROM store s
JOIN inventory i
ON s.store_id = i.store_id
JOIN film f
ON f.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY 1,2)
SELECT *, dense_rank()
OVER(partition by store_id order by rental_count desc) store_film_rank
FROM film_rank)
SELECT *
FROM ranked_store
WHERE store_film_rank = 2;

