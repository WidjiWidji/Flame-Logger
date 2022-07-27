# READ CONTROLLER.CPU and create graphs from data
import matplotlib.pyplot as plt

time = [i for i in range(30)]
cpu_usage = [0 for i in range(30)]

# Get %CPU from FLAME controller log
log_file = open("logs/controller.cpu")

lines = log_file.readlines()[3:-1]

count = 0
for line in lines:
    print(float(line.split()[8]))
    cpu_usage[count] += float(line.split()[8])
    count += 1

log_file.close()

#cpu_usage = list(map(float, cpu_usage))

# plot time (seconds) vs %CPU logs
plt.plot(time, cpu_usage)
plt.title('Time vs flame-controller cpu usage: during hier_mnist example')
plt.xlabel('Time (seconds)')
plt.ylabel('%CPU')
plt.savefig('plots/controller_test1.png')
