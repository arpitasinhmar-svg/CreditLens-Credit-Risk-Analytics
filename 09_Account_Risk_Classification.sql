WITH repayment_summary AS (
    SELECT
        account_id,
        MAX(days_past_due) AS maximum_dpd,

        COUNT(*) FILTER (
            WHERE days_past_due > 30
        ) AS delayed_payments,

        ROUND(AVG(days_past_due), 2) AS average_dpd

    FROM repayments
    GROUP BY account_id
),

account_analysis AS (
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
        COALESCE(rs.delayed_payments, 0) AS delayed_payments,
        COALESCE(rs.average_dpd, 0) AS average_dpd

    FROM credit_accounts ca

    LEFT JOIN repayment_summary rs
        ON ca.account_id = rs.account_id
),

risk_classification AS (
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

    FROM account_analysis
)

SELECT
    risk_category,
    COUNT(*) AS account_count,

    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_accounts,

    ROUND(
        SUM(outstanding_balance),
        2
    ) AS total_outstanding,

    ROUND(
        AVG(utilisation_percentage),
        2
    ) AS average_utilisation,

    ROUND(
        AVG(maximum_dpd),
        2
    ) AS average_maximum_dpd

FROM risk_classification

GROUP BY risk_category

ORDER BY
    CASE risk_category
        WHEN 'HIGH RISK' THEN 1
        WHEN 'MODERATE RISK' THEN 2
        ELSE 3
    END;
