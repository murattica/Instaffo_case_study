SELECT 
    candidate_id,
    candidate_name,
    candidate_email,
    company_fk,
    candidate_last_active_at,
    candidate_last_active_date,
    candidate_created_at,
    candidate_created_date,
    user_role AS candidate_role,
    user_gender AS candidate_gender,
    user_language AS candidate_language,
    country_fk,
    channel,
    campaign
FROM dim_candidates