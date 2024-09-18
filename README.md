# Edge Installation Guide

This guide provides the steps required to install and configure Edge version 3.6.4 on a system. The process is divided into two stages:

1. **Initial Setup** - This includes updating the system, installing necessary dependencies, and setting up PostgreSQL.
2. **Post Installation Configuration** - Configures Edge by prompting the user for specific configuration details and finalizing the installation.

## Prerequisites

- A system running a Linux distribution such as Ubuntu.
- Root or sudo access to install packages and configure services.
- Internet access to download dependencies and packages.

## 1. Initial Setup (setup-3.4.6.sh)

The first step is to run the `setup-3.4.6.sh` script to prepare the system and install Edge.

### Steps Performed in Setup:

1. **Update package list**: Updates the system's package list.
2. **Install OpenJDK 11**: Installs OpenJDK 11, which is required to run.
3. **Configure Java alternatives**: Ensures that OpenJDK is correctly set as the default Java version.
4. **Verify Java installation**: Confirms that Java has been installed successfully.
5. **Install wget**: Installs the wget utility for downloading files.
6. **Add PostgreSQL repository key**: Adds the PostgreSQL repository key to the system.
7. **Add PostgreSQL repository**: Adds the PostgreSQL repository for version 12.
8. **Update package list again**: Updates the package list after adding the PostgreSQL repository.
9. **Install PostgreSQL 12**: Installs PostgreSQL version 12.
10. **Start PostgreSQL service**: Starts the PostgreSQL service.
11. **Set up PostgreSQL user and database**: Creates the PostgreSQL database and grants necessary privileges.
12. **Download ThingsBoard Edge**: Downloads Edge version 3.6.4.
13. **Install ThingsBoard Edge**: Installs Edge using the downloaded `.deb` package.
14. **Wait for configuration file**: Waits for the Edge configuration file to be generated.
15. **Prompt for CLOUD_RPC_HOST**: Prompts the user to input a valid `CLOUD_RPC_HOST` value.
16. **Append CLOUD_RPC_HOST to config**: Appends the provided `CLOUD_RPC_HOST` value to the configuration file.
17. **Append MQTT_BIND_PORT**: Configures MQTT bind port.
18. **Append SPRING_DATASOURCE_PASSWORD**: Adds the Spring Datasource password to the configuration file.
19. **Restart PostgreSQL**: Restarts the PostgreSQL service to apply changes.

### Running the Setup Script

```bash
sudo chmod 777 setup-3.4.6.sh
sudo ./setup-3.4.6.sh
```

## 2. Post Installation (post-install.sh)

In order to proceed with Egde Integration the user must create the Edge entity in IoTLogIQ.

Go to Edge Management >> Instances >> Add Edge >> Add New Edge

In the modal window an Edge key and Edge secret will be displayed. Those are the values you need to input in the next steps

After the initial setup, the next step is to finalize the configuration of Edge by running the `post-install.sh` script. This script prompts the user for additional configuration details and restarts necessary services to complete the installation.

### Steps Performed in Post Installation

1. **Prompt for CLOUD_ROUTING_KEY**
   The script asks the user to enter a valid `CLOUD_ROUTING_KEY` value that will be used for Edge's cloud communication.

   ```bash
   Enter a valid ROUTING_KEY value:
   ```

2. **Prompt for CLOUD_ROUTING_SECRET**  
   The script asks the user to enter a valid `CLOUD_ROUTING_SECRET` value that will be used for Edge's cloud communication.

   ```bash
   Enter a valid ROUTING_SECRET value:
   ```
