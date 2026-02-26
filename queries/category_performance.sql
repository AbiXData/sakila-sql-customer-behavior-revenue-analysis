-- ============================================================
-- CATEGORY PERFORMANCE ANALYSIS
-- Sakila SQL Case Study
-- Focus: category mix, pricing signals, and demand (rentals)
-- ============================================================

-- =========================================
-- 1) Average film length by category
-- Business use: content profiling by genre/category
-- =========================================
SELECT c.name AS category, AVG(f.length) AS avg_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_length DESC;

-- =========================================
-- 2) Number of films per category
-- Business use: category catalog depth / inventory mix
-- =========================================
SELECT c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY film_count DESC;

-- =========================================
-- 3) Films priced above average rental rate
-- Business use: identify premium-priced titles
-- =========================================
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC;

-- =========================================
-- 4) Top 5 most rented films
-- Business use: identify demand leaders
-- =========================================
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY 1
ORDER BY rental_count DESC
LIMIT 5;

-- =========================================
-- 5) Rank films by rental rate within each category (DENSE_RANK)
-- Business use: identify highest priced films per category
-- =========================================
SELECT c.name AS category, f.title, f.rental_rate,
DENSE_RANK() OVER (PARTITION BY c.name 
ORDER BY f.rental_rate DESC) AS dense_rank_row
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
ORDER BY c.name, dense_rank_row;

-- =========================================
-- 6) Top 3 films by replacement cost within each rating (ROW_NUMBER)
-- Business use: identify highest value inventory by rating
-- =========================================
WITH rownumber_per_rating AS (SELECT title, replacement_cost, rating, 
ROW_NUMBER() OVER(PARTITION BY rating
ORDER BY replacement_cost DESC) AS ranknumber
FROM film)
SELECT title, replacement_cost, rating
FROM rownumber_per_rating
WHERE ranknumber <= 3
ORDER BY rating, replacement_cost desc;
