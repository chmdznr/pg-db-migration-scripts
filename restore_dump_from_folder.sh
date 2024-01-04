#!/bin/bash

# Define your database details
DATABASE_NAME="sp2kp_v1"
USERNAME="sp2kp"
HOST="localhost"
PORT="5432"

# Specify the directory where your dump files are located
DUMP_DIR="/data/bak"

# Check if dump directory exists
if [ ! -d "$DUMP_DIR" ]; then
    echo "Dump directory does not exist: $DUMP_DIR"
    exit 1
fi

# Iterate over each .dump file in the directory and restore it
for dumpfile in "$DUMP_DIR"/*.dump; do
    table=$(basename "$dumpfile" .dump)
    echo "Restoring table $table from $dumpfile to the public schema in $DATABASE_NAME"
    pg_restore -U "$USERNAME" -h "$HOST" -p "$PORT" \
        --dbname="$DATABASE_NAME" --schema="public" --table="$table" "$dumpfile" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4
done

echo "All tables have been restored to the public schema in $DATABASE_NAME"
