-- =========================================
-- Inventory count by store
-- =========================================
SELECT s.store_id, COUNT(i.inventory_id) AS inventory_count
FROM store s
JOIN inventory i
ON s.store_id = i.store_id
GROUP BY 1;

-- =========================================
-- Store revenue
-- =========================================
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN customer c
ON s.store_id = c.store_id
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY 1;

-- =========================================
-- Ranked films per store (dense_rank per store + rental_count)
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
