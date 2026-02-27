#!/bin/bash

ip_address=#PLEASE HARDCODE TO WHATEVER MACHINE YOU ARE WORKING ON
pid_apm1=""
pid_apm2=""
pid_apm3=""
pid_amp4=""
pid_apm5=""
pid_apm6=""
function startup () {
    ./project1_executables/APM1
    pid_apm1=$!
    ./project1_executables/APM2
    pid_apm2=$!
    ./project1_executables/APM3
    pid_apm3=$!
    ./project1_executables/APM4
    pid_apm4=$!
    ./project1_executables/APM5
    pid_apm5=$!
    ./project1_executables/APM6
    pid_apm6=$!
    return 0
}

function get_process_info ()
{

}

function get_system_info ()
{

}

function cleanup () {
    kill -9 $pid_apm1 $pid_apm2 $pid_apm3 $pid_apm4 $pid_apm5 $pid_apm6
}

startup

while true; do
    #Implement some timer to make it once per 5 seconds
    get_process_info
    get_system_info
done

trap cleanup SIGINT EXIT
