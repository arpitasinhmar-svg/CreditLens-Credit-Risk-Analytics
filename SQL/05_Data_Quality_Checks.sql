SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,

    (SELECT COUNT(*) FROM credit_accounts) AS total_accounts,

    (SELECT COUNT(*) FROM repayments) AS total_repayments,

    (SELECT COUNT(*)
     FROM credit_accounts ca
     LEFT JOIN customers c
     ON ca.customer_id = c.customer_id
     WHERE c.customer_id IS NULL) AS orphan_accounts,

    (SELECT COUNT(*)
     FROM repayments r
     LEFT JOIN credit_accounts ca
     ON r.account_id = ca.account_id
     WHERE ca.account_id IS NULL) AS orphan_repayments,

    (SELECT COUNT(*)
     FROM credit_accounts
     WHERE outstanding_balance > credit_limit) AS accounts_over_limit;
