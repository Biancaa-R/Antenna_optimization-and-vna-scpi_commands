clc;
clear all;
close all;

% Fixed length and width
len = 0.34; % Logarithmic value, actual length will be 10^len
bre = 0.67; % Logarithmic value, actual width will be 10^bre

% Initial frequency and step size for steepest descent
initial_frequency = 1.5e9;
step_size = 5e6; % Smaller step size for faster convergence
tolerance = 1e-4; % Larger tolerance for quicker termination
max_iterations = 100; % Maximum number of iterations

% Initial frequency
frequency = initial_frequency;

% Calculate initial efficiency
current_efficiency = calculate_efficiency(len, bre, frequency);

% Steepest descent method to optimize frequency
iteration = 0;
while true
    % Calculate gradient (finite difference approximation)
    grad = (calculate_efficiency(len, bre, frequency + step_size) - current_efficiency) / step_size;
    
    % Update frequency
    new_frequency = frequency + step_size * grad;
    
    % Calculate new efficiency
    new_efficiency = calculate_efficiency(len, bre, new_frequency);
    
    % Check if the change in efficiency is within the tolerance
    if abs(new_efficiency - current_efficiency) < tolerance || iteration >= max_iterations
        break;
    end
    
    % Update frequency and efficiency for next iteration
    frequency = new_frequency;
    current_efficiency = new_efficiency;
    iteration = iteration + 1;
end

% Display the optimized frequency and corresponding efficiency
disp(['Optimized Frequency: ', num2str(frequency), ' Hz']);
disp(['Efficiency: ', num2str(current_efficiency)]);

% Function to calculate the efficiency
function e = calculate_efficiency(len, bre, frequency)
    helement = patchMicrostrip;
    helement.Length = len; % Length of the patch
    helement.Width =  bre;  % Width of the patch
    helement.FeedOffset = [0, 0]; % Center feed for simplicity
    helement.Conductor = metal('Copper'); % Set the conductor to Copper
    
    % Define the linear array using the patch element
    harray = linearArray;
    harray.Element = helement;
    
    % Calculate efficiency
    e = efficiency(harray, frequency);
end
