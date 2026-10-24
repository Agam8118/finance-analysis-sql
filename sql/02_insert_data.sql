
USE finance_analytics;

-- 1. Insert categories
INSERT INTO categories (category_name)
VALUES
    ('Salary'),
    ('Freelance'),
    ('Food'),
    ('Housing'),
    ('Transport'),
    ('Utilities'),
    ('Healthcare'),
    ('Entertainment'),
    ('Shopping'),
    ('Education')
ON DUPLICATE KEY UPDATE
    category_name = VALUES(category_name);

-- 2. Insert payment methods
INSERT INTO payment_methods (method_name)
VALUES
    ('UPI'),
    ('Cash'),
    ('Debit Card'),
    ('Credit Card'),
    ('Bank Transfer')
ON DUPLICATE KEY UPDATE
    method_name = VALUES(method_name);

-- 3. Insert fictional income and expense transactions
-- Amounts are in INR.
-- NOT EXISTS makes this sample transaction insert safe to rerun.
INSERT INTO expenses
    (transaction_date, description, amount,
     transaction_type, category_id, payment_method_id)
SELECT
    sample.transaction_date,
    sample.description,
    sample.amount,
    sample.transaction_type,
    c.category_id,
    p.payment_method_id
FROM (
    SELECT DATE('2026-01-01') AS transaction_date,
           'Monthly salary' AS description,
           45000.00 AS amount,
           'income' AS transaction_type,
           'Salary' AS category_name,
           'Bank Transfer' AS method_name
    UNION ALL SELECT '2026-01-03', 'Monthly rent', 12000, 'expense', 'Housing', 'Bank Transfer'
    UNION ALL SELECT '2026-01-05', 'Groceries', 2200, 'expense', 'Food', 'UPI'
    UNION ALL SELECT '2026-01-08', 'Bus and auto travel', 650, 'expense', 'Transport', 'UPI'
    UNION ALL SELECT '2026-01-10', 'Electricity bill', 1400, 'expense', 'Utilities', 'UPI'
    UNION ALL SELECT '2026-01-12', 'Online course', 1800, 'expense', 'Education', 'Debit Card'
    UNION ALL SELECT '2026-01-15', 'Dinner with friends', 950, 'expense', 'Entertainment', 'UPI'
    UNION ALL SELECT '2026-01-18', 'Freelance website work', 5000, 'income', 'Freelance', 'Bank Transfer'
    UNION ALL SELECT '2026-01-20', 'Pharmacy', 450, 'expense', 'Healthcare', 'Cash'
    UNION ALL SELECT '2026-01-24', 'Clothing', 1600, 'expense', 'Shopping', 'Credit Card'

    UNION ALL SELECT '2026-02-01', 'Monthly salary', 45000, 'income', 'Salary', 'Bank Transfer'
    UNION ALL SELECT '2026-02-03', 'Monthly rent', 12000, 'expense', 'Housing', 'Bank Transfer'
    UNION ALL SELECT '2026-02-06', 'Groceries', 2600, 'expense', 'Food', 'UPI'
    UNION ALL SELECT '2026-02-08', 'Metro and bus travel', 800, 'expense', 'Transport', 'UPI'
    UNION ALL SELECT '2026-02-10', 'Electricity and internet', 1900, 'expense', 'Utilities', 'UPI'
    UNION ALL SELECT '2026-02-12', 'Medical appointment', 1200, 'expense', 'Healthcare', 'Debit Card'
    UNION ALL SELECT '2026-02-14', 'Movie and dinner', 1800, 'expense', 'Entertainment', 'Credit Card'
    UNION ALL SELECT '2026-02-17', 'Freelance design work', 3500, 'income', 'Freelance', 'Bank Transfer'
    UNION ALL SELECT '2026-02-21', 'Headphones', 2800, 'expense', 'Shopping', 'Credit Card'
    UNION ALL SELECT '2026-02-25', 'Study material', 900, 'expense', 'Education', 'UPI'

    UNION ALL SELECT '2026-03-01', 'Monthly salary', 45000, 'income', 'Salary', 'Bank Transfer'
    UNION ALL SELECT '2026-03-03', 'Monthly rent', 12000, 'expense', 'Housing', 'Bank Transfer'
    UNION ALL SELECT '2026-03-05', 'Groceries and dining', 3400, 'expense', 'Food', 'UPI'
    UNION ALL SELECT '2026-03-08', 'Fuel and travel', 1100, 'expense', 'Transport', 'UPI'
    UNION ALL SELECT '2026-03-10', 'Electricity bill', 1550, 'expense', 'Utilities', 'UPI'
    UNION ALL SELECT '2026-03-13', 'Online course subscription', 2200, 'expense', 'Education', 'Debit Card'
    UNION ALL SELECT '2026-03-16', 'Concert ticket', 2500, 'expense', 'Entertainment', 'Credit Card'
    UNION ALL SELECT '2026-03-18', 'Freelance programming', 7000, 'income', 'Freelance', 'Bank Transfer'
    UNION ALL SELECT '2026-03-22', 'Doctor and medicine', 850, 'expense', 'Healthcare', 'UPI'
    UNION ALL SELECT '2026-03-26', 'Backpack', 1900, 'expense', 'Shopping', 'Debit Card'

    UNION ALL SELECT '2026-04-01', 'Monthly salary', 47000, 'income', 'Salary', 'Bank Transfer'
    UNION ALL SELECT '2026-04-03', 'Monthly rent', 12000, 'expense', 'Housing', 'Bank Transfer'
    UNION ALL SELECT '2026-04-06', 'Groceries', 2800, 'expense', 'Food', 'UPI'
    UNION ALL SELECT '2026-04-09', 'Local transport', 750, 'expense', 'Transport', 'Cash'
    UNION ALL SELECT '2026-04-11', 'Electricity and internet', 1750, 'expense', 'Utilities', 'UPI'
    UNION ALL SELECT '2026-04-14', 'Course materials', 1200, 'expense', 'Education', 'Debit Card'
    UNION ALL SELECT '2026-04-17', 'Restaurant dinner', 1400, 'expense', 'Entertainment', 'UPI'
    UNION ALL SELECT '2026-04-19', 'Freelance project', 6000, 'income', 'Freelance', 'Bank Transfer'
    UNION ALL SELECT '2026-04-22', 'Medicines', 600, 'expense', 'Healthcare', 'Cash'
    UNION ALL SELECT '2026-04-26', 'Clothes', 3200, 'expense', 'Shopping', 'Credit Card'

    UNION ALL SELECT '2026-05-01', 'Monthly salary', 47000, 'income', 'Salary', 'Bank Transfer'
    UNION ALL SELECT '2026-05-03', 'Monthly rent', 12000, 'expense', 'Housing', 'Bank Transfer'
    UNION ALL SELECT '2026-05-05', 'Groceries and dining', 3900, 'expense', 'Food', 'UPI'
    UNION ALL SELECT '2026-05-08', 'Transport and fuel', 1300, 'expense', 'Transport', 'UPI'
    UNION ALL SELECT '2026-05-10', 'Electricity bill', 1600, 'expense', 'Utilities', 'UPI'
    UNION ALL SELECT '2026-05-13', 'Online certification', 2500, 'expense', 'Education', 'Debit Card'
    UNION ALL SELECT '2026-05-16', 'Gaming subscription', 1100, 'expense', 'Entertainment', 'Credit Card'
    UNION ALL SELECT '2026-05-19', 'Freelance website', 4500, 'income', 'Freelance', 'Bank Transfer'
    UNION ALL SELECT '2026-05-22', 'Health checkup', 1500, 'expense', 'Healthcare', 'UPI'
    UNION ALL SELECT '2026-05-26', 'Computer accessories', 4200, 'expense', 'Shopping', 'Credit Card'

    UNION ALL SELECT '2026-06-01', 'Monthly salary', 47000, 'income', 'Salary', 'Bank Transfer'
    UNION ALL SELECT '2026-06-03', 'Monthly rent', 12000, 'expense', 'Housing', 'Bank Transfer'
    UNION ALL SELECT '2026-06-06', 'Groceries', 3100, 'expense', 'Food', 'UPI'
    UNION ALL SELECT '2026-06-08', 'Bus and auto travel', 900, 'expense', 'Transport', 'UPI'
    UNION ALL SELECT '2026-06-10', 'Electricity and internet', 1850, 'expense', 'Utilities', 'UPI'
    UNION ALL SELECT '2026-06-12', 'Textbooks', 1600, 'expense', 'Education', 'Debit Card'
    UNION ALL SELECT '2026-06-15', 'Weekend outing', 2100, 'expense', 'Entertainment', 'Credit Card'
    UNION ALL SELECT '2026-06-18', 'Freelance coding work', 8000, 'income', 'Freelance', 'Bank Transfer'
    UNION ALL SELECT '2026-06-22', 'Pharmacy', 700, 'expense', 'Healthcare', 'Cash'
    UNION ALL SELECT '2026-06-26', 'Clothing and accessories', 2400, 'expense', 'Shopping', 'Credit Card'
) AS sample
JOIN categories AS c
    ON c.category_name = sample.category_name
JOIN payment_methods AS p
    ON p.method_name = sample.method_name
WHERE NOT EXISTS (
    SELECT 1
    FROM expenses AS existing
    WHERE existing.transaction_date = sample.transaction_date
      AND existing.description = sample.description
      AND existing.amount = sample.amount
      AND existing.transaction_type = sample.transaction_type
);

-- 4. Insert monthly budgets for expense categories
-- Budget months are stored as the first day of each month.
INSERT INTO budgets (category_id, budget_month, budget_amount)
SELECT
    c.category_id,
    m.budget_month,
    CASE c.category_name
        WHEN 'Food' THEN 3500
        WHEN 'Housing' THEN 12000
        WHEN 'Transport' THEN 1000
        WHEN 'Utilities' THEN 1800
        WHEN 'Healthcare' THEN 1000
        WHEN 'Entertainment' THEN 1500
        WHEN 'Shopping' THEN 2500
        WHEN 'Education' THEN 2000
    END AS budget_amount
FROM categories AS c
CROSS JOIN (
    SELECT DATE('2026-01-01') AS budget_month
    UNION ALL SELECT '2026-02-01'
    UNION ALL SELECT '2026-03-01'
    UNION ALL SELECT '2026-04-01'
    UNION ALL SELECT '2026-05-01'
    UNION ALL SELECT '2026-06-01'
) AS m
WHERE c.category_name IN (
    'Food', 'Housing', 'Transport', 'Utilities',
    'Healthcare', 'Entertainment', 'Shopping', 'Education'
)
ON DUPLICATE KEY UPDATE
    budget_amount = VALUES(budget_amount);
