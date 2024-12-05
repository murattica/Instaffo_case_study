{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='activity_date',
        alias='candidate_activity',
        tags=['activation_metrics', 'daily']
    )
}}

SELECT
    a.candidate_fk AS candidate_id,
    a.candidate_created_date,
    c.channel,
    c.campaign,
    DATE(stage_updated_at) AS activity_date,
    COUNT(DISTINCT CASE WHEN action_type = 'applied' THEN application_id END) AS applications_submitted
FROM {{ ref('fact_application_logs') }} a
LEFT JOIN {{ ref('dim_candidates') }} c
    ON a.candidate_fk = c.user_id
WHERE DATE(stage_updated_at) = CURRENT_DATE - 1
GROUP BY 
    a.candidate_fk, 
    c.channel, 
    c.campaign
