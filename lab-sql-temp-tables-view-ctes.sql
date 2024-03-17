-- Creating a Customer Summary Report
-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
-- including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

USE sakila;

CREATE VIEW Customer_rental_summary AS 
SELECT c.customer_id, 
concat(c.first_name, " ", c.last_name) AS customer_name, 
c.email, count(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table 
-- should use the rental summary view created in Step 1 to join with the payment table 
-- and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    crs.customer_name,
    crs.email,
    crs.rental_count,
    SUM(p.amount) AS total_paid
FROM 
(SELECT c.customer_id, 
concat(c.first_name, " ", c.last_name) AS customer_name, 
c.email, count(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email) AS crs

LEFT JOIN rental r ON crs.customer_id = r.customer_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY crs.customer_id, crs.customer_name, crs.email, crs.rental_count;


-- Step 3: Create a CTE and generate the Customer Summary Report

WITH customer_summary_report AS (
    SELECT
        cps.customer_id,
        cps.customer_name,
        cps.email,
        cps.rental_count,
        cps.total_paid
    FROM
        customer_payment_summary cps
)
SELECT
    csr.customer_id,
    csr.customer_name,
    csr.email,
    csr.rental_count,
    csr.total_paid
FROM
    customer_summary_report csr;




