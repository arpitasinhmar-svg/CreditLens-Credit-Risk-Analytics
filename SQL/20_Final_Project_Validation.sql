SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM credit_accounts) AS accounts,
    (SELECT COUNT(*) FROM repayments) AS repayments,

    (SELECT COUNT(*) FROM vw_customer_account_profile)
        AS customer_profiles,

    (SELECT COUNT(*) FROM vw_monthly_repayment_performance)
        AS monthly_records,

    (SELECT COUNT(*) FROM vw_portfolio_overview)
        AS portfolio_summary;
