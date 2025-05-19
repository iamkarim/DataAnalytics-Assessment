
# DataAnalytics-Assessment

This repository presents solutions to a SQL assessment designed to evaluate technical SQL skills, analytical thinking, and business problem-solving. The simulated dataset is from a digital financial platform, including users, savings accounts, investment plans, and transactions.

---

## Repository Structure

```
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql    # Identify cross-product customers and rank by deposits
├── Assessment_Q2.sql    # Segment customers by transaction frequency
├── Assessment_Q3.sql    # Flag inactive accounts with no inflow
├── Assessment_Q4.sql    # Estimate Customer Lifetime Value (CLV)
└── README.md
```

Each SQL file addresses a real-world analytical question using structured, well-commented, and performant queries.

---

## Dataset Overview

The primary tables used in this assessment include:

- `users_customuser`: Customer profiles including registration and contact details.
- `savings_savingsaccount`: Deposit transactions for user savings.
- `plans_plan`: User savings and investment plans.
- `withdrawals_withdrawal`: Withdrawal records (not used in this assessment).

All monetary fields are stored in **kobo**, requiring conversion to **naira** for reporting purposes.

---

## Business Questions & SQL Approaches

### Q1: High-Value Customers with Multiple Products

**Goal:**  
Identify customers who own **both** a savings and an investment plan. Rank them by **total confirmed deposits** to highlight cross-sell opportunities.

**Solution Highlights:**
- Count plan types per user using conditional aggregation.
- Filter for users with both plan types via `HAVING`.
- Convert kobo to naira using `ROUND(SUM(...)/100, 2)`.
- Sort by total confirmed deposits.

---

### Q2: Transaction Frequency Analysis

**Goal:**  
Classify customers based on **average monthly transaction frequency** into three segments:
- **High Frequency** (≥10/month)
- **Medium Frequency** (3–9/month)
- **Low Frequency** (≤2/month)

**Solution Highlights:**
- Created a CTE to count user transactions per month.
- Calculated average monthly frequency using `ROUND(AVG(...), 1)`.
- Applied a `CASE` statement for segmentation.
- Aggregated final output with average metrics and counts per segment.

**Challenges:**
- Whether to take all transaction or just successful transactions
---

### Q3: Inactive Account Detection

**Goal:**  
Detect savings or investment plans that have had **no inflow** activity in the last **365 days** (for re-engagement or closure consideration).

**Solution Highlights:**
- Used `LEFT JOIN` to include plans with zero transactions.
- Calculated days of inactivity with `DATEDIFF(CURDATE(), MAX(savings,transaction_date))`.
- Applied filter via `HAVING inactivity_days >= 365`.

---

### Q4: Customer Lifetime Value (CLV) Estimation

**Goal:**  
Estimate a simplified CLV using the formula:

```
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
```

Assumptions:
- Profit per transaction is **0.1%** of the confirmed transaction amount.
- CLV is reported in **naira**.

**Solution Highlights:**
- Tenure calculated using `TIMESTAMPDIFF(MONTH, created_on, CURDATE())`.
- Used WHERE clause to avoid division by zero.
- Calculated average profit.
- Rounded CLV to 2 decimal places and sorted descending.

---

## Additional Notes

- All queries are **self-contained**, well-commented, and formatted for readability.
- The solutions combine **SQL proficiency** with **business reasoning** tailored for financial datasets.
- Useful for performance monitoring, customer segmentation, and lifecycle management insights.

---

## Submission Details

This repository is structured and documented in accordance with submission requirements.  
All scripts are clean, efficient, and ready for execution in a compatible SQL environment.
