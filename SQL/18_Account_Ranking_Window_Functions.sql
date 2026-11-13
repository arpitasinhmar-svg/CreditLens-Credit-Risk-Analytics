SELECT
    account_id,
    customer_id,
    outstanding_balance,

    RANK() OVER (
        ORDER BY outstanding_balance DESC
    ) AS balance_rank,

    ROUND(
        AVG(outstanding_balance) OVER (),
        2
    ) AS portfolio_average_outstanding,

    ROUND(
        outstanding_balance -
        AVG(outstanding_balance) OVER (),
        2
    ) AS difference_from_average,

    ROUND(
        SUM(outstanding_balance) OVER (
            ORDER BY outstanding_balance DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_outstanding

FROM credit_accounts

ORDER BY balance_rank

LIMIT 20;
