#!/bin/bash

generate_image_variables() {
    local assets_dir="$1"
    local output_dir="$2"
    local output_file="$3"

    # Ensure the output directory exists
    mkdir -p "$output_dir"

    # Start the output file with the common basePath
    echo "const String basePath = '$assets_dir';" > "$output_file"
    echo "" >> "$output_file"

    # Generate image variables
    for file_path in "$assets_dir"/*; do
        if [ -f "$file_path" ]; then
            # Extract the file name without extension
            file_name=$(basename -- "$file_path")
            file_name_without_extension="${file_name%.*}"

            # Convert file name to PascalCase
            pascal_case_name="$(echo "$file_name_without_extension" | sed -E 's/(^|_)([a-z])/\U\2/g')"

            # Generate the variable line
            variable_line="const img${pascal_case_name} = '\$basePath/$file_name';"

            # Append the variable line to the output file
            echo "$variable_line" >> "$output_file"
        fi
    done

    echo "Image variables generated in $output_file"
}

# Generate image variables for images
generate_image_variables "$(pwd)/assets/images" "$(pwd)/lib/resources" "$(pwd)/lib/resources/images.dart"

# Generate image variables for icons
generate_image_variables "$(pwd)/assets/icons" "$(pwd)/lib/resources" "$(pwd)/lib/resources/icons.dart"
