#!/bin/bash

# Define your database details
DATABASE_NAME="srikandi"
USERNAME="accesspdn2"
HOST="localhost"
PORT="5433"

# Optional: Specify a directory to save the dump files
DUMP_DIR="/data/bak"
mkdir -p "$DUMP_DIR"

# Get the list of tables
tables=$(psql -U "$USERNAME" -h "$HOST" -p "$PORT" -d "$DATABASE_NAME" -t -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';")

# Iterate over each table and dump it
for table in $tables; do
    echo "Dumping $table"
    pg_dump -U "$USERNAME" -h "$HOST" -p "$PORT" -d "$DATABASE_NAME" -Fc -t $table > "$DUMP_DIR/$table.dump"
done

echo "All tables have been dumped to $DUMP_DIR"
