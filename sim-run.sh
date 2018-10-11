#!/bin/bash

. network-orchestrator-run-lib/library.sh

help() {
   echo 'usage: sim-run.sh'
   echo '       sim-run.sh --help'
   echo '       sim-run.sh [PARAMS_FOR_ANSIBLE]*'
   echo
   echo '       Start deployment into simulation network'
   echo
   exit 1
}

[ "$1" == "--help" ] && help

starting_network_automation "simulation"

# Load ssh-args and stuff
export ANSIBLE_CONFIG=network-orchestrator/simulation-run.cfg

START_TIME=$SECONDS

# Step1: get data from netbox
# ---------------------------
python3 netbox-joined-inventory/script/netbox_joined_inventory.py -c netbox-joined-inventory/config/netbox_joined_inventory.yml

# Step2: run simulation playbooks
# -------------------------------
ansible-playbook -i network-orchestrator/inventories/simulation.ini network-orchestrator/step2-deploy-simulation.yml --diff "$@"

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "Automation deployment run took $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"    

# Step3: test network using ping
# ------------------------------
#ansible-playbook -i network-orchestrator/inventories/test-hosts.yml network-orchestrator/step3-test-simulation.yml

