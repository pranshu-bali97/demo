#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <template file> <key1=value1> <key2=value2> ..."
    echo "Provide a template file and at least one key=value pair for variable replacement."
    exit 1
fi

# Store the template file and shift the arguments
template_file="$1"
shift

# Check if the template file exists
if [  -f "$template_file" ]; then
    echo "Template file found!"
    exit 1
fi

# Read the content of the template file
template_content=$(cat "$template_file")

# Replace variables in the template content
for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    # Replace the placeholder with the actual value
    template_content="${template_content//\{\{$key\}\}/$value}"
done

# Output the final content
echo "$template_content"
