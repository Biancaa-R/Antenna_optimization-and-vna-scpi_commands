clear all;
close all;
clc;

% Define frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define ranges for length and breadth
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
        
        % Check if the 'efficiency' method exists; otherwise, use an alternative method
        if exist('efficiency', 'file') == 2
            efficiencyValue = efficiency(harray, frequency); % Ensure this method exists and is correct
        else
            efficiencyValue = returnLoss(harray, frequency); % Fallback to return loss if efficiency is not available
        end
        
        % Debug output to check size of efficiencyValue
        disp(['Size of efficiencyValue: ', num2str(size(efficiencyValue))]);

        % Ensure efficiencyValue is a scalar
        if numel(efficiencyValue) == 1
            % Store efficiency value
            efficiencyMatrix(i, j) = efficiencyValue;
        else
            warning('Efficiency value is not a scalar. Skipping assignment.');
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
