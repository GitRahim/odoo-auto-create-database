This bash script works in Linux.

For creating an Odoo database automatically, we're using this bash script.

For the sake of flexibility, we are using the run-conf.conf file.

You should run run-odoo-auto.sh in order to create a database with parameters you define in the run-conf.conf file, or if database with the name you defined exists running Odoo with that database.

Check the odoo.conf carefully; Write your addons path there and also you can add more configs there if you want.

You gave a value to the master_pwd parameter in the run-conf.conf file. Give that same value to the admin_passwd parameter in the odoo.conf file.

Before running run-odoo-auto.sh, install jq in your Linux and also run chmod +x full/path/to/run-odoo-auto.sh.

For running run-odoo-auto.sh, in your Linux terminal run: full/path/to/run-odoo-auto.sh.

For shutting down Odoo, in your Linux terminal hit ctrl and c. If it doesn't work, run: sudo kill -9 $(sudo lsof -t -i:8069). Instead of 8069, write the port that Odoo is using.
