#!/bin/bash

JOB_LOG_FILE="${SLURM_JOB_NAME%.*}-jobs.txt"
MACHINE_FILE="${SLURM_JOB_NAME%.*}-hosts.txt"

# Expand tasks from "2,5(x1),3(x2)" to "2 5 3 3 "
expand_slurm_tasks_per_node() {
    [[ -z "${SLURM_TASKS_PER_NODE}" ]] && return

    local tasks
    tasks=( $(echo "${SLURM_TASKS_PER_NODE}" | tr ',' ' ') )

    local num count
    for val in ${tasks[*]}; do
        num="${val/(*)/}"
        if [[ -z "${val%%*)}" ]]; then
            count=$(echo "$val" | sed -E 's#[0-9]+\(x([0-9]+)\)#\1#')
        else
            count=1
        fi
        printf "$num%.0s " $(seq $count)
    done
}


# Make a list in the form "cpu/host"
cpu_host_array() {
    local hosts cpus
    hosts=( $(python -m ClusterShell.CLI.Nodeset -e "${SLURM_NODELIST}") )
    cpus=( $(expand_slurm_tasks_per_node) )
    for ((i=0; i<${#hosts[*]}; ++i)); do
        echo "${cpus[i]}/${hosts[i]}"
    done
}


cpu_host_array > $MACHINE_FILE

echo "
--controlmaster
--sshdelay 0.2
--sshloginfile $MACHINE_FILE
--joblog $JOB_LOG_FILE
--resume-failed
--retries 2
--memfree 1G
--workdir .
"
