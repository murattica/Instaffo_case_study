{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='hire_date',
        alias='revenue_per_hire',
        tags=['roas_metrics_staging', 'revenue']
    )
}}
SELECT
    a.application_id,
    c.candidate_id,
    c.candidate_created_date,
    c.channel,
    c.campaign,
    a.application_created_date,
    DATE_TRUNC('day', a.stage_updated_at) AS hire_date,
    DATE_TRUNC('month', a.stage_updated_at) AS hire_yyyymm,
    DATE_PART('month', hire_yyyymm) - DATE_PART('month', DATE_TRUNC('month', candidate_created_date)) hired_after_months
    j.negotiated_salary * j.commission_rate AS revenue
FROM {{ ref('fact_application_logs') }} a
LEFT JOIN {{ ref('dim_jobs') }} j
    ON a.job_fk = j.job_id
LEFT JOIN {{ ref('dim_candidates') }} c
    ON a.candidate_fk = c.candidate_id
WHERE a.application_stage = 'hired'
  AND DATE_TRUNC('day', a.stage_updated_at) >= current_date - 1
