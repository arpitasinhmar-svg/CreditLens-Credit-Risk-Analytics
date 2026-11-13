SELECT
    COUNT(*) AS total_accounts,

    COUNT(DISTINCT customer_id) AS total_customers,

    ROUND(SUM(credit_limit), 2) AS total_credit_exposure,

    ROUND(SUM(outstanding_balance), 2) AS total_outstanding,

    ROUND(
        SUM(outstanding_balance) /
        NULLIF(SUM(credit_limit), 0) * 100,
        2
    ) AS portfolio_utilisation,

    ROUND(AVG(outstanding_balance), 2) AS average_outstanding,

    COUNT(*) FILTER (
        WHERE account_status = 'ACTIVE'
    ) AS active_accounts,

    COUNT(*) FILTER (
        WHERE account_status = 'CLOSED'
    ) AS closed_accounts

FROM credit_accounts;
