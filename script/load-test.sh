#!/bin/bash

#from lab https://www.skills.google/paths/20/course_templates/1510/labs/602617

#Declare relevant variables
URL="$HELLO_APP_URL/load"
CONCURRENCY=80
LOOPS=5
ERROR_COUNT=0
MAX_ERRORS=3
TOKEN=$(gcloud auth print-identity-token)
LOG_NAME="projects/$PROJECT_ID/logs/run.googleapis.com%2Frequests"

# Define a function to execute when SIGINT is received
cleanup_and_exit() {
    echo -e "\nCtrl+C detected. Performing cleanup and exiting..."
    for pid in "${background_pids[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then # Check if process still exists
            echo "Killing background process with PID: $pid"
            kill "$pid" # Send SIGTERM
        fi
    done
    exit 1 # Exit with a non-zero status to indicate abnormal termination
}

# Trap the SIGINT signal and call the cleanup_and_exit function
trap cleanup_and_exit SIGINT

echo "Sending $CONCURRENCY concurrent requests, $LOOPS times to $URL..."

# Use nested loops to run the load test
for i in $(seq 1 $LOOPS); do
    echo "--- Starting batch $i of $LOOPS ---"
    # The first curl command sends a concurrent load of requests
    for j in $(seq 1 $CONCURRENCY); do
        curl -s -o /dev/null -H "Authorization: Bearer $TOKEN" "$URL" &
    done
    echo "Requests sent"

    # Print a dot every half second, as a background job
    while true; do
        echo -n "."
        sleep 0.5
    done &

    # Get the process ID of that background job
    pid=$!
    background_pids+=($pid)

    # Send a second curl command as a "canary" that checks for errors
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" "$URL")

    # Kill the background process when the second curl command completes
    kill "$pid"
    echo ""

    # Check the canary's status code and print a message
    if [[ "$STATUS_CODE" -eq "200" ]]; then
        echo "Sent test request. No error detected! Status Code: 200"
    else
        echo "Sent test request. Error detected. Status Code: $STATUS_CODE"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi

    # Stop the script if the maximum number of errors is reached
    if [[ "$ERROR_COUNT" -ge "$MAX_ERRORS" ]]; then
        echo "Maximum errors reached. Halting load test."
        exit 1
    fi
done

echo "Waiting for remaining requests..."
wait

echo "Success! Load test complete."
gcloud logging write $LOG_NAME "Success! Load test complete."
