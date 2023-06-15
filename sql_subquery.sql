USE sakila;

SELECT first_name 
FROM actor
WHERE actor_id = 1;

SELECT first_name
FROM actor
WHERE actor_id in (SELECT actor_id
		           FROM film_actor
                   WHERE film_id IN (SELECT film_id
                                     FROM film_category
									  WHERE category_id = (SELECT category_id
														   FROM category
                                                            WHERE name = 'Action')));
                                                            
  #Determine the number of copies in the inventory with the name 'Hunchback Impossible'.
  SELECT COUNT(film_id)
  FROM inventory
  WHERE film_id in (SELECT film_id
                    FROM FILM 
                    WHERE title = (SELECT title
                                   FROM film 
                                   WHERE title = 'Hunchback Impossible'));
#List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title,length
FROM film
WHERE length > (SELECT AVG(length)
                FROM FILM);
#Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id
                   FROM film_actor
                   WHERE film_id = (SELECT film_id
								    FROM film
									WHERE title = 'Alone Trip'));
                                    
#Sales have been lagging among young families, and you want to target family movies for a promotion. 
#Identify all movies categorized as family films.								
SELECT title
FROM film
WHERE film_id in (SELECT film_id
                 FROM film_category
                 WHERE category_id = (SELECT category_id 
                                      FROM category
                                      WHERE NAME = 'Family'));
#Retrieve the name and email of customers from Canada using both subqueries and joins. 
#To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT first_name,last_name,email
FROM customer
WHERE address_id in (SELECT address_id
					 FROM address
                     WHERE city_id in (SELECT city_id
                                      FROM city
                                      where country_id in (SELECT country_id
                                                          FROM country
                                                          where country = 'Canada')));
 #Determine which films were starred by the most prolific actor in the Sakila database. 
 #A prolific actor is defined as the actor who has acted in the most number of films.
 #First, you will need to find the most prolific actor and then use that actor_id 
 #to find the different films that he or she starred in.                                                         
                                                          
SELECT first_name,last_name,actor_id
FROM actor
WHERE actor_id in (SELECT actor_id
                   FROM film_actor
                   WHERE film_id = MAX(COUNT(film_id)));
                                                          
                                                          
SELECT film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT actor_id
    FROM (
        SELECT actor_id, COUNT(*) AS film_count
        FROM film_actor
        GROUP BY actor_id
        ORDER BY film_count DESC
        LIMIT 1
    ) AS most_prolific_actor
);
                                                          
#Find the films rented by the most profitable customer in the Sakila database. 
#You can use the customer and payment tables to find the most profitable customer, 
#i.e., the customer who has made the largest sum of payments.
                
SELECT film.film_id, film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN customer ON rental.customer_id = customer.customer_id
WHERE customer.customer_id IN (
    SELECT customer_id
    FROM (
        SELECT customer_id, SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
        ORDER BY total_amount DESC
        LIMIT 1
    ) AS most_profitable_customer);

Retrieve the client_id and the total_amount_spent of those clients
 who spent more than the average of the total_amount spent by each client.
 You can use subqueries to accomplish this.