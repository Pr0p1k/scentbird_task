{{ config(materialized='table') }}

WITH monthly_orders AS (
    SELECT id, user_id, amount, date_trunc('month', created_at) AS created_at, shipped_at FROM {{ source('public_exercises', 'orders') }}
)
SELECT created_at AS report_date, SUM(amount) AS total_amount FROM monthly_orders GROUP BY created_at ORDER BY created_at ASC