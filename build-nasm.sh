#!/bin/bash

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_asm_file>"
    exit 1
fi

# Get the full path of the assembly file
ASM_FILE_FULL_PATH="$1"

# Extract the directory path and filename
DIR_PATH=$(dirname "$ASM_FILE_FULL_PATH")
BASENAME=$(basename "$ASM_FILE_FULL_PATH")
FILENAME="${BASENAME%.*}" # Get filename without extension

# Check if the file exists
if [ ! -f "$ASM_FILE_FULL_PATH" ]; then
    echo "Error: File not found: $ASM_FILE_FULL_PATH"
    exit 1
fi

# Change to the directory containing the assembly file
cd "$DIR_PATH" || exit 1

# Assemble the code using NASM
nasm -f elf "$BASENAME" -o "$FILENAME.o"
if [ $? -ne 0 ]; then
    echo "Error during assembly."
    exit 1
fi

# Link the object file using ld
ld -m elf_i386 "$FILENAME.o" -o "$FILENAME"
if [ $? -ne 0 ]; then
    echo "Error during linking."
    exit 1
fi

# Run the executable
./"$FILENAME"

exit 0
