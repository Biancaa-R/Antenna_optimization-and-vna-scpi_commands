import numpy as np
import pandas as pd
from joblib import load
import matplotlib.pyplot as plt

# Load the data
data = pd.read_csv('dbmicvperm.csv')

# Load the models
model1 = load("linear_regression_model1.joblib")
model2 = load("linear_regression_model2.joblib")
model3 = load("linear_regression_model3.joblib")

# Extract features
x = data["Frequency (Hz)"].values
y = data["field"].values
length = len(x)

# Initialize results list
results = []

# Generate predictions and calculate field strength
for i in range(length):
    ival = x[i]
    if ival < 18e9:
        # curve1
        af = model1.predict(np.array([[ival]]))
        result = y[i] + af
        results.append(result[0])
    elif ival >= 26e9 and ival <= 40e9:
        # curve3
        af = model3.predict(np.array([[ival]]))
        result = y[i] + af
        results.append(result[0])
    elif 18e9 <= ival < 26e9:
        # curve2
        af = model2.predict(np.array([[ival]]))
        result = y[i] + af
        results.append(result[0])

# Convert results to a numpy array
value = np.array(results)

# Check if the lengths of x and value match
if len(x) != len(value):
    print("Warning: Mismatch in array lengths. Check the loop conditions and data.")
    length = min(len(x), len(value))
    x = x[:length]
    value = value[:length]

# Plot the data
plt.figure(figsize=(10, 6))
plt.plot(x, value, marker='o', linestyle='-', color='red')
plt.xlabel('Frequency (Hz)')
plt.ylabel('dbµV (dBµV)')
plt.title('Frequency vs. db micro volt')
plt.grid(True)
plt.show()
