#!/bin/bash

# restore table daftar_penandatangans manually
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbuser" --schema="public" --table="daftar_penandatangans" "/data/bak/daftar_penandatangans.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4

# restore table berkas_naskah
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbarsip" --schema="public" --table="berkas_naskah" "/data/bak/berkas_naskah.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4

# restore table berkas_mandiris
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbarsip" --schema="public" --table="berkas_mandiris" "/data/bak/berkas_mandiris.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4

pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbarsip" --schema="public" --table="lampirans" "/data/bak/lampirans.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4

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

# test manual restore dbarsip
pg_restore -U "srikandi" -h "10.46.1.195" -p "5432" --dbname="dbarsip" --schema="naskahdinas" --table="naskah_masuks" "/data/bak/naskah_masuks.dump" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4

# test manual dump dbarsip
pg_dump -U "accesspdn2" -h "localhost" -p "5433" -d "srikandi" -Fc -t naskah_masuks > "/data/bak/naskah_masuks.dump"

# backup sp2kp_v2
pg_dump -U sp2kp -h localhost -p 5432 -d sp2kp_v2 -Fc > sp2kp_v2.dump

# restore sp2kp_v2
pg_restore -U sp2kp -h localhost -p 5432 -d sp2kp_collab -Fc sp2kp_v2.dump
