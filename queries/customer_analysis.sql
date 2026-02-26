-- =========================================
-- Customers + store city (customer mapped to store/city)
-- =========================================
SELECT c.first_name, c.last_name, ci.city AS store_city
FROM customer c
JOIN  store s
ON c.store_id = s.store_id
JOIN address a
ON a.address_id = s.address_id
JOIN city ci
ON ci.city_id = a.city_id;

-- =========================================
-- Customer rentals history (customer + title + rental/return date)
-- =========================================
SELECT c.first_name, c.last_name, f.title AS film_title, r.rental_date, r.return_date
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
JOIN inventory i
ON i.inventory_id = r.inventory_id
JOIN film f
ON f.film_id = i.film_id;

-- =========================================
-- Rentals by “inactive” customers (needs fix: active is TINYINT; see note below)
-- =========================================
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
WHERE c.active = 'FALSE'
GROUP BY 1,2;

-- =========================================
-- Customers in London (customer + city filter)
-- =========================================
SELECT c.first_name, c.last_name, ci.city
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci
ON ci.city_id = a.city_id
WHERE ci.city = 'London';

-- =========================================
-- Top spender (customer full name + SUM(amount))
-- =========================================
SELECT CONCAT(c.first_name, ' ' , c.last_name) AS full_name, SUM(p.amount) AS total_amount_spent
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1
ORDER BY total_amount_spent DESC
LIMIT 1;

-- =========================================
-- Customers with no rentals (needs fix: NULL check)
-- =========================================
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
WHERE r.rental_id = 'NULL';

-- =========================================
-- Customer payments over time + LAG(amount) window function but customer-behavior focused)
-- =========================================
select first_name, last_name, payment_date, amount, lag(amount, 1,0) 
over(partition by c.customer_id order by payment_date) previous_amount
from customer c
join payment p
on c.customer_id = p.customer_id;
