from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
import pandas as pd
df=pd.read_csv("antenna_factor3.csv")
x = df["Frequency (Hz)"].values.reshape(-1, 1)
y=df["Antenna Factor (dB/m)"]
x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=0.3,random_state=1)
lrmodel=LinearRegression()
lrmodel.fit(x_train,y_train)
from joblib import dump
dump(lrmodel, 'linear_regression_model3.joblib')