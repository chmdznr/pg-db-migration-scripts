-- create new users
CREATE USER srikandi WITH LOGIN PASSWORD 'Srikandi.PROD';
ALTER USER srikandi CREATEDB CREATEROLE;

-- list all roles
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin FROM pg_roles;

-- list all schemas in current database
SELECT nspname FROM pg_namespace WHERE nspname NOT IN ('pg_catalog', 'information_schema') AND nspname NOT LIKE 'pg_toast%';

-- assign user as superuser
ALTER USER srikandi WITH SUPERUSER;
