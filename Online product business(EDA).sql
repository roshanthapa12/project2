-- 1.How many users are there?
SELECT COUNT(DISTINCT user_id) AS users FROM users

-- 2.What is the unique number of visits by all users per month?
SELECT TO_CHAR(u.start_date, 'YYYY-MM') AS month_year, COUNT(DISTINCT e.event_type) AS unique_visits
FROM users u
JOIN event e ON u.user_id = e.event_type
WHERE e.event_type IN ('1', '2') 
GROUP BY month_year
ORDER BY month_year;

-- 3.What is the number of events for each event type?
SELECT event_type,COUNT(*) AS event_count
FROM event
GROUP BY event_type
ORDER BY event_type;

-- 4.What are the top 3 pages by number of views?
SELECT p.page_id,p.page_name,COUNT(e.event_type) as views from newevents e
JOIN page p ON e.page_id=p.page_id
WHERE e.event_type = 1
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3;

-- 5. What is the number of views and cart adds for each product category?
SELECT e.page_id, p.page_name, COUNT(e.event_type) AS views,p.product_category AS cart_adds  FROM newevents e
JOIN page p ON e.page_id=p.page_id
WHERE e.event_type = 1
GROUP BY 1,2,4
ORDER BY page_id;

-- 6. What is the percentage of visits which have a purchase event?
WITH purchase_visits AS(
    SELECT COUNT(event_type) as purchase_visit FROM newevents
	WHERE event_type = 3
),
total_visits AS (
   SELECT COUNT( distinct visit_id) as all_visit FROM newevents
 )
SELECT t.all_visit,p.purchase_visit, p.purchase_visit*100/t.all_visit as percecentage_p_visits
FROM purchase_visits p
CROSS JOIN  total_visits t;

-- 7.What are the top 3 products by add to cart?
SELECT p.product_category, COUNT(*) AS total_products from newevents n
JOIN page p ON p.page_id= n.page_id 
WHERE n.event_type = 2
GROUP BY 1
ORDER BY 2 DESC;

-- 8.Using a single SQL query - create a new output table which has the following details:
-- . How many times was each product viewed?
-- . How many times was each product added to cart?
-- . How many times was each product added to a cart but not purchased (abandoned)?
-- . How many times was each product purchased?
 
 SELECT p.product_category,
  COUNT(CASE WHEN e.event_type = '1' THEN 1 END) AS view_count,
  COUNT(CASE WHEN e.event_type = '2' THEN 1 END) AS cart_count,
  COUNT(CASE WHEN e.event_type = '2' THEN 1 END) - COUNT(CASE WHEN e.event_type = '3' THEN 1 END) AS abandoned_count,
  COUNT(CASE WHEN e.event_type = '3' THEN 1 END) AS purchase_count
FROM newevents e
JOIN page p ON e.page_id = p.page_id
GROUP BY 1; 

-- 9. What is the percentage of visits which view the checkout page but do not have a purchase event?
 WITH checkout_visit AS(
     SELECT COUNT(DISTINCT visit_id) as total_visit,COUNT(page_id)as page  FROM newevents
	 WHERE page_id = 12
),
purchase as(
   SELECT count(distinct visit_id)as purchase_event,COUNT(page_id)as page FROM newevents
	WHERE event_type =3
)
SELECT  round((c.total_visit- p.purchase_event)/100) as percentage_visit from purchase p
JOIN checkout_visit c ON p.page= c.page



  
