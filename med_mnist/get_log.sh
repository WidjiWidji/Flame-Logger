# Get resource usage of aggregator flame-agent

JOB_ID="62e1661d6a9a1d6fd8d9f6c3"

# Look through each flame task and check if it is aggregator
# once aggregator has been found extract aggregator's task id

FLAME_TASKS=$(flamectl get tasks $JOB_ID --insecure | awk '{print $4}' | grep -oE '[0-9a-z]+' | tail -n +2)

aggregator_task_id=""

for task in ${FLAME_TASKS[@]}; do
	role=$(flamectl get task $JOB_ID $task --insecure | awk '{print $2}' | sed -n 5p | grep -oE '[0-9a-z]+')
	if [ "$role" == "aggregator" ]; then
		aggregator_task_id=$task
		break
	fi
done

# Start flame job
flamectl get jobs --insecure

flamectl start job $JOB_ID --insecure

# FIX: NEED TO WAIT FOR flame-agent pods to be created
sleep 2

# Get ContainerID and ProcessID for aggregator flamelet agent
CONTAINER_ID=$(kubectl get pods -l job-name=flame-agent-${aggregator_task_id} -n flame -o json | jq -r '.items[].status.containerStatuses[] |.containerID' | awk '{print substr($0, 14)}')

PROCESS_ID=$(crictl inspect --output go-template --template '{{.info.pid}}' $CONTAINER_ID)

# Get process resource usage
pidstat 1 4500 -p $PROCESS_ID > logs/agent_cpu.cpu

# Run python script to graph logs
python3 plot_log.py

