-- Identify active (non-archived, non-deleted) savings or investment plans 
-- that have been inactive for more than 365 days based on the last transaction date
SELECT 

	-- Unique ID for the plan
	plan.id,
    
    -- Owner of the plan
	plan.owner_id,
    
    -- Determine the type of the plan whether investments or savings
	CASE 
		WHEN plan.is_a_fund = 1 THEN 'Investments'
        WHEN plan.is_regular_savings = 1 THEN 'Savings'
        ELSE 'Unclassified'
	END AS type,
    
    -- last transaction made by the owner
	MAX(savings.transaction_date) as last_transaction_date,
    
    -- Number of days from the last transaction date
	DATEDIFF(CURDATE(), MAX(savings.transaction_date)) AS inactivity_days
    
FROM 
    adashi_staging.plans_plan AS plan
    
LEFT JOIN 
    adashi_staging.savings_savingsaccount AS savings
    ON plan.id = savings.plan_id
    
-- PLans that are savings or investments plan and plans that are no archived or deleted to get active accounts    
WHERE 
    (plan.is_regular_savings = 1 OR plan.is_a_fund = 1)
	-- Exclude archived or deleted plans
    AND plan.is_archived = FALSE
    AND plan.is_deleted = FALSE
    
GROUP BY 
    plan.id, plan.owner_id, type

-- Getting active customers that have not had a transaction for over a year
HAVING
	last_transaction_date IS NOT NULL
    AND inactivity_days >= 365  

-- Show the most inactive plans first
ORDER BY 
    inactivity_days DESC;  