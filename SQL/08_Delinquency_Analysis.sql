SELECT
    CASE
        WHEN days_past_due = 0 THEN 'CURRENT'
        WHEN days_past_due BETWEEN 1 AND 30 THEN '1-30 DPD'
        WHEN days_past_due BETWEEN 31 AND 60 THEN '31-60 DPD'
        ELSE '60+ DPD'
    END AS delinquency_category,

    COUNT(*) AS repayment_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM repayments),
        2
    ) AS percentage_of_repayments,

    ROUND(SUM(amount_due), 2) AS total_amount_due,

    ROUND(SUM(amount_paid), 2) AS total_amount_paid

FROM repayments

GROUP BY 1

ORDER BY
    CASE
        WHEN delinquency_category = 'CURRENT' THEN 1
        WHEN delinquency_category = '1-30 DPD' THEN 2
        WHEN delinquency_category = '31-60 DPD' THEN 3
        ELSE 4
    END;
