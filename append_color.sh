#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <hex_color>"
    exit 1
fi

# Extract the hex color parameter
hex_color="$1"

# Check if the hex color has a valid format
if [[ ! "$hex_color" =~ ^[0-9A-Fa-f]{6}$ ]]; then
    echo "Error: Invalid hex color format."
    exit 1
fi

# Convert hex color to uppercase
hex_color=$(echo "$hex_color" | tr 'a-f' 'A-F')

# Convert hex color to PascalCase for variable name
pascal_case_name="h$(echo "$hex_color" | sed -E 's/(^|_)([a-f])/\U\2/g')"

# Define the line to append to the colors.dart file
line="Color $pascal_case_name = Vx.hexToColor('#$hex_color');"

# Path to the colors.dart file
mkdir -p "$(pwd)/lib/config"
colors_file="$(pwd)/lib/config/colors.dart"

# Check if the file exists, and create it if not
if [ ! -f "$colors_file" ]; then
    touch "$colors_file"
    echo "// This file was created by the script on $(date)" > "$colors_file"
    echo "import 'package:flutter/material.dart';" >> "$colors_file"
    echo "import 'package:neon_x/neon_x.dart';" >> "$colors_file"
fi

# Append the line to the colors.dart file
echo "$line" >> "$colors_file"

echo "Line appended to $colors_file: $line"
