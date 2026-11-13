SELECT
    DATE_TRUNC('month', payment_date)::DATE AS repayment_month,

    COUNT(*) AS total_repayments,

    ROUND(SUM(amount_due), 2) AS total_amount_due,

    ROUND(SUM(amount_paid), 2) AS total_amount_paid,

    ROUND(
        SUM(amount_paid) /
        NULLIF(SUM(amount_due), 0) * 100,
        2
    ) AS collection_rate,

    ROUND(AVG(days_past_due), 2) AS average_dpd,

    COUNT(*) FILTER (
        WHERE days_past_due > 30
    ) AS delayed_repayments

FROM repayments

GROUP BY DATE_TRUNC('month', payment_date)

ORDER BY repayment_month;
