#!/bin/bash

# Variables
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="IoTLogIQ2024*"
DB_NAME="tb_edge"
TOTAL_STEPS=20  # Adjusted to match the actual number of steps
CURRENT_STEP=0
CONFIG_FILE="/etc/tb-edge/conf/tb-edge.conf"

# Function to move the cursor to the bottom of the terminal
function move_cursor_to_bottom() {
    tput sc   # Save cursor position
    tput cup $(($(tput lines) - 1)) 0  # Move cursor to bottom of screen
}

# Function to restore the cursor position after moving it
function restore_cursor() {
    tput rc   # Restore cursor position
}

# Function to update progress bar at the bottom of the terminal
function progress_bar() {
    PERCENT=$(($CURRENT_STEP * 100 / $TOTAL_STEPS))
    BAR=$(printf "%-${PERCENT}s" "#")
    move_cursor_to_bottom  # Move the cursor to the bottom
    echo -ne "[${BAR// /#}] ${PERCENT}%"
    restore_cursor         # Restore the cursor position
    CURRENT_STEP=$((CURRENT_STEP+1))
}

# Start script
echo "Starting the installation process..."

# Step 1: Update the package list
echo "Updating package list..."
sudo apt update > /dev/null 2>&1 && progress_bar || { echo "Failed to update package list"; exit 1; }

# Step 2: Install OpenJDK 11
echo "Installing OpenJDK 11..."
sudo apt install -y openjdk-11-jdk > /dev/null 2>&1 && progress_bar || { echo "Failed to install OpenJDK 11"; exit 1; }

# Step 3: Configure Java alternatives
echo "Configuring Java alternatives..."
sudo update-alternatives --config java > /dev/null 2>&1 && progress_bar

# Step 4: Verify Java installation
echo "Verifying Java installation..."
java -version > /dev/null 2>&1 && progress_bar || { echo "Java installation verification failed"; exit 1; }

# Step 5: Install wget
echo "Installing wget..."
sudo apt install -y wget > /dev/null 2>&1 && progress_bar || { echo "Failed to install wget"; exit 1; }

# Step 6: Add PostgreSQL repository key
echo "Adding PostgreSQL repository key..."
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - > /dev/null 2>&1 && progress_bar || { echo "Failed to add PostgreSQL key"; exit 1; }

# Step 7: Add PostgreSQL repository
echo "Adding PostgreSQL repository..."
echo "deb https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null 2>&1 && progress_bar || { echo "Failed to add PostgreSQL repository"; exit 1; }

# Step 8: Update package list after adding PostgreSQL repository
echo "Updating package list after adding PostgreSQL repository..."
sudo apt update > /dev/null 2>&1 && progress_bar || { echo "Failed to update package list after adding PostgreSQL repo"; exit 1; }

# Step 9: Install PostgreSQL 12
echo "Installing PostgreSQL 12..."
sudo apt -y install postgresql-12 > /dev/null 2>&1 && progress_bar || { echo "Failed to install PostgreSQL 12"; exit 1; }

# Step 10: Start PostgreSQL service
echo "Starting PostgreSQL service..."
sudo service postgresql start > /dev/null 2>&1 && progress_bar || { echo "Failed to start PostgreSQL service"; exit 1; }

# Step 11: Set up PostgreSQL user and database
echo "Setting up PostgreSQL user and database..."
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME;" > /dev/null 2>&1 && progress_bar || { echo "Failed to create PostgreSQL database"; exit 1; }
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $POSTGRES_USER;" > /dev/null 2>&1 && progress_bar || { echo "Failed to grant privileges"; exit 1; }

# Step 12: Download ThingsBoard Edge
echo "Downloading ThingsBoard Edge 3.6.4..."
wget https://dist.thingsboard.io/tb-edge-3.6.4pe.deb > /dev/null 2>&1 && progress_bar || { echo "Failed to download ThingsBoard Edge"; exit 1; }

# Step 13: Install ThingsBoard Edge
echo "Installing ThingsBoard Edge 3.6.4..."
sudo dpkg -i tb-edge-3.6.4pe.deb > /dev/null 2>&1 && progress_bar || { echo "Failed to install ThingsBoard Edge"; exit 1; }

# Step 14: Wait for the configuration file to exist
echo "Waiting for the configuration file to be available..."
while [ ! -f "$CONFIG_FILE" ]; do
  echo "Config file not found, waiting 10 seconds..."
  sleep 10
done
progress_bar

# Step 15: Prompt user for CLOUD_RPC_HOST value
echo "Prompting user for CLOUD_RPC_HOST value..."
read -p "Enter the new CLOUD_RPC_HOST value: " NEW_HOST

# Step 16: Append CLOUD_RPC_HOST to the configuration file
echo "Appending CLOUD_RPC_HOST to the configuration file..."
echo "# Updated by installation script" | sudo tee -a "$CONFIG_FILE" > /dev/null
echo "CLOUD_RPC_HOST=$NEW_HOST" | sudo tee -a "$CONFIG_FILE" > /dev/null
progress_bar

# Step 17: Append MQTT_BIND_PORT to the configuration file
echo "Appending MQTT_BIND_PORT to the configuration file..."
echo "export MQTT_BIND_PORT=11883" | sudo tee -a "$CONFIG_FILE" > /dev/null
progress_bar

# Step 18: Append SPRING_DATASOURCE_PASSWORD to the configuration file
echo "Appending SPRING_DATASOURCE_PASSWORD to the configuration file..."
echo "export SPRING_DATASOURCE_PASSWORD=IoTLogIQ2024" | sudo tee -a "$CONFIG_FILE" > /dev/null
progress_bar

# Step 19: Restart PostgreSQL service
echo "Restarting PostgreSQL service to apply changes..."
sudo service postgresql restart > /dev/null 2>&1 && progress_bar || { echo "Failed to restart PostgreSQL service"; exit 1; }

# Final message
echo -e "\Installation execution completed successfully."
