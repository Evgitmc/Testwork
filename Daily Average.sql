WITH daily_usage AS (
    SELECT
        warehouse_name,
        DATE_TRUNC('day', start_time::date) AS day,
        SUM(credits_used) AS daily_credits
    FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
    WHERE start_time >= DATEADD(MONTH, -4, DATE_TRUNC('day', CURRENT_DATE))
    AND start_time < dateadd('day',-1,date_trunc('day',CURRENT_DATE::date))
     -- AND warehouse_name = 'FINOPS_WH' -- Test
    GROUP BY 1,2
)
SELECT
    warehouse_name,
    DATE_TRUNC('month', day) AS month,
    AVG(daily_credits) AS avg_daily_credits_per_month
FROM daily_usage
GROUP BY warehouse_name, DATE_TRUNC('month', day)
ORDER BY month desc;
