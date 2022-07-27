# READ AGENT_CPU.CPU and create graphs from data
import matplotlib.pyplot as plt

# hold time and cpu usage for 4500 seconds for plotting
time = [i for i in range(4500)]
cpu_usage = [0 for i in range(4500)]

# Get %CPU from FLAME flamelet agent log
log_file = open("logs/agent_cpu.cpu")

lines = log_file.readlines()[3:-1]

count = 0
for line in lines:
    cpu_usage[count] += float(line.split()[8])
    count += 1

log_file.close()

# plot time (seconds) vs %CPU logs
plt.plot(time, cpu_usage)
plt.title('Time vs flamelet agent %CPU: med_mnist example')
plt.xlabel('Time (seconds)')
plt.ylabel('%CPU')
plt.savefig('plots/agent_1.png')
