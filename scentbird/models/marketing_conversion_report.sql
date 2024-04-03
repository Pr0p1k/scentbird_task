{{ config(materialized='table') }}

WITH advertising_events AS (
SELECT
    *
FROM {{ source('public_exercises', 'events') }}
    WHERE event_name='AdvertisingCampaignSet'
),
users_campaigns_amounts AS (
SELECT
    a.user_id,
    a.params,
    SUM(o.amount) as total_amount -- TODO should the deferred value be considered here?
FROM advertising_events a
    JOIN {{ source('public_exercises', 'orders') }} o
        ON a.user_id=o.user_id AND o.created_at BETWEEN a.created_at AND a.created_at + INTERVAL '1 day'
    GROUP BY a.user_id, a.params
)
SELECT params->>'utm_campaign' AS campaign_name, SUM(total_amount) AS total_revenue FROM users_campaigns_amounts GROUP BY params
