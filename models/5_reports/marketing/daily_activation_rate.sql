{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='cohort_date',
        alias='daily_activation_rate',
        tags=['activation_metrics', 'daily','marketing']
    )
}}


WITH attracted_job_seekers AS 
(
    SELECT
        channel,
        campaign,
        candidate_created_date,
        COUNT(DISTINCT candidate_id) AS attracted_job_seekers
    FROM {{ ref('dim_candidates') }}  
    WHERE candidate_created_date =  CURRENT_DATE - 4
    GROUP BY 
        channel, 
        campaign, 
        application_date
),

active_job_seekers AS 
(
    SELECT
        channel,
        campaign,
        candidate_created_date,
        COUNT(DISTINCT CASE WHEN DATEDIFF(day, candidate_created_date, activity_date) < 3 then candidate_id) AS active_job_seekers
    FROM {{ ref('candidate_activity') }} 
    WHERE applications_submitted >0
        and  candidate_created_date >=  CURRENT_DATE - 4
    GROUP BY 
        channel,
        campaign, 
        activity_date
)
SELECT
    ajs.channel,
    ajs.campaign,
    ajs.candidate_created_date as cohort_date,
    ajs.attracted_job_seekers,
    COALESCE(ajs.active_job_seekers, 0) AS active_job_seekers,
    COALESCE(CAST(active_job_seekers AS FLOAT) / NULLIF(attracted_job_seekers, 0), 0) AS activation_rate
FROM attracted_job_seekers ajs
LEFT JOIN active_job_seekers acjs
    ON ajs.channel = acjs.channel
    AND ajs.campaign = acjs.campaign
    AND ajs.candidate_created_date = acjs.candidate_created_date
