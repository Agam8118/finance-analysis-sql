
USE finance_analytics;

-- View 1: Monthly financial summary
CREATE OR REPLACE VIEW vw_monthly_financial_summary AS
SELECT
    CAST(DATE_FORMAT(transaction_date, '%Y-%m-01') AS DATE)
        AS month_start,
    ROUND(SUM(
        CASE WHEN transaction_type = 'income'
             THEN amount ELSE 0 END
    ), 2) AS total_income,
    ROUND(SUM(
        CASE WHEN transaction_type = 'expense'
             THEN amount ELSE 0 END
    ), 2) AS total_expenses,
    ROUND(SUM(
        CASE WHEN transaction_type = 'income'
             THEN amount
             WHEN transaction_type = 'expense'
             THEN -amount
             ELSE 0 END
    ), 2) AS net_savings
FROM expenses
GROUP BY CAST(DATE_FORMAT(transaction_date, '%Y-%m-01') AS DATE);


-- View 2: Spending by category
CREATE OR REPLACE VIEW vw_category_spending AS
SELECT
    c.category_id,
    c.category_name,
    COUNT(e.transaction_id) AS transaction_count,
    ROUND(COALESCE(SUM(e.amount), 0), 2) AS total_spent,
    ROUND(AVG(e.amount), 2) AS average_transaction
FROM categories AS c
LEFT JOIN expenses AS e
    ON e.category_id = c.category_id
   AND e.transaction_type = 'expense'
GROUP BY c.category_id, c.category_name;


-- View 3: Monthly budget performance
CREATE OR REPLACE VIEW vw_budget_performance AS
SELECT
    b.budget_id,
    b.budget_month,
    c.category_name,
    b.budget_amount,
    ROUND(COALESCE(SUM(
        CASE
            WHEN e.transaction_type = 'expense'
            THEN e.amount
            ELSE 0
        END
    ), 0), 2) AS actual_spending,
    ROUND(
        b.budget_amount - COALESCE(SUM(
            CASE
                WHEN e.transaction_type = 'expense'
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
                THEN e.amount
                ELSE 0
            END
        ), 0) > b.budget_amount
        THEN 'Over budget'
        ELSE 'Within budget'
    END AS budget_status
FROM budgets AS b
JOIN categories AS c
    ON c.category_id = b.category_id
LEFT JOIN expenses AS e
    ON e.category_id = b.category_id
   AND e.transaction_date >= b.budget_month
   AND e.transaction_date < DATE_ADD(
       b.budget_month, INTERVAL 1 MONTH
   )
GROUP BY
    b.budget_id,
    b.budget_month,
    c.category_name,
    b.budget_amount;
