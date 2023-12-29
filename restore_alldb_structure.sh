#!/bin/bash

# New server details
NEW_SERVER_HOST="10.46.1.195"
USERNAME="srikandi"
DUMP_DIR="/data/copy_bimtek"

# Loop through each schema dump file and restore it
for dumpfile in "$DUMP_DIR"/*.sql; do
    dbname=$(basename "$dumpfile" -schema.sql)
    echo "Restoring schema for database: $dbname"

    # Create the database (if not already created)
    psql -U "$USERNAME" -h "$NEW_SERVER_HOST" -c "CREATE DATABASE $dbname;"

    # Restore the schema
    psql -U "$USERNAME" -h "$NEW_SERVER_HOST" -d "$dbname" < "$dumpfile"
done

echo "Schema restoration process completed."
