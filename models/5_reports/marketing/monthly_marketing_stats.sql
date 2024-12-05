{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='months',
        alias='monthly_marketing_stats',
        tags=['activation_metrics', 'daily','marketing']
    )
}}

SELECT
    ms.channel,
    ms.campaign,
    ms.month,
    ms.total_spend,
    mcs.total_revenue_in_1m,
    mcs.total_revenue_in_2m,
    mcs.total_revenue_in_3m,
    COALESCE(mcs.total_revenue_in_1m / NULLIF(ms.total_spend, 0), 0) AS roas_1m,
    COALESCE(mcs.total_revenue_in_2m / NULLIF(ms.total_spend, 0), 0) AS roas_2m,
    COALESCE(mcs.total_revenue_in_3m / NULLIF(ms.total_spend, 0), 0) AS roas_3m,
    total_hired_in_1m,
    total_hired_in_2m,
    total_hired_in_3m,
    COALESCE(ms.total_spend / NULLIF(SUM(mcs.total_hired_in_1m), 0), 0) AS cost_per_hire_1m,
    COALESCE(ms.total_spend / NULLIF(SUM(mcs.total_hired_in_2m), 0), 0) AS cost_per_hire_2m,
    COALESCE(ms.total_spend / NULLIF(SUM(mcs.total_hired_in_3m), 0), 0) AS cost_per_hire_3m
FROM {{ ref('monthly_spend') }}  ms
LEFT JOIN {{ ref('monthly_hiring_stats') }} mcs
    ON ms.channel = mr.channel
    AND ms.campaign = mr.campaign
    AND ms.month = mr.month;