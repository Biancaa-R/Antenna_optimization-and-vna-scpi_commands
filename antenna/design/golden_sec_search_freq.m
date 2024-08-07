clc;
clear all;
close all;

% Fixed length and width
len = 10^0.43; % Actual length value
bre = 10^0.67; % Actual width value

% Golden-Section Search parameters
tol = 1e-4; % Tolerance
gr = (sqrt(5) + 1) / 2; % Golden ratio

% Initial interval for frequency search
a = 1e9; % Lower bound
b = 3e9; % Upper bound

% Initial points
c = b - (b - a) / gr;
d = a + (b - a) / gr;

% Calculate efficiency at initial points
fc = calculate_efficiency(len, bre, c);
fd = calculate_efficiency(len, bre, d);
iterations = 0;
maxiter = 100;

while abs(c - d) > tol && iterations < maxiter
    if fc > fd
        b = d;
        d = c;
        c = b - (b - a) / gr;
        fd = fc;
        fc = calculate_efficiency(len, bre, c);
    else
        a = c;
        c = d;
        d = a + (b - a) / gr;
        fc = fd;
        fd = calculate_efficiency(len, bre, d);
    end
    iterations = iterations + 1;
    % Debug information
    disp(['Iteration: ', num2str(iterations)]);
    disp(['a: ', num2str(a), ', b: ', num2str(b)]);
    disp(['c: ', num2str(c), ', d: ', num2str(d)]);
    disp(['fc: ', num2str(fc), ', fd: ', num2str(fd)]);
    if iterations>maxiter
        break
    end
end

% Optimal frequency and efficiency
opt_frequency = (a + b) / 2;
opt_efficiency = calculate_efficiency(len, bre, opt_frequency);

% Display the optimized frequency and corresponding efficiency
disp(['Optimized Frequency: ', num2str(opt_frequency), ' Hz']);
disp(['Efficiency: ', num2str(opt_efficiency)]);

% Function to calculate the efficiency
function e = calculate_efficiency(len, bre, frequency)
    helement = patchMicrostrip;
    helement.Length = len; % Length of the patch
    helement.Width = bre;  % Width of the patch
    helement.FeedOffset = [0, 0]; % Center feed for simplicity
    helement.Conductor = metal('Copper'); % Set the conductor to Copper
    
    % Define the linear array using the patch element
    harray = linearArray;
    harray.Element = helement;
    
    % Calculate efficiency
    e = efficiency(harray, frequency);
end
