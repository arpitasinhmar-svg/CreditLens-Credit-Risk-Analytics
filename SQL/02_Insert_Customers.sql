INSERT INTO customers (
    customer_id,
    age,
    annual_income,
    employment_status,
    city
)
SELECT
    gs.customer_id,
    FLOOR(21 + RANDOM() * 45)::INT,
    ROUND((250000 + RANDOM() * 1750000)::NUMERIC, 2),
    CASE
        WHEN r < 0.55 THEN 'SALARIED'
        WHEN r < 0.80 THEN 'SELF_EMPLOYED'
        ELSE 'CONTRACT'
    END,
    (ARRAY[
        'Chennai', 'Mumbai', 'Bengaluru', 'Delhi',
        'Hyderabad', 'Pune', 'Kolkata', 'Ahmedabad'
    ])[FLOOR(1 + RANDOM() * 8)::INT]
FROM GENERATE_SERIES(1, 200) AS gs(customer_id)
CROSS JOIN LATERAL (
    SELECT RANDOM() AS r
) AS random_values;

SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(age), 1) AS average_age,
    ROUND(AVG(annual_income), 2) AS average_annual_income
FROM customers;
