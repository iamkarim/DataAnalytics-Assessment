-- Transaction Frequency Analysis
-- Calculate the average number of transactions per customer per month and categorize them:
-- "High Frequency" (≥10 transactions/month)
-- "Medium Frequency" (3-9 transactions/month)
-- "Low Frequency" (≤2 transactions/month)

WITH user_transactions AS (
    SELECT 
        savings.owner_id,
        DATE_FORMAT(savings.transaction_date, '%Y-%m') AS transaction_month,
        COUNT(*) AS monthly_transaction_count
    FROM 
       adashi_staging.savings_savingsaccount AS savings
-- 	WHERE 
-- 		transaction_status != 'failed'
    GROUP BY 
        savings.owner_id, transaction_month
),

monthly_avg AS (
    SELECT 
        users.owner_id,
        COUNT(DISTINCT transaction_month) AS transaction_months,
        SUM(monthly_transaction_count) AS total_transactions,
        ROUND(SUM(monthly_transaction_count)/ COUNT(DISTINCT transaction_month), 2) AS avg_transactions_per_month
    FROM 
        user_transactions users
    GROUP BY 
        users.owner_id
),

category AS(
	SELECT 
		custom_users.id AS user_id,
		CONCAT(custom_users.first_name, ' ', custom_users.last_name) AS name,
		monthly_avg.total_transactions,
		monthly_avg.avg_transactions_per_month,
		CASE
			WHEN monthly_avg.avg_transactions_per_month >= 10 THEN 'High Frequency'
			WHEN monthly_avg.avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
			ELSE 'Low Frequency'
		END AS frequency_segment
	FROM 
		monthly_avg 
	JOIN 
		users_customuser custom_users ON custom_users.id = monthly_avg.owner_id
	ORDER BY 
		monthly_avg.avg_transactions_per_month DESC)
    
SELECT
    frequency_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM category
GROUP BY frequency_segment
ORDER BY FIELD(frequency_segment, 'High Frequency', 'Medium Frequency', 'Low Frequency');