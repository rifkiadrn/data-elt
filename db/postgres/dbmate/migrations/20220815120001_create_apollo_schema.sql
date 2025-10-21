-- migrate:up
SET LOCAL lock_timeout = '60s';
CREATE SCHEMA IF NOT EXISTS "data-elt";

-- migrate:down
SET LOCAL lock_timeout = '60s';
DROP SCHEMA IF EXISTS "data-elt";