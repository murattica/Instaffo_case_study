SELECT 
    application_id,
    candidate_fk,
    job_fk,
    application_created_day,
    application_created_at,
    action_type,
    stage_updated_at,
    application_stage,
    is_hired
FROM fact_application_logs;