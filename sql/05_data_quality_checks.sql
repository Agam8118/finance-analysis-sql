
USE finance_analytics;

-- CHECK 1: Look for duplicate transactions
-- Groups transactions with the same date, description,
-- amount, type, category and payment method.
SELECT
    transaction_date,
    description,
    amount,
    transaction_type,
    category_id,
    payment_method_id,
    COUNT(*) AS duplicate_count
FROM expenses
GROUP BY
    transaction_date,
    description,
    amount,
    transaction_type,
    category_id,
    payment_method_id
HAVING COUNT(*) > 1;


-- CHECK 2: Find missing or blank descriptions
SELECT *
FROM expenses
WHERE description IS NULL
   OR TRIM(description) = '';


-- CHECK 3: Find invalid transaction amounts
SELECT *
FROM expenses
WHERE amount IS NULL
   OR amount <= 0;


-- CHECK 4: Find transactions with dates in the future
SELECT *
FROM expenses
WHERE transaction_date > CURRENT_DATE();


-- CHECK 5: Find categories that have no expense transactions
SELECT
    c.category_id,
    c.category_name
FROM categories AS c
LEFT JOIN expenses AS e
    ON e.category_id = c.category_id
   AND e.transaction_type = 'expense'
WHERE e.transaction_id IS NULL;


-- CHECK 6: Find categories without any transactions
SELECT
    c.category_id,
    c.category_name
FROM categories AS c
LEFT JOIN expenses AS e
    ON e.category_id = c.category_id
WHERE e.transaction_id IS NULL;


-- CHECK 7: Check for missing monthly budgets
-- Lists expense categories without a budget for each month
-- between January and June 2026.
SELECT
    c.category_name,
    m.budget_month
FROM categories AS c
CROSS JOIN (
    SELECT DATE('2026-01-01') AS budget_month
    UNION ALL SELECT DATE('2026-02-01')
    UNION ALL SELECT DATE('2026-03-01')
    UNION ALL SELECT DATE('2026-04-01')
    UNION ALL SELECT DATE('2026-05-01')
    UNION ALL SELECT DATE('2026-06-01')
) AS m
LEFT JOIN budgets AS b
    ON b.category_id = c.category_id
   AND b.budget_month = m.budget_month
WHERE c.category_name IN (
    'Food', 'Housing', 'Transport', 'Utilities',
    'Healthcare', 'Entertainment', 'Shopping', 'Education'
)
AND b.budget_id IS NULL;


-- CHECK 8: Summarise data quality metrics
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE
        WHEN description IS NULL OR TRIM(description) = ''
        THEN 1 ELSE 0
    END) AS missing_descriptions,
    SUM(CASE
        WHEN amount IS NULL OR amount <= 0
        THEN 1 ELSE 0
    END) AS invalid_amounts,
    SUM(CASE
        WHEN transaction_date > CURRENT_DATE()
        THEN 1 ELSE 0
    END) AS future_dated_transactions
FROM expenses;
