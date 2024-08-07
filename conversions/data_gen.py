import numpy as np
import random
#When antenna factor is stated in decibels, field strength in decibel-microvolts per meter (dBµV/m) is calculated by adding the signal 
#level at the antenna terminals in decibel-microvolts (dBµV) to the antenna factor in decibel/meter (dB/m)

# Define the frequency range and number of data points
start_freq =1   # 1 GHz
end_freq = 40e9  # 18 GHz
num_points = 150

# Generate frequency points
list1=[]
frequencies = np.linspace(start_freq, end_freq, num_points)
for i in range(0,150):
    val=random.random()*4
    list1.append(val)

value=np.array(list1)
# Combine frequencies and antenna factors into a single array
data_points = np.column_stack((frequencies, value))

data_points
import pandas as pd

# Create a DataFrame from the data points
df = pd.DataFrame(data_points, columns=["Frequency (Hz)", "Antenna Factor (dB/m)"])

# Save the DataFrame to a CSV file
file_path = "dbmicvperm.csv"
df.to_csv(file_path, index=False)