#!/bin/bash

# PostgreSQL server details
SERVER_HOST="pg-01-bimtek"
SERVER_PORT="5432"
USERNAME="srikandi"

# Directory to save the schema dumps
DUMP_DIR="/data/copy_bimtek"
mkdir -p "$DUMP_DIR"

# Get a list of all databases
databases=$(psql -h "$SERVER_HOST" -p "$SERVER_PORT" -U "$USERNAME" -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

# Dump schema of each database
for db in $databases; do
    echo "Dumping schema of database: $db"
    pg_dump -h "$SERVER_HOST" -p "$SERVER_PORT" -U "$USERNAME" --schema-only -f "$DUMP_DIR/$db-schema.sql" "$db"
done

echo "All schemas have been dumped to $DUMP_DIR"
