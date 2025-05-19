-- Estimate Customer Lifetime Value (CLV) based on transaction behavior and tenure

SELECT 
	 -- Unique user ID
    users.id AS customer_id, 
    
	-- Full name of the user
    CONCAT(users.first_name, ' ', users.last_name) AS name,
    
    -- Number of months since the user registered
    TIMESTAMPDIFF(MONTH,users.created_on,CURDATE()) AS tenure_months,
    
    -- Total number of confirmed transactions for this user
    COUNT(savings.id) AS total_transactions,
    
    -- Estimated Customer Lifetime Value (CLV) formula: 
    -- (total_transactions / tenure) * 12 * avg_profit_per_transaction) rounded to 2 decimal places
    -- converted from kobo to naira
    ROUND(
        (COUNT(savings.id) / TIMESTAMPDIFF(MONTH, users.created_on, CURDATE())) * 12 *  
        (AVG(savings.confirmed_amount)/100 * 0.001),
        2) AS estimated_clv

FROM 
    adashi_staging.users_customuser AS users 

-- Join to savings accounts to access to transactions
JOIN 
    adashi_staging.savings_savingsaccount AS savings
    ON users.id = savings.owner_id 

WHERE 
    savings.confirmed_amount > 0 

GROUP BY 
    users.id, users.first_name, users.last_name, users.created_on

-- Order by estimated CLV from highest to lowest
ORDER BY 
    estimated_clv DESC;  

