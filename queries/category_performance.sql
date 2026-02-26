-- =========================================
-- Avg film length by category
-- =========================================
SELECT c.name AS category, AVG(f.length) AS avg_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_length DESC;

-- =========================================
-- Film count by category
-- =========================================
SELECT name, COUNT(c.category_id) AS count_of_category
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
GROUP BY name;

-- =========================================
-- Film count by category (similar to 12)
-- =========================================
SELECT c.name film_category, COUNT(fc.category_id) AS film_count
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
GROUP BY c.name;

-- =========================================
-- Number of films per category
-- =========================================
SELECT ca.name AS category_name, COUNT(fc.film_id) AS number_of_film
FROM category ca
JOIN film_category fc
ON ca.category_id = fc.category_id
GROUP BY 1;

-- =========================================
-- Films with rental_rate above average
-- =========================================
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

-- =========================================
-- Top 5 most rented films
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
