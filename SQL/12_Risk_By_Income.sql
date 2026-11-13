WITH income_analysis AS (
    SELECT
        c.customer_id,
        c.annual_income,
        ca.account_id,
        ca.credit_limit,
        ca.outstanding_balance,

        ROUND(
            ca.outstanding_balance / ca.credit_limit * 100,
            2
        ) AS utilisation_percentage,

        MAX(r.days_past_due) AS maximum_dpd

    FROM customers c

    JOIN credit_accounts ca
        ON c.customer_id = ca.customer_id

    JOIN repayments r
        ON ca.account_id = r.account_id

    GROUP BY
        c.customer_id,
        c.annual_income,
        ca.account_id,
        ca.credit_limit,
        ca.outstanding_balance
),

income_groups AS (
    SELECT
        *,
        CASE
            WHEN annual_income < 500000 THEN 'Below 5 LPA'
            WHEN annual_income < 1000000 THEN '5-10 LPA'
            WHEN annual_income < 1500000 THEN '10-15 LPA'
            ELSE 'Above 15 LPA'
        END AS income_category
    FROM income_analysis
)

SELECT
    income_category,
    COUNT(*) AS total_customers,

    ROUND(AVG(annual_income), 2) AS average_income,

    ROUND(AVG(outstanding_balance), 2) AS average_outstanding,

    ROUND(AVG(utilisation_percentage), 2) AS average_utilisation,

    ROUND(AVG(maximum_dpd), 2) AS average_maximum_dpd,

    COUNT(*) FILTER (
        WHERE maximum_dpd > 30
    ) AS customers_over_30_dpd

FROM income_groups

GROUP BY income_category

ORDER BY
    CASE income_category
        WHEN 'Below 5 LPA' THEN 1
        WHEN '5-10 LPA' THEN 2
        WHEN '10-15 LPA' THEN 3
        ELSE 4
    END;
