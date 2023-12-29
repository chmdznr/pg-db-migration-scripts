#!/bin/bash

# Specify the directory where your dump files are located
DUMP_DIR="/data/bak"

# Path to the CSV file with the mappings
MAPPING_CSV="restore_mapping.csv"

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
        --dbname="$database" --schema="$schema" --table="$table" "$dumpfile"

done < "$MAPPING_CSV"

echo "Restoration process completed."
