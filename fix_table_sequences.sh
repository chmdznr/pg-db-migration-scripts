#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <DB_NAME> <USER> <HOST> <PORT> [INCREMENT]"
    exit 1
fi

# Database Configuration from command line arguments
DBNAME="$1"
USER="$2"
HOST="$3"
PORT="$4"

# Increment value with default
INCREMENT=${5:-1000}

# Connecting to the PostgreSQL Database
psql -U "$USER" -h "$HOST" -d "$DBNAME" -p "$PORT" -c "
DO \$\$
DECLARE
    r RECORD;
    max_id INT;
    current_sequence_val INT;
    new_sequence_val INT;
BEGIN
    FOR r IN SELECT t.table_schema, t.table_name, c.column_default
             FROM information_schema.tables t
             JOIN information_schema.columns c ON c.table_schema = t.table_schema AND c.table_name = t.table_name
             WHERE t.table_schema NOT IN ('pg_catalog', 'information_schema', 'pg_toast') AND t.table_type = 'BASE TABLE' AND c.column_default LIKE 'nextval%'
    LOOP
        EXECUTE format('SELECT MAX(id) FROM %I.%I', r.table_schema, r.table_name) INTO max_id;
        EXECUTE format('SELECT last_value FROM %s', split_part(r.column_default, '''', 2)) INTO current_sequence_val;

        IF max_id IS NOT NULL AND max_id >= current_sequence_val THEN
            new_sequence_val := max_id + $INCREMENT;
            EXECUTE format('SELECT setval(%L, %s, false)', split_part(r.column_default, '''', 2), new_sequence_val);
            RAISE NOTICE 'Sequence ''%'' updated to % for table ''%I.%I''', split_part(r.column_default, '''', 2), new_sequence_val, r.table_schema, r.table_name;
        END IF;
    END LOOP;
END;
\$\$
"
echo "Sequence numbers checked and updated for non-system schemas in database '$DBNAME'."
