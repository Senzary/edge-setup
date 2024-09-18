#!/bin/bash

CONFIG_FILE="/etc/tb-edge/conf/tb-edge.conf"

# Step 1: Prompt user for CLOUD_ROUTING_KEY value
echo "Prompting user for CLOUD_ROUTING_KEY value..."
read -p "Enter a valid ROUTING_KEY value: " NEW_KEY

# Step 2: Prompt user for CLOUD_ROUTING_KEY value
echo "Prompting user for CLOUD_ROUTING_SECRET value..."
read -p "Enter a valid ROUTING_SECRET value: " NEW_SECRET

# Step 3: Appending Routing Key into file
echo "CLOUD_ROUTING_KEY=$NEW_KEY" | sudo tee -a "$CONFIG_FILE" > /dev/null

# Step 4: Appending Routing Secret into data 
echo "CLOUD_ROUTING_SECRET=$NEW_SECRET" | sudo tee -a "$CONFIG_FILE" > /dev/null

# Step 4: Installing Edge 
echo "Installing Edge"
sudo /usr/share/tb-edge/bin/install/install.sh

# Step 5: Reloading daemons
sudo systemctl daemon-reload

echo "Restarting Edge service after setup"
sudo systemctl restart tb-edge

# Final message
echo -e "\Installation execution completed successfully."