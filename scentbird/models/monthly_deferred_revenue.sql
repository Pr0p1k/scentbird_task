{{ config(materialized='table') }}

WITH nullified_amounts AS (
SELECT
    id,
    user_id,
    -- add zero values for those orders which were not shipped, otherwise select with where created_at is null will not give the filtered rows
    CASE WHEN shipped_at IS NULL THEN amount ELSE 0 END AS amount,
    created_at,
    shipped_at
FROM {{ source('public_exercises', 'orders') }})
SELECT
    date_part('month', created_at)  || '/' || date_part('year', created_at) AS report_date,
    SUM(amount) AS total_amount
FROM nullified_amounts
    GROUP BY date_part('year', created_at), date_part('month', created_at)
