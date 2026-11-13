WITH repayment_summary AS (
    SELECT
        account_id,
        MAX(days_past_due) AS maximum_dpd,
        COUNT(*) FILTER (
            WHERE days_past_due > 30
        ) AS delayed_payments
    FROM repayments
    GROUP BY account_id
),

account_risk AS (
    SELECT
        ca.account_id,
        ca.customer_id,
        ca.credit_limit,
        ca.outstanding_balance,

        ROUND(
            ca.outstanding_balance / ca.credit_limit * 100,
            2
        ) AS utilisation_percentage,

        COALESCE(rs.maximum_dpd, 0) AS maximum_dpd,
        COALESCE(rs.delayed_payments, 0) AS delayed_payments

    FROM credit_accounts ca
    LEFT JOIN repayment_summary rs
        ON ca.account_id = rs.account_id
)

SELECT
    *,
    CASE
        WHEN maximum_dpd > 60 THEN 'HIGH RISK'
        WHEN maximum_dpd > 30 THEN 'MODERATE RISK'
        ELSE 'LOWER RISK'
    END AS risk_category

FROM account_risk

WHERE maximum_dpd > 30

ORDER BY
    maximum_dpd DESC,
    outstanding_balance DESC

LIMIT 20;
