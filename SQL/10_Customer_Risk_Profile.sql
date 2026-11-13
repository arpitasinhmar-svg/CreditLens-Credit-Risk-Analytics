WITH customer_metrics AS (
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
            ca.outstanding_balance / ca.credit_limit * 100,
            2
        ) AS utilisation_percentage,

        MAX(r.days_past_due) AS maximum_dpd,

        COUNT(*) FILTER (
            WHERE r.days_past_due > 30
        ) AS delayed_payments

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
        ca.credit_limit,
        ca.outstanding_balance
)

SELECT
    *,

    CASE
        WHEN maximum_dpd > 60
             AND utilisation_percentage > 80
            THEN 'HIGH RISK'

        WHEN maximum_dpd > 30
             OR utilisation_percentage > 80
            THEN 'MODERATE RISK'

        ELSE 'LOWER RISK'
    END AS risk_category

FROM customer_metrics

ORDER BY
    maximum_dpd DESC,
    utilisation_percentage DESC;
