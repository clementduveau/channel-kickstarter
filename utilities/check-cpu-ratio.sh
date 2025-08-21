#!/bin/bash

# Get total cluster CPU capacity in cores
cluster_capacity_cores=$(kubectl get nodes -o json | jq '[.items[] | .status.allocatable.cpu | sub("m";"")] | map(tonumber) | add / 1000')

# Get total CPU requests from all pods in cores
total_requests_cores=$(kubectl get pods --all-namespaces -o json | jq '[.items[] | .spec.containers[] | .resources.requests.cpu | select(. != null) | sub("m";"")] | map(tonumber) | add / 1000')

# Calculate the percentage
if [ -z "$cluster_capacity_cores" ] || [ -z "$total_requests_cores" ] || [ "$cluster_capacity_cores" == "0" ]; then
    echo "Could not retrieve all necessary data or cluster capacity is zero."
else
    # Use awk for floating point division
    percentage=$(awk "BEGIN {print ($total_requests_cores / $cluster_capacity_cores) * 100}")

    echo "Cluster CPU Capacity: ${cluster_capacity_cores} cores"
    echo "Total CPU Requested: ${total_requests_cores} cores"
    echo "-----------------------------------"
    printf "Request to Capacity Ratio: %.2f%%\n" $percentage
fi