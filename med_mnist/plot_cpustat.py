import matplotlib.pyplot as plt

log_file = open("logs/cpustat_a.txt")
lines = log_file.readlines()

time = []
cpu_usage= []

count = 0
skip = False

for line in lines:
    split = line.split()
    if len(split) > 0 and split[0] != '%CPU' and skip == False:
        time.append(count * 0.333)
        cpu_usage.append(float(split[0]))
        count += 1
        skip = True
    elif len(split) == 0 and skip == False:
        time.append(count * 0.333)
        count += 1
        cpu_usage.append(float(0))
    elif len(split) > 0 and split[0] == '%CPU':
        skip = False

print(cpu_usage)
print(time)
log_file.close()

plt.plot(time, cpu_usage)
plt.title('Time vs aggregator %CPU: med_mnist (RESNET) example')
plt.xlabel('Time(seconds)')
plt.ylabel('%CPU')
plt.savefig('plots/cpustat_RESNET50_10.png')
