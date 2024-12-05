SELECT
    channel,
    campaign,
    DATE_TRUNC('month', DATE(created_at)) AS month,
    SUM(spend) AS total_spend
FROM fact_campaign_spend
GROUP BY channel, campaign, month
