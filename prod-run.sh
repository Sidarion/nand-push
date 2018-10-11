#!/bin/bash

. network-orchestrator-run-lib/library.sh

help() {
   echo 'usage: prod-run.sh'
   echo '       prod-run.sh --help'
   echo '       prod-run.sh [PARAMS_FOR_ANSIBLE]*'
   echo
   echo '       Start deployment into production network'
   echo
   exit 1
}

[ "$1" == "--help" ] && help

starting_network_automation "PRODUCTION"

# Load ssh-args and stuff
export ANSIBLE_CONFIG=network-orchestrator/production-run.cfg

read -p "you are running a production run. Proceed?" exec_prd_run

START_TIME=$SECONDS

# Step1: get data from git
# ---------------------------
# TODO

# Step2: run simulation playbooks
# -------------------------------
if [ "$exec_prd_run" == "y" -o "$exec_prd_run" == "yes" ]
then
  ansible-playbook -i network-orchestrator/inventories/simulation.ini network-orchestrator/step4-deploy-production.yml --diff "$@"
fi

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "Automation run took $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"    
