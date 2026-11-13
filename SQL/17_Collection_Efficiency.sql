SELECT
    CASE
        WHEN days_past_due = 0 THEN 'CURRENT'
        WHEN days_past_due <= 30 THEN '1-30 DPD'
        WHEN days_past_due <= 60 THEN '31-60 DPD'
        ELSE '60+ DPD'
    END AS delinquency_category,

    COUNT(*) AS repayment_count,

    ROUND(SUM(amount_due), 2) AS total_amount_due,

    ROUND(SUM(amount_paid), 2) AS total_amount_collected,

    ROUND(
        SUM(amount_due - amount_paid),
        2
    ) AS collection_shortfall,

    ROUND(
        SUM(amount_paid) /
        NULLIF(SUM(amount_due), 0) * 100,
        2
    ) AS collection_efficiency_percentage

FROM repayments

GROUP BY 1

ORDER BY
    CASE
        WHEN MIN(days_past_due) = 0
             AND MAX(days_past_due) = 0 THEN 1
        WHEN MIN(days_past_due) BETWEEN 1 AND 30 THEN 2
        WHEN MIN(days_past_due) BETWEEN 31 AND 60 THEN 3
        ELSE 4
    END;
