import numpy as np

# Define the frequency range and number of data points
start_freq = 26.5e9  # 1 GHz
end_freq = 40e9  # 18 GHz
num_points = 100

# Generate frequency points
frequencies = np.linspace(start_freq, end_freq, num_points)

# Generate antenna factor points (linearly distributed between 22 dB/m and 42 dB/m)
antenna_factors = np.linspace(36.8 ,39.6 ,num_points)

# Combine frequencies and antenna factors into a single array
data_points = np.column_stack((frequencies, antenna_factors))

data_points
import pandas as pd

# Create a DataFrame from the data points
df = pd.DataFrame(data_points, columns=["Frequency (Hz)", "Antenna Factor (dB/m)"])

# Save the DataFrame to a CSV file
file_path = "antenna_factor3.csv"
df.to_csv(file_path, index=False)