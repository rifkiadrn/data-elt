CREATE USER airbyte_sourcer PASSWORD 'airbyte123';
GRANT CONNECT ON DATABASE "data-elt" TO airbyte_sourcer;
GRANT USAGE ON SCHEMA data_elt,public TO airbyte_sourcer;
GRANT SELECT ON ALL TABLES IN SCHEMA data_elt,public TO airbyte_sourcer;
ALTER DEFAULT PRIVILEGES IN SCHEMA data_elt,public GRANT SELECT ON TABLES TO airbyte_sourcer;


create schema dw_raw;
GRANT CREATE,USAGE ON SCHEMA dw_raw TO airbyte_sourcer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA dw_raw TO airbyte_sourcer;
ALTER DEFAULT PRIVILEGES IN SCHEMA dw_raw GRANT INSERT, UPDATE, DELETE, SELECT ON TABLES TO airbyte_sourcer;