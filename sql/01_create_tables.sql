
CREATE DATABASE IF NOT EXISTS finance_analytics;
USE finance_analytics;

-- Stores expense and income categories
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Stores available payment methods
CREATE TABLE IF NOT EXISTS payment_methods (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE
);

-- Stores individual income and expense transactions
CREATE TABLE IF NOT EXISTS expenses (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_date DATE NOT NULL,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    transaction_type ENUM('income', 'expense') NOT NULL,
    category_id INT NOT NULL,
    payment_method_id INT NOT NULL,

    CONSTRAINT chk_transaction_amount CHECK (amount > 0),

    CONSTRAINT fk_expenses_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT fk_expenses_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(payment_method_id),

    INDEX idx_transaction_date (transaction_date),
    INDEX idx_transaction_type (transaction_type)
);

-- Monthly budget allocated to each expense category
CREATE TABLE IF NOT EXISTS budgets (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    budget_month DATE NOT NULL,
    budget_amount DECIMAL(12, 2) NOT NULL,

    CONSTRAINT chk_budget_amount CHECK (budget_amount >= 0),

    CONSTRAINT fk_budgets_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT uq_category_month
        UNIQUE (category_id, budget_month)
);
