INSERT INTO credit_accounts (
    account_id,
    customer_id,
    credit_limit,
    outstanding_balance,
    account_status
)
SELECT
    1000 + customer_id,
    customer_id,
    credit_limit,
    ROUND(
        (credit_limit * utilisation)::NUMERIC,
        2
    ),
    CASE
        WHEN status_draw < 0.90 THEN 'ACTIVE'
        ELSE 'CLOSED'
    END
FROM customers
CROSS JOIN LATERAL (
    SELECT
        (50000 + FLOOR(RANDOM() * 250001))::NUMERIC AS credit_limit,
        (0.05 + RANDOM() * 0.90) AS utilisation,
        RANDOM() AS status_draw
) AS account_data;

SELECT
    COUNT(*) AS total_accounts,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(AVG(credit_limit), 2) AS average_credit_limit,
    ROUND(AVG(outstanding_balance), 2) AS average_outstanding
FROM credit_accounts;
