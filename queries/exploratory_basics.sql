-- =========================================
-- actor where first_name = 'Scarlett'
-- =========================================
SELECT *
FROM actor
WHERE first_name = 'Scarlett';

-- =========================================
-- actor where last_name = 'Johansson'
-- =========================================
SELECT *
FROM actor
WHERE last_name = 'Johansson';

-- =========================================
-- count(distinct last_name) from actor
-- =========================================
SELECT COUNT(DISTINCT last_name) AS distinct_last_names
FROM actor;

-- =========================================
-- last_name having count(*) = 1
-- =========================================
SELECT last_name
FROM actor
GROUP BY last_name 
HAVING count(*) = 1;

-- =========================================
-- last_name having count(*) > 1
-- =========================================
SELECT last_name, COUNT(*) AS occurrences
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- =========================================
-- film where title = 'Academy Dinosaur' (basic lookup)
-- =========================================
SELECT title, rental_duration
FROM film
WHERE title = 'Academy Dinosaur';

-- =========================================
-- Tavg(length) from film
-- =========================================
SELECT AVG(length) AS average_running_time
FROM film;

-- =========================================
-- count(actor_id) from actor
-- =========================================
SELECT COUNT(actor_id) AS actor_count
FROM actor;

-- =========================================
-- Films with rental_rate above average
-- =========================================
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);
