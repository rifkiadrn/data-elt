-- User dimension
-- Creates a slowly changing dimension for users

WITH user_data AS (
    SELECT
        user_id,
        username,
        name as full_name,
        created_at,
        updated_at,
        -- Determine if user is active (example logic)
        CASE
            WHEN updated_at > current_timestamp - interval '30 days' THEN true
            ELSE false
        END as is_active,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY updated_at DESC) as rn
    FROM {{ ref('stg_users') }}
)

SELECT
    -- Create surrogate key
    ROW_NUMBER() OVER (ORDER BY user_id) as user_key,
    user_id,
    username,
    full_name,
    DATE(created_at) as created_date,
    is_active,
    created_at as effective_from,
    NULL as effective_to,  -- SCD Type 2 logic can be added later
    current_timestamp as _dbt_loaded_at
FROM user_data
WHERE rn = 1  -- Get latest version of each user
