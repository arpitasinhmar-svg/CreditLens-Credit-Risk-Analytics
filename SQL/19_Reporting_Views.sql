CREATE OR REPLACE VIEW vw_portfolio_overview AS
SELECT
    COUNT(*) AS total_accounts,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(credit_limit) AS total_credit_exposure,
    SUM(outstanding_balance) AS total_outstanding,
    ROUND(
        SUM(outstanding_balance) /
        NULLIF(SUM(credit_limit), 0) * 100,
        2
    ) AS portfolio_utilisation,
    COUNT(*) FILTER (
        WHERE account_status = 'ACTIVE'
    ) AS active_accounts,
    COUNT(*) FILTER (
        WHERE account_status = 'CLOSED'
    ) AS closed_accounts
FROM credit_accounts;


-- View 2: Monthly repayment performance
CREATE OR REPLACE VIEW vw_monthly_repayment_performance AS
SELECT
    DATE_TRUNC('month', payment_date)::DATE AS repayment_month,
    COUNT(*) AS total_repayments,
    SUM(amount_due) AS total_amount_due,
    SUM(amount_paid) AS total_amount_paid,
    ROUND(
        SUM(amount_paid) /
        NULLIF(SUM(amount_due), 0) * 100,
        2
    ) AS collection_rate,
    ROUND(AVG(days_past_due), 2) AS average_dpd
FROM repayments
GROUP BY DATE_TRUNC('month', payment_date);


-- View 3: Customer account profile
CREATE OR REPLACE VIEW vw_customer_account_profile AS
SELECT
    c.customer_id,
    c.age,
    c.annual_income,
    c.employment_status,
    c.city,
    ca.account_id,
    ca.credit_limit,
    ca.outstanding_balance,
    ROUND(
        ca.outstanding_balance /
        NULLIF(ca.credit_limit, 0) * 100,
        2
    ) AS utilisation_percentage,
    ca.account_status
FROM customers c
JOIN credit_accounts ca
    ON c.customer_id = ca.customer_id;
