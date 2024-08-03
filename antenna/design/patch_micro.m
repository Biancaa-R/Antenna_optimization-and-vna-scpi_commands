% Define the frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define the metals to be used
metals1 = {'Copper', 'Silver', 'Gold', 'Steel','Aluminium'}; % Removed 'Aluminum' due to potential unsupported error

% Initialize array to store efficiency values
efficiencies = zeros(1, length(metals1));

% Create a figure for plotting
figure;
hold on;

% Loop through each metal type
for x = 1:length(metals1)
    metalType = metals1{x}; % Correctly access cell array element
    
    % Create the microstrip patch antenna element
    helement = patchMicrostrip;
    
    % Set the conductor based on predefined options
    switch metalType
        case 'Copper'
            helement.Conductor = metal('Copper'); % Set the conductor to Copper
        case 'Silver'
            helement.Conductor = metal('Silver'); % Set the conductor to Silver
        case 'Gold'
            helement.Conductor = metal('Gold'); % Set the conductor to Gold
        case 'Steel'
            helement.Conductor = metal('Steel'); % Set the conductor to Steel
        case 'Aluminium'
            helement.Conductor = metal('Aluminium'); % Set the conductor to Steel
        otherwise
            error('Unsupported metal type: %s', metalType);
    end
    
    helement.Length = 0.01; % Length of the patch (10 mm)
    helement.Width = 0.01;  % Width of the patch (10 mm)
    helement.FeedOffset = [0, 0]; % Center feed for simplicity, adjust if needed
    
    % Define the linear array using the patch element
    harray = linearArray;
    harray.Element = helement;
    
    % Calculate efficiency
    E = efficiency(harray, frequency);
    
    % Store efficiency values
    efficiencies(x) = E;
end

% Plot efficiencies
stem(1:length(metals1), efficiencies, 'b','filled');
xticks(1:length(metals1));
xticklabels(metals1);
xlabel('Metal Type');
ylabel('Efficiency');
title('Efficiency of Microstrip Patch Antenna for Different Metals');
grid on;
hold off;

% Display efficiencies
disp('Efficiency values for different metals:');
for x = 1:length(metals1)
    fprintf('%s: %.4f\n', metals1{x}, efficiencies(x));
end

%therefore copper has highest efficiency:
% Define the microstrip patch antenna element
helement = patchMicrostrip;
helement.Conductor = metal('Copper');
helement.Length = 0.01; % 10 mm
helement.Width = 0.01;  % 10 mm

% Define the linear array using the patch element
harray = linearArray;
harray.Element = helement;

% Calculate the efficiency at 1.5 GHz
frequency = 1.5e9; % 1.5 GHz
E = efficiency(harray, frequency);
disp(E);
