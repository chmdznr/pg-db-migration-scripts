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
while IFS=';' read -r table database schema; do
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

    echo "Restoring table $table to database $database, schema $schema"

    # Disable foreign key constraint checking, restore the table, and re-enable checking
    pg_restore -U "$USERNAME" -h "$HOST" -p "$PORT" \
        --dbname="$database" --schema="$schema" --table="$table" "$dumpfile" --disable-triggers --superuser=postgres --data-only --no-owner --jobs=4

done < "$MAPPING_CSV"

echo "Restoration process completed."
