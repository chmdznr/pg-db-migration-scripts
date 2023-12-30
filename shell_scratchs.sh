#!/bin/bash

# restore table daftar_penandatangans manually
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbuser" --schema="public" --table="daftar_penandatangans" "/data/bak/daftar_penandatangans.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4

# dump table from bimtek manually
pg_dump -U "srikandi" -h "pg-01-bimtek" -p "5432" -d "dbuser" -Fc -t grup_tembusans > "/data/bak/grup_tembusans.dump"
pg_dump -U "srikandi" -h "pg-01-bimtek" -p "5432" -d "dbuser" -Fc -t daftar_tembusans > "/data/bak/daftar_tembusans.dump"
pg_dump -U "srikandi" -h "pg-01-bimtek" -p "5432" -d "dbuser" -Fc -t group_role > "/data/bak/group_role.dump"
pg_dump -U "srikandi" -h "pg-01-bimtek" -p "5432" -d "dbuser" -Fc -t menus > "/data/bak/menus.dump"
pg_dump -U "srikandi" -h "pg-01-bimtek" -p "5432" -d "dbuser" -Fc -t role_menu > "/data/bak/role_menu.dump"

# restore manually the tables from bimtek to dbuser
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbuser" --schema="public" --table="grup_tembusans" "/data/bak/grup_tembusans.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbuser" --schema="public" --table="daftar_tembusans" "/data/bak/daftar_tembusans.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbuser" --schema="public" --table="group_role" "/data/bak/group_role.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbuser" --schema="public" --table="menus" "/data/bak/menus.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbuser" --schema="public" --table="role_menu" "/data/bak/role_menu.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4
