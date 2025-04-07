#!/bin/bash

# Function to clean a directory if it contains .asm files
clean_directory() {
    local dir="$1"
    # Check if directory contains any .asm files
    if ls "$dir"/*.asm >/dev/null 2>&1; then
        echo "Found .asm files in $dir - cleaning..."
        # List files that will be deleted
        echo "The following files will be deleted:"
        find "$dir" -type f ! -name "*.asm" ! -name "*.md" ! -name "*.txt" -exec echo {} \;
        
        # Ask for confirmation
        read -p "Do you want to proceed? (y/n) " -n 1 -r
        echo    # Move to a new line
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            find "$dir" -type f ! -name "*.asm" ! -name "*.md" ! -name "*.txt" -exec rm {} \;
            echo "Files deleted in $dir"
        else
            echo "Skipping cleanup in $dir"
        fi
    else
        echo "No .asm files in $dir - skipping..."
    fi
}

# Process current directory
# clean_directory "."

# Or if you want to process multiple directories:
for dir in */; do
    if [ -d "$dir" ]; then
        clean_directory "$dir"
    fi
done