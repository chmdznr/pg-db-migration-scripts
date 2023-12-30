#!/bin/bash

# Specify the directory where your dump files are located
DUMP_DIR="/data/bak"

# Default CSV file
DEFAULT_MAPPING_CSV="restore_mapping.csv"

# Use the first command line argument as the CSV file path, default to DEFAULT_MAPPING_CSV if not provided
MAPPING_CSV="${1:-$DEFAULT_MAPPING_CSV}"

# Define your PostgreSQL server details
USERNAME="srikandi"
HOST="10.46.1.195"
PORT="5432"

# Read the CSV file line by line and perform the restoration
while IFS=';' read -r table database target_schema; do
    # Skip the header line
    if [ "$table" = "table_name" ]; then
        continue
    fi

    # Define the dump file path
    dumpfile="$DUMP_DIR/$table.dump"

    # Check if the dump file exists
    if [ ! -f "$dumpfile" ]; then
        echo "Dump file for table $table not found. Skipping..."
        continue
    fi

    echo "Restoring table $table to database $database in public schema"

    # Restore the table to the public schema
    pg_restore -U "$USERNAME" -h "$HOST" -p "$PORT" \
        --dbname="$database" --schema="public" --table="$table" "$dumpfile" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4

    # Check if the target schema is not 'public' and then alter the schema of the table
    if [ "$target_schema" != "public" ]; then
        echo "Altering schema of table $table to $target_schema"
        psql -U "$USERNAME" -h "$HOST" -p "$PORT" -d "$database" -c \
            "ALTER TABLE public.$table SET SCHEMA $target_schema;"
    else
        echo "Target schema for table $table is already public, skipping schema alteration"
    fi

done < "$MAPPING_CSV"

echo "Restoration process completed."
