#!/bin/bash

# Define your database details
DATABASE_NAME="srikandi"
USERNAME="accesspdn2"
HOST="localhost"
PORT="5433"

# Optional: Specify a directory to save the dump files
DUMP_DIR="/data/bak"
mkdir -p "$DUMP_DIR"

# Default CSV file path
DEFAULT_CSV="tables_to_dump.csv"

# Use the first command line argument as the CSV file path, default to DEFAULT_CSV if not provided
CSV_PATH="${1:-$DEFAULT_CSV}"

# Check if the CSV file exists
if [ ! -f "$CSV_PATH" ]; then
    echo "CSV file not found: $CSV_PATH"
    exit 1
fi

# Read each line from the CSV file
while IFS=';' read -r schema_name table_name; do
    # Skip the header line
    if [ "$schema_name" = "schema_name" ]; then
        continue
    fi

    echo "Dumping $schema_name.$table_name"
    pg_dump -U "$USERNAME" -h "$HOST" -p "$PORT" -d "$DATABASE_NAME" -Fc -n "$schema_name" -t "$table_name" > "$DUMP_DIR/${schema_name}_${table_name}.dump"
done < "$CSV_PATH"

echo "All tables have been dumped to $DUMP_DIR"
