-- create new users
CREATE USER srikandi WITH LOGIN PASSWORD 'Srikandi.PROD';
ALTER USER srikandi CREATEDB CREATEROLE;

-- list all roles
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin FROM pg_roles;

-- list all schemas in current database
SELECT nspname FROM pg_namespace WHERE nspname NOT IN ('pg_catalog', 'information_schema') AND nspname NOT LIKE 'pg_toast%';

-- assign user as superuser
ALTER USER srikandi WITH SUPERUSER;

-- logging status
SHOW log_destination;
SHOW logging_collector;
SHOW log_directory;
SHOW log_filename;
SHOW log_min_messages;
SHOW log_min_error_statement;
SHOW log_min_duration_statement;
SHOW log_min_duration_sample;

-- check table size in current database
SELECT 
  table_schema || '.' || table_name AS "full_table_name",
  pg_size_pretty(pg_total_relation_size('"' || table_schema || '"."' || table_name || '"')) AS "size"
FROM 
  information_schema.tables
WHERE 
  table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY 
  pg_total_relation_size('"' || table_schema || '"."' || table_name || '"') DESC;

-- check constraint of a TABLE
SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid = 'user_roles'::regclass AND contype = 'c';

-- copy model_has_roles to user_roles
insert into user_roles(user_id, role_id, is_default, is_active, created_at, updated_at) select model_id as user_id, role_id as role_id, 'Y', 'Y', now(), now() from model_has_roles;

-- disable all triggers
ALTER TABLE table_name DISABLE TRIGGER ALL;
-- enable all triggers
ALTER TABLE table_name ENABLE TRIGGER ALL;

-- show max connection
SHOW max_connections;

-- add file_ttd column with type character varying to table daftar_penandatangans 
ALTER TABLE daftar_penandatangans ADD COLUMN file_ttd character varying;
-- update filename field with file_ttd field
update daftar_penandatangans set filename=file_ttd where 1=1;

-- check table row count for current database
SELECT 
  schemaname, 
  relname AS tablename, 
  n_live_tup AS rowcount 
FROM 
  pg_stat_all_tables 
WHERE
  schemaname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
ORDER BY 
  n_live_tup DESC;

-- list SCHEMA inside current database
SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT LIKE 'pg_%' AND schema_name != 'information_schema';

-- copy table structure from other schema to `public`
DO $$
DECLARE
    row record;
BEGIN
    FOR row IN SELECT table_schema, table_name
               FROM information_schema.tables
               WHERE table_schema NOT IN ('public', 'pg_catalog', 'information_schema', 'pg_toast')
               AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE 'CREATE TABLE public.' || quote_ident(row.table_name) || ' (LIKE ' || quote_ident(row.table_schema) || '.' || quote_ident(row.table_name) || ' INCLUDING ALL)';
    END LOOP;
END $$;

-- delete all tables from other SCHEMA
DO $$
DECLARE
    row record;
BEGIN
    FOR row IN SELECT table_schema, table_name
               FROM information_schema.tables
               WHERE table_schema NOT IN ('public', 'pg_catalog', 'information_schema', 'pg_toast')
               AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(row.table_schema) || '.' || quote_ident(row.table_name) || ' CASCADE';
    END LOOP;
END $$;
