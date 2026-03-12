select * from customer limit 10;

--Total revenue generated - Males vs Female
SELECT gender, SUM(purchase_amount)AS revemue_generated
FROM customer
GROUP BY gender;

--Which customer used a discount but still spent more than avg purchased amount?	
SELECT customer_id, purchase_amount	
FROM customer	
WHERE purchase_amount >=(SELECT AVG(purchase_amount) FROM customer)	
ORDER BY purchase_amount;	

--Top 5 products with highest avg review rating	
SELECT item_purchased, ROUND(AVG(review_rating::numeric),2) AS highest_review_rating	
FROM customer	
GROUP BY item_purchased	
ORDER BY AVG(review_rating) DESC	
LIMIT 5;	

--Compare avg purchase amounts between standard and express shipping
SELECT shipping_type, ROUND(AVG(purchase_amount),2) AS avg_purchase_amount	
FROM customer	
WHERE shipping_type IN ('Standard','Express')	
GROUP BY shipping_type;	

--Do subscribed customers spend more? Compare avg spend and Total revenue bw sub and non-sub
select subscription_status, COUNT(customer_id), 	
ROUND(AVG(purchase_amount),2) AS avg_amount_spent,ROUND(SUM(purchase_amount),0) AS total_revenue	
FROM customer	
GROUP BY subscription_status	
ORDER BY avg_amount_spent,total_revenue DESC;	

--5 products have highest % of purchases with discounts applied	
SELECT item_purchased, 	
100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 end)/ COUNT(*) AS discount_rate	
FROM customer	
GROUP BY item_purchased	
ORDER BY discount_rate DESC	
LIMIT 5;	

--Segment cutomer into New, Returning, Loyal based on the Total no. of previous purchases and show count for each
WITH customer_segment as(	
SELECT customer_id, previous_purchases,	
CASE 	
	WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'Loyal'
END AS customer_types	
FROM customer	
)	
SELECT customer_types,COUNT(*) AS customer_count	
FROM customer_segment	
GROUP BY customer_types	
ORDER BY customer_count DESC;	

--Top 3 most purchased products within each category	
WITH item_description AS(	
SELECT item_purchased, category, COUNT(customer_id) As total_orders,	
ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id)DESC) AS item_rank	
FROM customer	
GROUP BY category,item_purchased	
)	
SELECT item_rank,category,item_purchased,total_orders	
FROM item_description	
WHERE item_rank<=3;	

--Are customers who are repeat buyers(>5 previous purchases) also likely to subscribe?	
SELECT subscription_status, COUNT(customer_id) as repeat_buyers	
FROM customer	
WHERE previous_purchases > 5	
GROUP BY subscription_status;	

--revenue contibution of each group
SELECT age_category, SUM(purchase_amount) AS total_revenue	
FROM customer	
GROUP BY age_category	
ORDER BY total_revenue DESC;	


