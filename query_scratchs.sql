-- create new users
CREATE USER srikandi WITH LOGIN PASSWORD 'Srikandi.PROD';
ALTER USER srikandi CREATEDB CREATEROLE;

-- list all roles
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin FROM pg_roles;
