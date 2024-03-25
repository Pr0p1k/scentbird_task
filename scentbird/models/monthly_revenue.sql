{{ config(materialized='table') }}

WITH monthly_orders AS (
    SELECT id, user_id, amount, date_part('month', created_at) AS creation_month, date_part('year', created_at) AS creation_year, shipped_at FROM {{ source('public_exercises', 'orders') }}
)
SELECT creation_month || '/' || creation_year AS report_date, SUM(amount) AS total_amount FROM monthly_orders GROUP BY creation_year, creation_month ORDER BY creation_year, creation_month ASC