# Configure fish shell
bash .devcontainer/configure_fish_shell.bash

# Update python requirements, making sure we are in sync with `setup.py`
echo "Installing packages in setup.py..."
pip install --user --no-warn-script-location -e ".[dev]"

# Check if Trunk is already installed
# echo "Checking Trunk Install..."
# if ! command -v trunk &> /dev/null; then
#     echo "Trunk is not installed. Installing it now..."
#     # Install Trunk
#     trunk install
# else
#     echo "Trunk is already installed."
# fi
# Update Trunk's enabled runtimes & linters, making sure we are in sync with `.trunk/trunk.yaml`
#echo "Upgrading Trunk Linters..."
#trunk upgrade

# Create a symbolic link to dbt's profiles.yml
# By doing this, all dbt plugins/extensions can access the same profiles.yml
echo "Create a symbolic link to dbt's profiles.yml for dbt_power_user extension..."
mkdir -p ~/.dbt/
ln -sf /workspaces/dlt-dbt-snowflake-tutorial/dbt_project/profiles.yml ~/.dbt/profiles.yml

# Install terraform
#echo "Installing Terraform..."
#wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
#echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
#sudo apt update && sudo apt install terraform

# Install Airbyte
#echo "Installing Airbyte..."
#curl -LsfS https://get.airbyte.com | bash -
