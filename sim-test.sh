#!/bin/bash

echo 
echo "Starting networktesting in simulation"
echo "#####################################"
echo 

START_TIME=$SECONDS

ansible-playbook -i network-orchestrator/step3-test-simulation.testcases.yml network-orchestrator/step3-test-simulation.yml -k

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "Automation deployment run took $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"    
