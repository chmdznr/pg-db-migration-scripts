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

SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid = 'lampirans'::regclass AND contype = 'c';

ALTER TABLE lampirans DROP CONSTRAINT lampirans_naskah_check;

--        conname         |                                              pg_get_constraintdef
------------------------+-----------------------------------------------------------------------------------------------------------------
 --lampirans_naskah_check | CHECK (((naskah)::text = ANY (ARRAY[('KELUAR'::character varying)::text, ('MASUK'::character varying)::text])))

-- fix constraint
ALTER TABLE lampirans ADD CONSTRAINT lampirans_naskah_check CHECK (((naskah)::text = ANY (ARRAY[('KELUAR'::character varying)::text, ('MASUK'::character varying)::text, ('MANDIRI'::character varying)::text])));

alter table lampirans set schema naskahdinas;


-- copy model_has_roles to user_roles
insert into user_roles(user_id, role_id, is_default, is_active, created_at, updated_at) select model_id as user_id, role_id as role_id, 'Y', 'Y', now(), now() from model_has_roles;
-- update user_roles from users
UPDATE user_roles
SET 
    organisasi_id = users.organisasi_id,
    send_outside = users.send_outside,
    updated_at = now()
FROM users
WHERE user_roles.user_id = users.id;


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

-- add fields to table berkas_naskah 
--organisasi_id	bigint
ALTER TABLE berkas_naskah ADD COLUMN organisasi_id bigint;
--public_organisasi_id	bigint
ALTER TABLE berkas_naskah ADD COLUMN public_organisasi_id bigint;
-- then continue restore manually
-- then change SCHEMA
alter table berkas_naskah set schema berkas;

-- add fields to table berkas_mandiris
--unit_pengolah	character varying
ALTER TABLE berkas_mandiris ADD COLUMN unit_pengolah character varying;
--tahun_musnah_serah	character varying
ALTER TABLE berkas_mandiris ADD COLUMN tahun_musnah_serah character varying;
--kurun_waktu_manual	character varying
ALTER TABLE berkas_mandiris ADD COLUMN kurun_waktu_manual character varying;
--jumlah_arsip	character varying
ALTER TABLE berkas_mandiris ADD COLUMN jumlah_arsip character varying;
-- then continue restore manually
-- then change SCHEMA
alter table berkas_mandiris set schema berkas;


alter table jobs set schema naskahdinas;
alter table failed_jobs set schema naskahdinas;
alter table version_naskahs set schema naskahdinas;

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


-- create readonly user
CREATE USER anri_ro WITH PASSWORD 'very.secure.passwd';

GRANT CONNECT ON DATABASE dbuser TO anri_ro;
GRANT CONNECT ON DATABASE dbmaster TO anri_ro;
GRANT CONNECT ON DATABASE dbarsip TO anri_ro;
-- loop on all database
\c dbuser

DO $$
DECLARE
    sch text;
BEGIN
    FOR sch IN SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT LIKE 'pg_%' AND schema_name != 'information_schema'
    LOOP
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO anri_ro', sch);
        EXECUTE format('GRANT SELECT ON ALL TABLES IN SCHEMA %I TO anri_ro', sch);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT ON TABLES TO anri_ro', sch);
    END LOOP;
END
$$;


-- example join using dblink
SELECT
    nk.*,
    dbjn.id,
    dbjn.jenis_naskah
FROM
    naskahdinas.naskah_keluars nk
    LEFT JOIN (
        SELECT *
        FROM
            dblink(
                'dbname=dbmaster',
                'SELECT id, jenis_naskah FROM jenis_naskahs'
            ) AS jn(id bigint, jenis_naskah varchar)
    ) as dbjn on dbjn.id = nk.jenis_naskah_id
where
    nk.organisasi_created_id = '912'
order by nk.id desc
limit 10;

-- selamatkan tabel grup_tembusans, daftar_tembusans, group_role, menus, role_menu dari dbuser ke public
alter table grup_tembusans set schema public;
alter table daftar_tembusans set schema public;
alter table group_role set schema public;
alter table menus set schema public;
alter table role_menu set schema public;

-- truncate all tables except grup_tembusans, daftar_tembusans, group_role, menus, role_menu
DO $$
DECLARE
    row record;
BEGIN
    FOR row IN SELECT table_schema, table_name
               FROM information_schema.tables
               WHERE table_schema NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
               AND table_type = 'BASE TABLE'
               AND table_name NOT IN ('grup_tembusans', 'daftar_tembusans', 'group_role', 'menus', 'role_menu')
    LOOP
        EXECUTE 'TRUNCATE TABLE ' || quote_ident(row.table_schema) || '.' || quote_ident(row.table_name) || ' CASCADE';
    END LOOP;
END $$;


-- drop all tables that has name started with 'tmp_'
DO $$
DECLARE
    row record;
BEGIN
    FOR row IN SELECT table_schema, table_name
               FROM information_schema.tables
               WHERE table_schema NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
               AND table_type = 'BASE TABLE'
               AND table_name LIKE 'tmp_%'
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(row.table_schema) || '.' || quote_ident(row.table_name) || ' CASCADE';
    END LOOP;
END $$;

-- truncate all tables in the current schema
DO $$
DECLARE
    row record;
BEGIN
    FOR row IN SELECT table_schema, table_name
               FROM information_schema.tables
               WHERE table_schema NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
               AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE 'TRUNCATE TABLE ' || quote_ident(row.table_schema) || '.' || quote_ident(row.table_name) || ' CASCADE';
    END LOOP;
END $$;


-- change DATABASE owner
alter database sp2kp_collab owner to sp2kp;

-- truncate cascade table
truncate table master_ref.komoditas cascade;
truncate table audit.audit_trail cascade;

-- copy content using dblink
-- Disable foreign key checks
ALTER TABLE bispro.harga_harian DISABLE TRIGGER ALL;

-- Copy data from source to target using dblink
INSERT INTO bispro.harga_harian
    (kode_provinsi, kode_kab_kota, sumber_data_id, satuan_id, satuan_str, kuantitas, harga, pasar_id, tanggal, deskripsi, catatan, is_active, created_at, created_by, updated_at, updated_by, variant_id, komoditas_id, status_verifikasi_1, verifikasi_1_by, verifikasi_1_at, status_verifikasi_2, verifikasi_2_by, verifikasi_2_at, is_closed, penyebab_id, keterangan_verifikasi_1, keterangan_verifikasi_2, status_verifikasi_3, verifikasi_3_by, verifikasi_3_at, keterangan_verifikasi_3, produk_id)
SELECT
    'XX' as kode_provinsi,
    id_kabupaten AS kode_kab_kota,
    cast(1 as bigint) AS sumber_data_id,
    0 AS satuan_id,
    id_satuan AS satuan_str,
    kuantitas,
    harga,
    id_pasar AS pasar_id,
    tanggal AS tanggal,
    deskripsi,
    catatan,
    active::int::boolean AS is_active,
    insert_timestamp AS created_at,
    insert_by AS created_by,
    now() AS updated_at,
    lastupdate_by AS updated_by,
    id_variant AS variant_id,
    id_komoditas AS komoditas_id,
    NULL AS status_verifikasi_1,
    NULL AS verifikasi_1_by,
    NULL AS verifikasi_1_at,
    NULL AS status_verifikasi_2,
    NULL AS verifikasi_2_by,
    NULL AS verifikasi_2_at,
    true AS is_closed,
    NULL AS penyebab_id,
    NULL AS keterangan_verifikasi_1,
    NULL AS keterangan_verifikasi_2,
    NULL AS status_verifikasi_3,
    NULL AS verifikasi_3_by,
    NULL AS verifikasi_3_at,
    NULL AS keterangan_verifikasi_3,
    NULL AS produk_id
FROM
    dblink('dbname=sp2kp_v1',  -- Source database connection
            'SELECT id, id_kabupaten, app_id, id_satuan, kuantitas, harga, id_pasar, tanggal_harga, deskripsi, catatan, active, insert_timestamp, insert_by, lastupdate_timestamp, lastupdate_by, id_variant, id_komoditas, day_date FROM public.trans_harga_harian WHERE EXTRACT(YEAR FROM tanggal_harga) = 2023 AND harga > 0::money')  -- Source query
    AS source_data (
        id INT,
        id_kabupaten INT,
        app_id INT,
        id_satuan VARCHAR(20),
        kuantitas INT,
        harga MONEY,
        id_pasar INT,
        tanggal TIMESTAMP,
        deskripsi TEXT,
        catatan TEXT,
        active BIT,
        insert_timestamp TIMESTAMP,
        insert_by INT,
        lastupdate_timestamp TIMESTAMP,
        lastupdate_by INT,
        id_variant INT,
        id_komoditas INT,
        day_date DATE
    );

-- Enable foreign key checks
ALTER TABLE bispro.harga_harian ENABLE TRIGGER ALL;

update bispro.harga_harian set satuan_id=master_ref.satuan.id from master_ref.satuan where bispro.harga_harian.satuan_str=master_ref.satuan.display;

-- list blocked query
select pid,
       usename,
       pg_blocking_pids(pid) as blocked_by,
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0;

-- cancel running query
SELECT pg_cancel_backend(1556541), pg_terminate_backend(1556541);

-- update value based on dblink table
UPDATE bispro.harga_harian
SET kode_kab_kota = v.kode_kemendagri
FROM dblink('dbname=sp2kp_v1', 'SELECT id, kode_kemendagri FROM master_kabupaten') AS v(id INT, kode_kemendagri VARCHAR)
WHERE kode_kab_kota::int = v.id;

UPDATE bispro.harga_harian
SET kode_provinsi = LEFT(kode_kab_kota, 2);
