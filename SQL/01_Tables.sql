-- CREDITLENS
-- Database Schema: Consumer Credit Risk & Portfolio Monitoring

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    age INT,
    annual_income NUMERIC(12,2),
    employment_status VARCHAR(30),
    city VARCHAR(50)
);

CREATE TABLE credit_accounts (
    account_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    credit_limit NUMERIC(12,2),
    outstanding_balance NUMERIC(12,2),
    account_status VARCHAR(30)
);

CREATE TABLE repayments (
    repayment_id INT PRIMARY KEY,
    account_id INT REFERENCES credit_accounts(account_id),
    payment_date DATE,
    amount_due NUMERIC(12,2),
    amount_paid NUMERIC(12,2),
    days_past_due INT
);
