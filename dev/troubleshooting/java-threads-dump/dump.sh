#!/bin/bash

echo "Geting PID of all Java processes..."
java_pids=$(jps | awk '{print $1}')
pids=()
for pid in $java_pids; do
    prop_value=$(jcmd $pid VM.system_properties 2>/dev/null | grep "idea.platform.prefix" | cut -d '=' -f 2)
    if [[ -n "$prop_value" ]]; then
        pids+=("$pid $prop_value")
    fi
done

echo "Select a Java process :"
select item in "${pids[@]}"; do
    if [ -n "$item" ]; then
        read -r pid name <<< "$item"
        echo "Dumping threads for Java process with PID: $pid"
        file_name="$name-threads-dump-$pid"
        jstack $pid > $file_name
        echo "Threads dumped to ${file_name}"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
