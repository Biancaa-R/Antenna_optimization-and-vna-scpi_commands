clear all; 
close all;
clc;

% Define frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define the exponential range for length and breadth
numPoints = 20; % Reduced number of points for testing
minValue = 0.001; % Minimum value (10 mm)
maxValue = 10000; % Maximum value (100 mm)

% Generate exponentially spaced values
lengthRange = logspace(log10(minValue), log10(maxValue), numPoints); % Length
breadthRange = logspace(log10(minValue), log10(maxValue), numPoints); % Breadth

% Initialize matrices to store efficiency values
efficiencyMatrix = zeros(length(lengthRange), length(breadthRange));

% Loop through each combination of length and breadth
for i = 1:length(lengthRange)
    for j = 1:length(breadthRange)
        % Create the microstrip patch antenna element with current dimensions
        helement = patchMicrostrip;
        helement.Length = lengthRange(i); % Length of the patch
        helement.Width = breadthRange(j);  % Width of the patch
        helement.Conductor = metal('Copper');
        
        % Set FeedOffset to a valid value
        helement.FeedOffset = [0.001, 0.001]; % Ensure this is above the minimum threshold
        
        % Define the linear array using the patch element
        harray = linearArray;
        harray.Element = helement;
        
        % Calculate efficiency
        try
            efficiencyValue = efficiency(harray, frequency);
            % Store efficiency value
            efficiencyMatrix(i, j) = efficiencyValue*100;
        catch ME
            warning('Error calculating efficiency for Length: %.3f, Breadth: %.3f. Error: %s', lengthRange(i), breadthRange(j), ME.message);
            efficiencyMatrix(i, j) = NaN; % Assign NaN in case of error
        end
    end
end

% Plot the efficiency as a surface plot
figure;
[X, Y] = meshgrid(breadthRange, lengthRange); % Create meshgrid for plotting
surf(X, Y, efficiencyMatrix');
xlabel('Breadth (m)');
ylabel('Length (m)');
zlabel('Efficiency');
title('Efficiency of Microstrip Patch Antenna');
colorbar;
grid on;
hold off;

% Plot the efficiency as a contour plot
figure;
contourf(X, Y, efficiencyMatrix');
xlabel('Breadth (m)');
ylabel('Length (m)');
title('Efficiency Contour Plot of Microstrip Patch Antenna');
colorbar;
grid on;
