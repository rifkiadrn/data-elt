-- Staging model for users data
-- This reads from the raw data synced by Airbyte from MinIO

WITH source AS (
    SELECT
        id::uuid as user_id,
        name,
        username,
        -- Convert epoch timestamps to proper timestamps
        to_timestamp(created_at) as created_at,
        to_timestamp(updated_at) as updated_at,
        -- Add metadata
        current_timestamp as _dbt_loaded_at
    FROM {{ source('raw_minio', 'lake') }}  -- Adjust source name based on your Airbyte destination
)

SELECT * FROM source
