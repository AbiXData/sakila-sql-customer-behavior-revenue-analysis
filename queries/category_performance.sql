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
SELECT ca.name AS category_name, COUNT(fc.film_id) AS number_of_film
FROM category ca
JOIN film_category fc
ON ca.category_id = fc.category_id
GROUP BY 1;

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
ORDER BY f.rental_rate DESC) AS rental_rate_rank_in_category
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
ORDER BY c.name, rental_rate_rank_in_category;

-- =========================================
-- Category + film rental_rate ranking with DENSE_RANK() (window + category)
-- =========================================
SELECT name, f.title, f.rental_rate, DENSE_RANK()
OVER(PARTITION BY name ORDER BY rental_rate desc) AS dense_rank_row
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id;

-- =========================================
-- Top 3 replacement cost per rating (window + film attribute; fits here or window_functions)
-- =========================================
WITH rownumber_per_rating AS (SELECT title, replacement_cost, rating, 
ROW_NUMBER() OVER(PARTITION BY rating) ranknumber
FROM film)
SELECT title, replacement_cost, rating
FROM rownumber_per_rating
WHERE ranknumber <= 3
ORDER BY rating, replacement_cost desc;

-- ============================================================
-- CATEGORY PERFORMANCE ANALYSIS
-- Sakila SQL Case Study
-- Focus: category mix, pricing signals, and demand (rentals)
-- ============================================================

-- =========================================
-- 1) Average film length by category
-- Business use: content profiling by genre/category
-- =========================================
SELECT 
    c.name AS category,
    AVG(f.length) AS avg_length
FROM film f
JOIN film_category fc 
    ON f.film_id = fc.film_id
JOIN category c 
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_length DESC;


-- =========================================
-- 2) Number of films per category
-- Business use: category catalog depth / inventory mix
-- =========================================
SELECT 
    c.name AS category,
    COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc
    ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC;


-- =========================================
-- 3) Films priced above average rental rate
-- Business use: identify premium-priced titles
-- =========================================
SELECT 
    title, 
    rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC;


-- =========================================
-- 4) Top 5 most rented films
-- Business use: identify demand leaders
-- =========================================
SELECT 
    f.title, 
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i
    ON f.film_id = i.film_id
JOIN rental r
    ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;


-- =========================================
-- 5) Rank films by rental rate within each category (DENSE_RANK)
-- Business use: identify highest priced films per category
-- =========================================
SELECT 
    c.name AS category,
    f.title,
    f.rental_rate,
    DENSE_RANK() OVER (
        PARTITION BY c.name 
        ORDER BY f.rental_rate DESC
    ) AS rental_rate_rank_in_category
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
ORDER BY c.name, rental_rate_rank_in_category;


-- =========================================
-- 6) Top 3 films by replacement cost within each rating (ROW_NUMBER)
-- Business use: identify highest value inventory by rating
-- =========================================
WITH ranked_by_rating AS (
    SELECT
        title,
        replacement_cost,
        rating,
        ROW_NUMBER() OVER (
            PARTITION BY rating
            ORDER BY replacement_cost DESC
        ) AS rn
    FROM film
)
SELECT 
    title, 
    replacement_cost, 
    rating
FROM ranked_by_rating
WHERE rn <= 3
ORDER BY rating, replacement_cost DESC;
