#!/bin/bash

ip_address="" #PLEASE HARDCODE TO WHATEVER MACHINE YOU ARE WORKING ON

pid_apm1=""
pid_apm2=""
pid_apm3=""
pid_apm4=""
pid_apm5=""
pid_apm6=""

next_run=$SECONDS

function startup () {
    ./project1_executables/APM1 $ip_address &
    pid_apm1=$!
    ./project1_executables/APM2 $ip_address &
    pid_apm2=$!
    ./project1_executables/APM3 $ip_address &
    pid_apm3=$!
    ./project1_executables/APM4 $ip_address &
    pid_apm4=$!
    ./project1_executables/APM5 $ip_address &
    pid_apm5=$!
    ./project1_executables/APM6 $ip_address &
    pid_apm6=$!
}

function get_process_info ()
{
    local raw_stats=$(ps -axo pid,%cpu,%mem | grep -E "$pid_apm1|$pid_apm2|$pid_apm3|$pid_apm4|$pid_apm5|$pid_apm6")
    echo $raw_stats
}

function get_system_info ()
{
    sleep 1
}

function cleanup () {
    echo "Ctrl+C detected..."
    kill -9 $pid_apm1
    kill -9 $pid_apm2
    kill -9 $pid_apm3
    kill -9 $pid_apm4
    kill -9 $pid_apm5
    kill -9 $pid_apm6
    exit 0
}

startup

trap cleanup SIGINT EXIT

while true; do
    #Implement some timer to make it once per 5 seconds
    if [ $SECONDS -ge $next_run ]; then
        get_process_info &
        get_system_info &
        next_run=$((next_run + 5))
    fi
    sleep 1
done

