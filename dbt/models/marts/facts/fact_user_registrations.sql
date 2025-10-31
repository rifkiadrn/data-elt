-- User registration facts
-- Tracks when users registered

SELECT
    -- Create surrogate key
    ROW_NUMBER() OVER (ORDER BY u.user_id) as registration_key,
    du.user_key,
    DATE(u.created_at) as registration_date,
    u.created_at as registration_timestamp,
    'user_registration' as event_type,
    1 as registration_count,
    current_timestamp as _dbt_loaded_at
FROM {{ ref('stg_users') }} u
LEFT JOIN {{ ref('dim_users') }} du
    ON u.user_id = du.user_id
