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
-- Business use: Identify category Performance; category catalog depth + revenue + average rage 
-- =========================================
SELECT 
    c.name AS category_name,
    COUNT(DISTINCT fc.film_id) AS film_count,
    COUNT(r.rental_id) AS total_rentals,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    ROUND(AVG(f.rental_rate), 2) AS avg_rental_rate,
    ROUND(SUM(p.amount) / COUNT(r.rental_id), 2) AS revenue_per_rental
FROM category c
JOIN film_category fc 
ON fc.category_id = c.category_id
JOIN film f 
ON f.film_id = fc.film_id
JOIN inventory i 
ON i.film_id = f.film_id
JOIN rental r 
ON r.inventory_id = i.inventory_id
JOIN payment p 
ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC;

-- =========================================
-- 3) Films priced above average rental rate
-- Business use: identify premium-priced titles
-- =========================================
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC;

-- =========================================
-- 4) Top 5 most rented films with revenue
-- Business use: identify demand leaders
-- =========================================
SELECT f.title,
    COUNT(r.rental_id) AS rental_count,
    SUM(p.amount) AS total_revenue,
    ROUND(SUM(p.amount) / COUNT(r.rental_id), 2) AS revenue_per_rental
FROM film f
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r 
ON r.inventory_id = i.inventory_id
JOIN payment p 
ON p.rental_id = r.rental_id
GROUP BY f.title
ORDER BY total_revenue DESC
LIMIT 5;

     -- 💡 A film rented 40x at $4.99 beats one rented 50x at $0.99 
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

-- =========================================
-- 7) Monthly rental trend by top 5 categories 
-- Business use: identify category demand trend (Month-over-Month)
-- =========================================
WITH category_monthly AS (
    SELECT c.name AS category,
        DATE_FORMAT(r.rental_date, '%Y-%m') AS rental_month,
        COUNT(r.rental_id) AS monthly_rentals
    FROM category c
    JOIN film_category fc 
    ON fc.category_id = c.category_id
    JOIN film f           
    ON f.film_id = fc.film_id
    JOIN inventory i      
    ON i.film_id = f.film_id
    JOIN rental r         
    ON r.inventory_id = i.inventory_id
    GROUP BY c.name, rental_month
)
SELECT *
FROM category_monthly
WHERE category IN (
    SELECT name FROM (
        SELECT c.name, COUNT(r.rental_id) AS total
        FROM category c
        JOIN film_category fc 
        ON fc.category_id = c.category_id
        JOIN film f           
        ON f.film_id = fc.film_id
        JOIN inventory i      
        ON i.film_id = f.film_id
        JOIN rental r         
        ON r.inventory_id = i.inventory_id
        GROUP BY c.name
        ORDER BY total DESC
        LIMIT 5
    ) top5
)
ORDER BY category, rental_month;
