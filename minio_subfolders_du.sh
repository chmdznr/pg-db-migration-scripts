#!/bin/bash

# Replace these with appropriate values
MINIO_ALIAS="myminio"
TARGET_FOLDER="mybucket/myfolder"

# Check if mc is installed
if ! command -v mc &> /dev/null
then
    echo "mc could not be found. Please install MinIO Client."
    exit 1
fi

# Iterating over each subfolder and displaying disk usage
mc ls "${MINIO_ALIAS}/${TARGET_FOLDER}" | while read -r line; do
    FOLDER=$(echo "$line" | awk '{print $5}')  # Extracting folder name
    if [[ $FOLDER ]]; then
        echo "Disk Usage for $FOLDER:"
        mc du "${MINIO_ALIAS}/${TARGET_FOLDER}/${FOLDER}"
        echo ""
    fi
done
