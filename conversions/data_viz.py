import matplotlib.pyplot as plt
import pandas as pd
# Read the CSV file into a DataFrame
data = pd.read_csv('dbmicvperm.csv')

# Plot the data
plt.figure(figsize=(10, 6))
plt.plot(data["Frequency (Hz)"], data["field"], marker='o', linestyle='-',color='blue')
plt.xlabel('Frequency (Hz)')
plt.ylabel('dbuv/m (dBuv/m)')
plt.title('Frequency vs. db micro volt/m')
plt.grid(True)
plt.show()
