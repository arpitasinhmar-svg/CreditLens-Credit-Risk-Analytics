SELECT
    c.city,

    COUNT(DISTINCT c.customer_id) AS total_customers,

    ROUND(
        SUM(ca.credit_limit),
        2
    ) AS total_credit_exposure,

    ROUND(
        SUM(ca.outstanding_balance),
        2
    ) AS total_outstanding,

    ROUND(
        SUM(ca.outstanding_balance) /
        NULLIF(SUM(ca.credit_limit), 0) * 100,
        2
    ) AS portfolio_utilisation,

    ROUND(
        AVG(r.days_past_due),
        2
    ) AS average_dpd,

    COUNT(*) FILTER (
        WHERE r.days_past_due > 30
    ) AS delayed_repayments

FROM customers c

JOIN credit_accounts ca
    ON c.customer_id = ca.customer_id

JOIN repayments r
    ON ca.account_id = r.account_id

GROUP BY c.city

ORDER BY average_dpd DESC;
