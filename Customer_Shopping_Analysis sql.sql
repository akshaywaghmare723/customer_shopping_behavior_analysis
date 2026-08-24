SELECT 
    gender,
    SUM(purchase_amount) AS revenue
FROM customer
GROUP BY gender;
SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'YES' and purchase_amount >= (SELECT AVG(purchase_amount) from customer);
SELECT 
    item_purchased,
    ROUND(AVG(review_rating), 2) AS `Average Product Rating`
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;
SELECT shipping_type,
ROUND(AVG(purchase_amount), 2)
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;
SELECT subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC;
SELECT item_purchased,
ROUND(SUM(CASE WHEN discount_applied = 'YES' THEN 1 ELSE 0 END)/COUNT(*) * 100,2) AS discount_rate
from customer
GROUP BY item_purchased
ORDER BY discount_rate DESC LIMIT 5;
WITH customer_type as (
select customer_id, previous_purchases,
CASE
WHEN previous_purchases = 1 THEN 'NEW'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returing'
ELSE 'Loyal'
END AS customer_segment
from customer
)

select customer_segment, count(*) as "Number of Customers"
from customer_type
GROUP BY customer_segment;
WITH item_counts AS (
    SELECT
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;
SELECT subscription_status,
COUNT(customer_id) as repeat_buyers
from customer
WHERE previous_purchases > 5
GROUP BY subscription_status;
SELECT age_group,
SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue DESC;





