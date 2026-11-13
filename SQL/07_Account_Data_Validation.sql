SELECT
    COUNT(*) AS total_accounts,
    COUNT(DISTINCT credit_limit) AS unique_credit_limits,
    COUNT(DISTINCT outstanding_balance) AS unique_outstanding_balances,
    ROUND(MIN(outstanding_balance / credit_limit * 100), 2)
        AS minimum_utilisation,
    ROUND(AVG(outstanding_balance / credit_limit * 100), 2)
        AS average_utilisation,
    ROUND(MAX(outstanding_balance / credit_limit * 100), 2)
        AS maximum_utilisation
FROM credit_accounts;
