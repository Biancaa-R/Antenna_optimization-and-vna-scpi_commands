clear all;
close all;
clc;

% Define the frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define the initial guess for dimensions [length, width]
initialDimensions = [0.02, 0.02]; % Example initial dimensions (20 mm x 20 mm)

% Define bounds for the dimensions
lb = [0.01, 0.01]; % Lower bounds (10 mm x 10 mm)
ub = [0.03, 0.03]; % Upper bounds (30 mm x 30 mm)

% Set learning parameters for gradient descent
learningRate = 0.01;
tolerance = 1e-6;
maxIterations = 100;

% Initialize parameters
dimensions = initialDimensions;
performanceHistory = zeros(maxIterations, 1); % To store performance at each iteration

% Gradient descent loop
for iter = 1:maxIterations
    % Evaluate the performance of the current parameters
    try
        currentPerformance = objectiveFunction(dimensions, frequency);
        if isnan(currentPerformance)
            error('Invalid performance detected.');
        end
    catch ME
        disp('Error in objective function:');
        disp(ME.message);
        disp('Current dimensions:');
        disp(dimensions);
        break;
    end
    
    % Store the current performance
    performanceHistory(iter) = -currentPerformance;
    
    % Compute gradients (numerical approximation)
    grad = zeros(1, 2);
    epsilon = 1e-6;
    for i = 1:2
        delta = zeros(1, 2);
        delta(i) = epsilon;
        try
            grad(i) = (objectiveFunction(dimensions + delta, frequency) - currentPerformance) / epsilon;
        catch ME
            disp('Error in gradient computation:');
            disp(ME.message);
            disp('Current dimensions:');
            disp(dimensions);
            break;
        end
    end
    
    % Update parameters
    dimensions = dimensions - learningRate * grad;
    
    % Ensure dimensions stay within bounds
    dimensions = max(lb, min(ub, dimensions));
    
    % Check for convergence
    if norm(grad) < tolerance
        performanceHistory = performanceHistory(1:iter); % Trim unused part of the array
        break;
    end
end

% Display the optimal dimensions and performance
disp('Optimal Dimensions (Length, Width):');
disp(dimensions);
disp('Optimal Efficiency:');
try
    disp(objectiveFunction(dimensions, frequency));
catch ME
    disp('Error in final objective function evaluation:');
    disp(ME.message);
end

% Plot the performance over iterations
figure;
plot(1:length(performanceHistory), performanceHistory, '-o');
xlabel('Iteration');
ylabel('Efficiency (Negative Gain)');
title('Optimization of Microstrip Patch Antenna Dimensions');
grid on;

% Objective function to maximize efficiency
function performance = objectiveFunction(dimensions, frequency)
    % Validate dimensions
    if any(isnan(dimensions)) || any(dimensions <= 0)
        disp('Invalid dimensions detected.');
        performance = NaN;
        return;
    end
    
    % Create a simple microstrip patch antenna element
    helement = patchMicrostrip;
    helement.Conductor = metal('Copper');
    helement.Length = dimensions(1); % Length of the patch
    helement.Width = dimensions(2);  % Width of the patch
    helement.FeedOffset = [0, 0]; % Center feed
    
    % Define the linear array
    harray = linearArray;
    harray.Element = helement;
    
    % Analyze the antenna
    try
        % Calculate the gain at the specified frequency
        %patternData = pattern(harray, frequency, 0, 0); % Gain at broadside (0 degrees azimuth, 0 degrees elevation)
        %performance = -max(patternData); % Negative gain to maximize
        performance=efficiency(harray,frequency);
    catch ME
        disp('Error during efficiency calculation:');
        disp(ME.message);
        performance = NaN;
    end
end
