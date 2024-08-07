clear all; 
close all;
clc;

% Define frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define practical ranges for length and breadth (in meters)
lengthRange = logspace(-3, 1, 10); % Length from 0.001 m to 10 m
breadthRange = logspace(-3, 1, 10); % Breadth from 0.001 m to 10 m

% Initialize matrices to store efficiency values
efficiencyMatrix = NaN(length(lengthRange), length(breadthRange)); % Use NaN to indicate uncomputed values

% Loop through each combination of length and breadth
for i = 1:length(lengthRange)
    for j = 1:length(breadthRange)
        try
            % Create the microstrip patch antenna element with current dimensions
            helement = patchMicrostrip;
            helement.Length = lengthRange(i); % Length of the patch
            helement.Width = breadthRange(j);  % Width of the patch
            
            % Set FeedOffset to a valid value (ensure it's above the minimum limit)
            helement.FeedOffset = [0.0, 0.0]; % Example valid offset
            
            % Define the linear array using the patch element
            harray = linearArray;
            harray.Element = helement;
            
            % Calculate efficiency
            efficiencyValue = efficiency(harray, frequency);
            
            % Store efficiency value
            efficiencyMatrix(i, j) = efficiencyValue;
        catch ME
            warning('Error calculating efficiency for Length: %.3f, Breadth: %.3f. Error: %s', lengthRange(i), breadthRange(j), ME.message);
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
