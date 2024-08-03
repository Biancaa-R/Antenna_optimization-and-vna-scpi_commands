clear all;
close all;
clc;

% Define the frequency for analysis
frequency = 1.5e9; % 1.5 GHz

% Define the initial guess for dimensions [length, width, height, dielectric constant]
initialDimensions = [0.02, 0.02, 0.0016, 4.4]; % Example initial dimensions (20 mm x 20 mm, 1.6 mm height, dielectric constant 4.4)

% Define bounds for the dimensions
lb = [0.01, 0.01, 0.001, 2]; % Lower bounds (10 mm x 10 mm, 1 mm height, dielectric constant 2)
ub = [0.03, 0.03, 0.003, 10]; % Upper bounds (30 mm x 30 mm, 3 mm height, dielectric constant 10)

% Define the objective function for optimization
objectiveFunction = @(dimensions) -computeDirectivity(dimensions, frequency);

% Optimize using Nelder-Mead Simplex method
options = optimset('Display', 'iter', 'TolX', 1e-6, 'TolFun', 1e-6);
[optimalDimensions, optimalPerformance] = fminsearch(objectiveFunction, initialDimensions, options);

% Display the optimal dimensions and performance
disp('Optimal Dimensions (Length, Width, Height, Dielectric Constant):');
disp(optimalDimensions);
disp('Optimal Directivity:');
disp(-optimalPerformance);

% Function to compute the directivity
function performance = computeDirectivity(dimensions, frequency)
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
    helement.Height = dimensions(3); % Height of the substrate
    helement.Substrate = dielectric('FR4');
    helement.Substrate.EpsilonR = dimensions(4); % Dielectric constant
    helement.FeedOffset = [0, 0]; % Center feed
    
    % Define the linear array
    harray = linearArray;
    harray.Element = helement;
    
    % Analyze the antenna
    try
        % Calculate the directivity at the specified frequency
        patternData = pattern(harray, frequency, 0, 0); % Directivity at broadside (0 degrees azimuth, 0 degrees elevation)
        performance = max(patternData); % Maximize the directivity
    catch ME
        disp('Error during directivity calculation:');
        disp(ME.message);
        performance = NaN;
    end
end
