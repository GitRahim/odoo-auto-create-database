#!/bin/bash

# Getting parameters from run-conf.conf.
source full/path/to/run-conf.conf

# Function to check if database exists.
check_database_exists() {
    if curl -s $host:$port/web/database/list -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"db","params":[],"id":null}' | jq -r '.result[]' | grep -q $name; then
        echo "----------------- Database $name exists. Using it."
        return 1  # if database exists.
    else
        echo "----------------- Database $name doesn't exist. Creating it."
        return 0  # if database doesn't exist.
    fi
}

# Function to create a database.
create_database() {
    curl -X POST -d "master_pwd=$master_pwd&name=$name&login=$login&password=$password&phone=$phone&lang=$lang&country_code=$country_code" "$host:$port/web/database/create"
}

# Function to kill a command.
kill_process() {
    pkill -f "$1"
}

# Running Odoo with our master password.
python3 $odoo_bin_path -c $odoo_conf_file &

# Wainting for Odoo server to become up and running. When it starts listening on port $port, it means it's up and running.
while ! nc -z $host $port; do
    sleep 1
done
echo "----------------- Odoo is up and running."

# If there isn't a database with the name $name, it should be created with all parameters we defined in the run-conf.conf file. 
if check_database_exists; then
    # Calling create_database function
    create_database
fi

# Shutting down Odoo to later start it with database $name.
kill_process "python3 $odoo_bin_path -c $first_conf_file"
echo "----------------- Shut down Odoo to later start it with database $name."

echo "----------------- Starting Odoo with database $name. Please wait..."
# Starting Odoo with database $name.
python3 $odoo_bin_path -c $odoo_conf_file -d $name -i $modules_to_install --without-demo=all
