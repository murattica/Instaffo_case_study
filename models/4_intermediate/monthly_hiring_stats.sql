{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='months',
        alias='monthly_cohorted_stats',
        tags=['cph_metrics', 'monthly','marketing']
    )
}}

SELECT
    channel,
    campaign,
    DATE_TRUNC('month', candidate_created_date) AS month,
    COUNT(case when hired_after_months <= 1 then application_id end) AS total_hired_in_1m,
    COUNT(case when hired_after_months <= 2 then application_id end) AS total_hired_in_2m,
    COUNT(case when hired_after_months <= 3 then application_id end) AS total_hired_in_3m,
    SUM(case when hired_after_months <= 1 then r.revenue end) AS total_revenue_in_1m,
    SUM(case when hired_after_months <= 2 then r.revenue end) AS total_revenue_in_2m,
    SUM(case when hired_after_months <= 3 then r.revenue end) AS total_revenue_in_3m
FROM {{ ref('hiring_info') }} 
where DATE_TRUNC('month', a.candidate_created_date) >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '3 months')
GROUP BY 
    channel, 
    campaign,
    month