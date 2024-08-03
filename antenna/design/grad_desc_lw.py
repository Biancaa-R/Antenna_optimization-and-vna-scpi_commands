import numpy as np

# Example objective function (simplified)
def objective_function(L, W):
    return_loss = (L - 3)**2 + (W - 2)**2
    gain = -((L - 4)**2 + (W - 3)**2)
    return return_loss - 0.5 * gain

# Gradient descent function
def gradient_descent(learning_rate, num_iterations):
    L, W = 1.0, 1.0  # Initial guess
    for i in range(num_iterations):
        dL = 2 * (L - 3) - 2 * 0.5 * (L - 4)
        dW = 2 * (W - 2) - 2 * 0.5 * (W - 3)
        
        L = L - learning_rate * dL
        W = W - learning_rate * dW
        
        if i % 100 == 0:
            print(f"Iteration {i}: L = {L:.4f}, W = {W:.4f}, Objective = {objective_function(L, W):.4f}")
    
    return L, W

# Run gradient descent
optimal_L, optimal_W = gradient_descent(learning_rate=0.01, num_iterations=1000)
print(f"Optimal L: {optimal_L}, Optimal W: {optimal_W}")
