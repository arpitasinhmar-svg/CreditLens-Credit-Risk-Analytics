INSERT INTO repayments (
    repayment_id,
    account_id,
    payment_date,
    amount_due,
    amount_paid,
    days_past_due
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY ca.account_id, m.month_number
    )::INT,
    ca.account_id,
    (
        DATE '2026-07-05'
        + ((m.month_number - 1) * INTERVAL '1 month')
        + (d.dpd * INTERVAL '1 day')
    )::DATE,
    ROUND(ca.credit_limit * 0.04, 2),
    ROUND(
        ca.credit_limit * 0.04 *
        CASE
            WHEN d.dpd > 60 THEN 0.65
            WHEN d.dpd > 30 THEN 0.80
            ELSE 1.00
        END,
        2
    ),
    d.dpd
FROM credit_accounts ca
CROSS JOIN GENERATE_SERIES(1, 3) AS m(month_number)
CROSS JOIN LATERAL (
    SELECT
        CASE
            WHEN ca.account_id % 10 = 0
                THEN 65 + m.month_number * 3
            WHEN ca.account_id % 10 = 1
                THEN 35 + m.month_number * 2
            WHEN ca.account_id % 10 IN (2, 3)
                THEN 8 + m.month_number
            ELSE 0
        END AS dpd
) AS d;

SELECT
    COUNT(*) AS total_repayments,
    COUNT(DISTINCT account_id) AS accounts_with_repayments,
    MAX(days_past_due) AS maximum_dpd,
    ROUND(AVG(days_past_due), 2) AS average_dpd
FROM repayments;
