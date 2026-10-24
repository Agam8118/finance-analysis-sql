
USE finance_analytics;

-- QUERY 1: Overall financial summary
-- Demonstrates conditional aggregation
SELECT
    ROUND(SUM(CASE
        WHEN transaction_type = 'income' THEN amount ELSE 0
    END), 2) AS total_income,
    ROUND(SUM(CASE
        WHEN transaction_type = 'expense' THEN amount ELSE 0
    END), 2) AS total_expenses,
    ROUND(SUM(CASE
        WHEN transaction_type = 'income' THEN amount
        WHEN transaction_type = 'expense' THEN -amount
        ELSE 0
    END), 2) AS net_savings
FROM expenses;


-- QUERY 2: Monthly income, expenses and net savings
-- Demonstrates GROUP BY and date functions
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    ROUND(SUM(CASE
        WHEN transaction_type = 'income' THEN amount ELSE 0
    END), 2) AS income,
    ROUND(SUM(CASE
        WHEN transaction_type = 'expense' THEN amount ELSE 0
    END), 2) AS expenses,
    ROUND(SUM(CASE
        WHEN transaction_type = 'income' THEN amount
        WHEN transaction_type = 'expense' THEN -amount
        ELSE 0
    END), 2) AS net_savings
FROM expenses
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY month;


-- QUERY 3: Spending by category
-- Demonstrates JOIN, aggregation and sorting
SELECT
    c.category_name,
    COUNT(e.transaction_id) AS transaction_count,
    ROUND(SUM(e.amount), 2) AS total_spent,
    ROUND(AVG(e.amount), 2) AS average_transaction
FROM expenses AS e
JOIN categories AS c
    ON e.category_id = c.category_id
WHERE e.transaction_type = 'expense'
GROUP BY c.category_id, c.category_name
ORDER BY total_spent DESC;


-- QUERY 4: Monthly budget versus actual spending
-- Demonstrates multiple joins and conditional aggregation
SELECT
    DATE_FORMAT(b.budget_month, '%Y-%m') AS month,
    c.category_name,
    b.budget_amount,
    ROUND(COALESCE(SUM(
        CASE
            WHEN e.transaction_type = 'expense'
             AND e.transaction_date >= b.budget_month
             AND e.transaction_date < DATE_ADD(b.budget_month, INTERVAL 1 MONTH)
            THEN e.amount
            ELSE 0
        END
    ), 0), 2) AS actual_spending,
    ROUND(
        b.budget_amount - COALESCE(SUM(
            CASE
                WHEN e.transaction_type = 'expense'
                 AND e.transaction_date >= b.budget_month
                 AND e.transaction_date < DATE_ADD(b.budget_month, INTERVAL 1 MONTH)
                THEN e.amount
                ELSE 0
            END
        ), 0),
        2
    ) AS remaining_budget,
    CASE
        WHEN COALESCE(SUM(
            CASE
                WHEN e.transaction_type = 'expense'
                 AND e.transaction_date >= b.budget_month
                 AND e.transaction_date < DATE_ADD(b.budget_month, INTERVAL 1 MONTH)
                THEN e.amount
                ELSE 0
            END
        ), 0) > b.budget_amount THEN 'Over budget'
        ELSE 'Within budget'
    END AS budget_status
FROM budgets AS b
JOIN categories AS c
    ON b.category_id = c.category_id
LEFT JOIN expenses AS e
    ON e.category_id = b.category_id
   AND e.transaction_date >= b.budget_month
   AND e.transaction_date < DATE_ADD(b.budget_month, INTERVAL 1 MONTH)
GROUP BY
    b.budget_id,
    b.budget_month,
    c.category_name,
    b.budget_amount
ORDER BY b.budget_month, c.category_name;


-- QUERY 5: Top three spending categories
-- Demonstrates aggregation with LIMIT
SELECT
    c.category_name,
    ROUND(SUM(e.amount), 2) AS total_spent
FROM expenses AS e
JOIN categories AS c
    ON e.category_id = c.category_id
WHERE e.transaction_type = 'expense'
GROUP BY c.category_id, c.category_name
ORDER BY total_spent DESC
LIMIT 3;


-- QUERY 6: Spending by payment method
SELECT
    p.method_name,
    COUNT(e.transaction_id) AS transaction_count,
    ROUND(SUM(e.amount), 2) AS total_spent
FROM expenses AS e
JOIN payment_methods AS p
    ON e.payment_method_id = p.payment_method_id
WHERE e.transaction_type = 'expense'
GROUP BY p.payment_method_id, p.method_name
ORDER BY total_spent DESC;


-- QUERY 7: Month-over-month spending change
-- Demonstrates CTEs and the LAG window function
WITH monthly_spending AS (
    SELECT
        CAST(DATE_FORMAT(transaction_date, '%Y-%m-01') AS DATE) AS month_start,
        SUM(amount) AS total_spent
    FROM expenses
    WHERE transaction_type = 'expense'
    GROUP BY CAST(DATE_FORMAT(transaction_date, '%Y-%m-01') AS DATE)
),
spending_comparison AS (
    SELECT
        month_start,
        total_spent,
        LAG(total_spent) OVER (ORDER BY month_start) AS previous_month_spending
    FROM monthly_spending
)
SELECT
    DATE_FORMAT(month_start, '%Y-%m') AS month,
    ROUND(total_spent, 2) AS total_spent,
    ROUND(previous_month_spending, 2) AS previous_month_spending,
    ROUND(total_spent - previous_month_spending, 2) AS change_amount,
    ROUND(
        100.0 * (total_spent - previous_month_spending)
        / NULLIF(previous_month_spending, 0),
        2
    ) AS change_percentage
FROM spending_comparison
ORDER BY month_start;


-- QUERY 8: Transactions above the average expense amount
-- Demonstrates a scalar subquery
SELECT
    e.transaction_id,
    e.transaction_date,
    e.description,
    c.category_name,
    e.amount
FROM expenses AS e
JOIN categories AS c
    ON e.category_id = c.category_id
WHERE e.transaction_type = 'expense'
  AND e.amount > (
      SELECT AVG(amount)
      FROM expenses
      WHERE transaction_type = 'expense'
  )
ORDER BY e.amount DESC;


-- QUERY 9: Income sources
SELECT
    c.category_name AS income_source,
    COUNT(e.transaction_id) AS transaction_count,
    ROUND(SUM(e.amount), 2) AS total_income,
    ROUND(AVG(e.amount), 2) AS average_income
FROM expenses AS e
JOIN categories AS c
    ON e.category_id = c.category_id
WHERE e.transaction_type = 'income'
GROUP BY c.category_id, c.category_name
ORDER BY total_income DESC;


-- QUERY 10: Daily spending summary
SELECT
    transaction_date,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS daily_spending
FROM expenses
WHERE transaction_type = 'expense'
GROUP BY transaction_date
ORDER BY transaction_date;
