SELECT
    c.customer_id,
    c.age,
    c.annual_income,
    c.employment_status,
    c.city,

    ca.account_id,
    ca.outstanding_balance,

    COUNT(*) FILTER (
        WHERE r.days_past_due > 30
    ) AS payments_over_30_dpd,

    COUNT(*) FILTER (
        WHERE r.days_past_due > 60
    ) AS payments_over_60_dpd,

    MAX(r.days_past_due) AS maximum_dpd,

    ROUND(AVG(r.days_past_due), 2) AS average_dpd

FROM customers c

JOIN credit_accounts ca
    ON c.customer_id = ca.customer_id

JOIN repayments r
    ON ca.account_id = r.account_id

GROUP BY
    c.customer_id,
    c.age,
    c.annual_income,
    c.employment_status,
    c.city,
    ca.account_id,
    ca.outstanding_balance

HAVING COUNT(*) FILTER (
    WHERE r.days_past_due > 30
) >= 2

ORDER BY
    payments_over_30_dpd DESC,
    maximum_dpd DESC;
