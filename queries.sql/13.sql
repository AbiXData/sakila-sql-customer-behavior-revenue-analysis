SELECT first_name, last_name, title
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON a.actor_id = fa.actor_id
WHERE title = 'Academy Dinosaur';
