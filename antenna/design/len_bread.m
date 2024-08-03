clear all;
close all;
clc;

% Define frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define ranges for length and breadth (adjusted for correct range)
lengthRange = linspace(0.005, 0.02, 20); % Length from 5 mm to 20 mm
breadthRange = linspace(0.005, 0.02, 20); % Breadth from 5 mm to 20 mm

% Initialize matrices to store efficiency values
efficiencyMatrix = zeros(length(lengthRange), length(breadthRange));

% Create a figure for plotting
figure;
hold on;

% Loop through each combination of length and breadth
for i = 1:length(lengthRange)
    for j = 1:length(breadthRange)
        % Create the microstrip patch antenna element with current dimensions
        helement = patchMicrostrip;
        helement.Length = lengthRange(i); % Length of the patch
        helement.Width = breadthRange(j);  % Width of the patch
        helement.FeedOffset = [0, 0]; % Center feed for simplicity
        
        % Define the linear array using the patch element
        harray = linearArray;
        harray.Element = helement;
        
        % Calculate efficiency
        efficiencyValue = efficiency(harray, frequency);
        
        % Store efficiency value
        efficiencyMatrix(i, j) = efficiencyValue;
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
