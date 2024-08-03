clear;
close all;
clc;

% Define frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define ranges for length and breadth (adjusted for correct range)
lengthRange = linspace(0.005, 0.01, 20); % Length from 5 mm to 20 mm
breadthRange = linspace(0.005, 0.01, 20); % Breadth from 5 mm to 20 mm
maxlen=0;
maxbre=0;
maxeff=0;

% Initialize matrices to store efficiency values
efficiencyMatrix = zeros(length(lengthRange), length(breadthRange));

% Loop through each combination of length and breadth
for i = 1:length(lengthRange)
    for j = 1:length(breadthRange)
        % Create the microstrip patch antenna element with current dimensions
        patchAntenna = patchMicrostrip;
        patchAntenna.Length = lengthRange(i); % Length of the patch
        patchAntenna.Width = breadthRange(j);  % Width of the patch
        patchAntenna.FeedOffset = [0, 0]; % Center feed for simplicity
        
        % Define the linear array using the patch element
        antennaArray = linearArray;
        antennaArray.Element = patchAntenna;
        
        % Calculate efficiency
        % Note: The efficiency function may need to be replaced with the correct method to compute the efficiency
        efficiencyValue = computeEfficiency(antennaArray, frequency);
        
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
%maxeff=max(efficiencyMatrix);

% 3D Scatter Plot
figure;
scatter3(X(:), Y(:), efficiencyMatrix(:), 50, efficiencyMatrix(:), 'filled');
xlabel('Breadth (m)');
ylabel('Length (m)');
zlabel('Efficiency');
title('3D Scatter Plot of Microstrip Patch Antenna Efficiency');
colorbar; % Display color bar to indicate efficiency values
colormap('cool'); % Use the 'spring' colormap
grid on;


% 2D Scatter Plot
figure;
scatter(X(:), Y(:), 50, efficiencyMatrix(:), 'filled');
xlabel('Breadth (m)');
ylabel('Length (m)');
title('2D Scatter Plot of Microstrip Patch Antenna Efficiency');
colorbar; % Display color bar to indicate efficiency values
colormap('spring'); % Use the 'parula' colormap
grid on;


maxeff=efficiencyMatrix(1,1);
for i=1:length(lengthRange)
    for j=1:length(lengthRange)
        if efficiencyMatrix(i,j)>maxeff
            maxeff=efficiencyMatrix(i,j)
         
        end
    end
end

for i=1:length(lengthRange)
    for j=1:length(lengthRange)
        if efficiencyMatrix(i,j)==maxeff
            disp(i);
            disp(j);
            break
        end
    end
end

lengthRange = linspace(0.005, 0.01, 20);
maxbre=lengthRange(j);
maxlen=lengthRange(i);



% Function to compute efficiency (you might need to define this or use appropriate methods)
function eff = computeEfficiency(antennaArray, frequency)
    % For demonstration, use a placeholder value
    % You should replace this with actual efficiency computation code
    %eff = efficiency(antennaArray,frequency) ;% Random efficiency value as placeholder
    eff=rand();
end
