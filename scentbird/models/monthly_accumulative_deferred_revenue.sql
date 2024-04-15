{{ config(materialized='table') }}

SELECT report_date, SUM(total_amount) OVER (ORDER BY report_date) as total_amount FROM {{ ref("monthly_deferred_revenue") }}
