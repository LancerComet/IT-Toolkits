#!/bin/bash

# This script reads all .sql files in the current directory, groups them by their last modified month,
# compresses them into a zip archive named based on the month (e.g., 202407.zip for July 2024),
# and then deletes the original .sql files. If zipinfo is installed and a file with the same name already
# exists in the zip file, it renames the new file to avoid overwriting.

# Check if there are any .sql files in the current directory
shopt -s nullglob
sql_files=(*.sql)

if [ ${#sql_files[@]} -eq 0 ]; then
    echo "No .sql files found in the current directory."
    exit 0
fi

# Check if zipinfo is installed
if command -v zipinfo >/dev/null 2>&1; then
    zipinfo_available=true
else
    zipinfo_available=false
fi

# Loop through all .sql files in the current directory
for file in "${sql_files[@]}"; do
    # Get the last modified time of the file and extract the year and month (format: YYYYMM)
    file_date=$(date -r "$file" +"%Y%m")

    # Define the zip file name based on the extracted date
    zip_name="${file_date}.zip"

    # If zipinfo is available, check for duplicate file names in the zip
    if [ "$zipinfo_available" = true ]; then
        if zipinfo -1 "$zip_name" | grep -q "^${file}$"; then
            # Find a unique file name by appending a count to the original name
            count=1
            while zipinfo -1 "$zip_name" | grep -q "^${file%.sql}_$count.sql$"; do
                count=$((count + 1))
            done
            mv "$file" "${file%.sql}_$count.sql"
            file="${file%.sql}_$count.sql"
        fi
    fi

    # Compress the file into the zip archive and remove the original .sql file
    zip -rm "$zip_name" "$file"
done
