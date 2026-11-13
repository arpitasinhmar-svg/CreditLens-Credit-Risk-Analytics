SELECT
    c.employment_status,

    COUNT(DISTINCT c.customer_id) AS total_customers,

    ROUND(
        AVG(c.annual_income),
        2
    ) AS average_annual_income,

    ROUND(
        AVG(ca.outstanding_balance),
        2
    ) AS average_outstanding,

    ROUND(
        AVG(ca.outstanding_balance / ca.credit_limit) * 100,
        2
    ) AS average_utilisation,

    COUNT(DISTINCT ca.account_id) FILTER (
        WHERE EXISTS (
            SELECT 1
            FROM repayments r
            WHERE r.account_id = ca.account_id
              AND r.days_past_due > 30
        )
    ) AS accounts_with_delays,

    ROUND(
        AVG(r.days_past_due),
        2
    ) AS average_days_past_due

FROM customers c

JOIN credit_accounts ca
    ON c.customer_id = ca.customer_id

JOIN repayments r
    ON ca.account_id = r.account_id

GROUP BY c.employment_status

ORDER BY average_days_past_due DESC;
