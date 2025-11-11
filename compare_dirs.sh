#!/bin/bash

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <path1> <path2>"
    echo "Compares files or directories (both inputs must be the same type)"
    exit 1
fi

# Inputs to compare
INPUT1="$1"
INPUT2="$2"

# Check if inputs exist
if [ ! -e "$INPUT1" ]; then
    echo "Error: $INPUT1 does not exist"
    exit 1
fi

if [ ! -e "$INPUT2" ]; then
    echo "Error: $INPUT2 does not exist"
    exit 1
fi

# Detect input types
IS_FILE1=false
IS_FILE2=false
IS_DIR1=false
IS_DIR2=false

if [ -f "$INPUT1" ]; then
    IS_FILE1=true
elif [ -d "$INPUT1" ]; then
    IS_DIR1=true
fi

if [ -f "$INPUT2" ]; then
    IS_FILE2=true
elif [ -d "$INPUT2" ]; then
    IS_DIR2=true
fi

# Check for mixed types
if ( $IS_FILE1 && $IS_DIR2 ) || ( $IS_DIR1 && $IS_FILE2 ); then
    echo "Error: Cannot compare file with directory"
    echo "  $INPUT1 is a $([ -f "$INPUT1" ] && echo 'file' || echo 'directory')"
    echo "  $INPUT2 is a $([ -f "$INPUT2" ] && echo 'file' || echo 'directory')"
    exit 1
fi

# Generate output filename (replace dots with underscores)
NAME1=$(basename "$INPUT1" | tr '.' '_')
NAME2=$(basename "$INPUT2" | tr '.' '_')
OUTPUT_FILE="${NAME1}_vs_${NAME2}_diff_ignore_formatting.txt"

# Clear or create output file
> "$OUTPUT_FILE"

# Handle file comparison
if $IS_FILE1 && $IS_FILE2; then
    echo "Comparing files:"
    echo "  Source: $INPUT1"
    echo "  Target: $INPUT2"
    echo "Output file: $OUTPUT_FILE"
    echo ""

    # Run diff with options to ignore whitespace and blank lines
    diff -U0 -wB "$INPUT1" "$INPUT2" >> "$OUTPUT_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "IDENTICAL (ignoring whitespace/blank lines)"
    else
        echo "DIFFERENCES FOUND"
    fi

    echo ""
    echo "Comparison complete. Results saved to $OUTPUT_FILE"
    exit 0
fi

# Handle directory comparison
if $IS_DIR1 && $IS_DIR2; then
    DIR1="$INPUT1"
    DIR2="$INPUT2"

    echo "Comparing directories:"
    echo "  Source: $DIR1"
    echo "  Target: $DIR2"
    echo "Output file: $OUTPUT_FILE"
    echo ""
fi

# Find all files in DIR1 and compare with DIR2
find "$DIR1" -type f | sort | while read -r file1; do
    # Get relative path
    rel_path="${file1#$DIR1/}"
    file2="$DIR2/$rel_path"

    echo "Comparing: $rel_path"

    if [ ! -f "$file2" ]; then
        echo "  MISSING in $DIR2"
    else
        # Run diff with options to ignore whitespace and blank lines
        # -u: unified diff format (easier to read in editors)
        # -w: ignore all white space
        # -B: ignore blank lines
        diff -uwB "$file1" "$file2" >> "$OUTPUT_FILE" 2>&1

        if [ $? -eq 0 ]; then
            echo "  IDENTICAL (ignoring whitespace/blank lines)"
        else
            echo "  DIFFERENCES FOUND"
            # Add line break between file diffs
            echo "" >> "$OUTPUT_FILE"
        fi
    fi
done

echo ""
echo "Comparison complete. Results saved to $OUTPUT_FILE"
