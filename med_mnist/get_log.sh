# Get resource usage of aggregator flame-agent

JOB_ID="631b965dff74fb290c790589"

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
sleep 15

echo "Getting ProcessID"

PROCESS_ID=$(ps -aux | grep aggregator | head -n 1 | awk '{print $2}')

echo "done"

# Get process resource usage
cpustat 0.333 -a -p $PROCESS_ID > logs/cpustat_a.txt
cpustat 0.333 -p $PROCESS_ID > logs/cpustat.txt
pidstat 1 4500 -p $PROCESS_ID > logs/kube_aggregator.cpu & 
pidstat 1 4500 -r -p $PROCESS_ID > logs/kube_aggregator.memory &
mpstat 1 4500 > logs/kube_mpstat.cpu 
# Run python script to graph logs
#python3 plot_log.py

