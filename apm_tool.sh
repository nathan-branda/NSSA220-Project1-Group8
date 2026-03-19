#!/bin/bash

ip_address="10.118.6.131" #PLEASE HARDCODE TO WHATEVER MACHINE YOU ARE WORKING ON

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
    local proc_names=("APM1" "APM2" "APM3" "APM4" "APM5" "APM6")
    for name in "${proc_names[@]}"; do
        echo "time,cpu,ram" > "${name}_metrics.csv"
    done
    
    echo "time,rx_data_rate,tx_data_rate,disk_writes,disk_capacity" > system_metrics.csv
}

function get_process_info ()
{
    local proc_names=("APM1" "APM2" "APM3" "APM4" "APM5" "APM6")
    for name in "${proc_names[@]}"; do
        local raw_stats=$(ps -axo command,%cpu,%mem | grep -E "$name" | grep -v grep | awk '{printf ",%s,%s",$2,$3}')
        if [ -n "$raw_stats" ]; then
            echo "${next_run}${raw_stats}" >> "${name}_metrics.csv"
        fi
    done
}

function get_system_info ()
{
    local ifstat_data=$(ifstat | grep ens192 | awk '{printf ",%s,%s,",$7,$9}')
    local iostat_data=$(iostat | grep sda | awk '{printf "%s,",$4}')
    echo "${next_run}${ifstat_data}${iostat_data}" >> system_metrics.csv #add df data there
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

