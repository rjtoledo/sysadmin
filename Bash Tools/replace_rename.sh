#!/bin/bash

# Prompt user for the character to replace
read -p "Enter the character you want to replace: " char_to_replace

# Prompt user for the replacement character
read -p "Enter the character you want to replace it with: " replacement_char

# Replace the character in all filenames and directory names in the current directory and its subdirectories
find . -depth -name "*$char_to_replace*" -execdir sh -c 'mv "$1" "$(echo "$1" | sed "s/'"$char_to_replace"'/'"$replacement_char"'/g")"' sh {} \;

echo "Done!"