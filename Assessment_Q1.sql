-- Q1 - High-Value Customers with Multiple Products
SELECT 
    users.id AS owner_id,
    CONCAT(users.first_name, ' ', users.last_name) AS name,
    SUM(CASE
        WHEN plan.is_regular_savings = 1 THEN 1
        ELSE 0
    END) AS savings_count,
    SUM(CASE
        WHEN plan.is_a_fund = 1 THEN 1
        ELSE 0
    END) AS investments_count,
    ROUND(SUM(savings.confirmed_amount) / 100, 2) AS total_deposits
FROM
    users_customuser users
        JOIN
    savings_savingsaccount savings ON savings.owner_id = users.id
        JOIN
    plans_plan plan ON savings.plan_id = plan.id
GROUP BY users.id , users.first_name , users.last_name
HAVING SUM(CASE
    WHEN plan.is_regular_savings = 1 THEN 1
    ELSE 0
END) >= 1
    AND SUM(CASE
    WHEN plan.is_a_fund = 1 THEN 1
    ELSE 0
END) >= 1
ORDER BY total_deposits DESC;