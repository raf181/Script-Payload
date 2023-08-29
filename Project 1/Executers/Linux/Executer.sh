#!/bin/bash

# Set the URL of the configuration file on GitHub
configUrl=""
configloc=".config"
# Fetch the configuration file contents using curl
config_file=""
while IFS= read -r line; do
  if echo "$line" | grep -iq "Active=true"; then
    # The line "Active=true" is found
    echo "Remote Configuration file is active. Running the script..."
    config_file=$(curl -L "$configUrl")
    break
  elif echo "$line" | grep -iq "Active=false"; then
    # The line "Active=false" is found
    echo "Remote configuration file is not active. Exiting..."
    exit 1
  else
    # Line does not contain "Active=true" or "Active=false"
    # Add code to read local configuration file
    if [ -f "$configloc" ]; then
      echo "Local configuration file found. Using local configuration..."
      config_file=$(< "$configloc")
      break
    else
      echo "Local configuration file not found. Exiting..."
      exit 1
    fi
  fi
done < <(curl -s "$configUrl")
# The script will only reach this point if the remote configuration file is inaccessible or has an unknown format.
# Local configuration handling is omitted in this translation for brevity.

# Read the remote configuration file
while IFS="=" read -r key value; do
  case "$key" in
    "TARGET_SERVER") target_server="$value" ;;
  esac
done <<< "$config_file"

# Validate if all the required variables are set
if [ -z "$target_server" ]; then
  echo "TARGET_SERVER is not set in the configuration file."
  exit 1
fi

# Safety Checks Done