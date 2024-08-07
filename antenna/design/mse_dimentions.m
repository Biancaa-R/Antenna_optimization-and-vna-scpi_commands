clear; 
close all;
clc;

% Define the parameters
mu = 0.001;           % Step size
W0 = [0.01; 0.01]; % Desired weights (adjusted to match the desired output dimension)
L = length(W0);      % Filter length
input = [1, 0.01]; % Input vector with 2 elements
N = length(input);   % Number of input samples

% Initialize matrices and variables
x = zeros(L, 1);     % Input buffer
w = rand(L, 1);      % Weight vector (L x 1) - initialize to random values
y = zeros(L, 1);     % Output vector (L x 1)
MSE = zeros(N, 1);   % Mean Squared Error vector (1 x N)
e = zeros(L, 1);     % Error vector (L x 1)
d = [0.01; 0.01]; % Desired output vector (L x 1)
noise = randn(N, 1) * 0.01; % Generate noise for the simulation

% Adaptive filtering process
for m = 1:1000
    % Reset input buffer
    x(:) = 0;
    
    % Adaptive filtering loop
    for n = 1:N
        % Update input buffer
        x(2:L, 1) = x(1:L-1, 1);
        x(1) = input(n);
        
        % Desired signal
        d = W0.' * x;
        
        % Output calculation with noise
        y = w.' * x + noise(n);
        
        % Compute error
        e(n) = d - y;
        MSE(n) = e(n)^2; % Mean Squared Error (scalar)
        
        % Update weights
        w = w + mu * x * e(n);
    end
    
    % Plot MSE for the first iteration
    if m == 1
        figure;
        mse_db = 10 * log10(MSE);
        plot(mse_db);
        title('MSE in dB');
        xlabel('Sample Index');
        ylabel('MSE (dB)');
    end

    % Store MSE values
    MSE1(:, m) = MSE; % Store MSE values
end

% Compute average MSE
MSE2 = mean(MSE1, 2);

% Plot average MSE
figure;
mse_db = 10 * log10(MSE2);
plot(mse_db);
title('Average MSE in dB');
xlabel('Sample Index');
ylabel('MSE (dB)');

% Display final weights and output
disp('Final Weights:');
disp(w);

disp('Output for given input:');
x_final = [input(1); input(2)]; % Example final input
y_final = w.' * x_final;
disp(y_final);
