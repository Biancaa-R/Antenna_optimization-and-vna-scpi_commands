% Define the frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define the metal type for optimization (e.g., 'Copper')
metalType = 'Copper';

% Set initial guess for dimensions [length, width]
initialGuess = [0.01, 0.01]; % Example initial dimensions (10 mm x 10 mm)

% Define bounds for the dimensions
lb = [0.005, 0.005]; % Lower bounds (5 mm x 5 mm)
ub = [0.02, 0.02];  % Upper bounds (20 mm x 20 mm)

% Set options for the optimization algorithm
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'interior-point');

% Perform optimization
[optimalDimensions, optimalPerformance] = fmincon(@(x)objectiveFunction(x, metalType, frequency), initialGuess, [], [], [], [], lb, ub, [], options);

% Display the optimal dimensions and performance
disp('Optimal Dimensions (Length, Width):');
disp(optimalDimensions);
disp('Optimal Efficiency:');
disp(-optimalPerformance);

% Objective function to maximize efficiency
function performance = objectiveFunction(dimensions, metalType, frequency)
    % Create the microstrip patch antenna element with given dimensions
    helement = patchMicrostrip;
    helement.Conductor = metal(metalType); % Set the conductor based on metalType
    helement.Length = dimensions(1); % Length of the patch
    helement.Width = dimensions(2);  % Width of the patch
    helement.FeedOffset = [0, 0]; % Center feed for simplicity
    
    % Define the linear array using the patch element
    harray = linearArray;
    harray.Element = helement;
    
    % Calculate efficiency
    performance = efficiency(harray, frequency);
    
    % To maximize efficiency, return the negative value (minimization problem)
    performance = -performance;
end
