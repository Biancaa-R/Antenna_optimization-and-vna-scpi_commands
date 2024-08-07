clear all; 
close all;
clc;

% Define the parameters
mu = 0.001;           % Step size
W0 = [0.999];        % Desired weights
L = length(W0);      % Filter length
input = [0.01, 0.01]; % Input vector with 2 elements
N = length(input);   % Number of input samples

% Initialize matrices and variables
x = zeros(L, 1);     % Input buffer
w = zeros(L, 2);     % Weight matrix (L x 2)
y = zeros(2, 1);     % Output matrix (2 x 1)
MSE = zeros(N, 1);   % Mean Squared Error vector (1 x N)
e = zeros(2, 1);     % Error matrix (2 x 1)
d = [0.999; 0.999]; % Desired output matrix (2 x 1)

% Adaptive filtering process
for m = 1:100
    % Reset buffers
    x(:) = 0;
    w(:) = 0;
    
    % Adaptive filtering loop
    for n = 1:N
        % Update input buffer
        x(2:L, 1) = x(1:L-1, 1);
        x(1) = input(n);
        
        % Desired signal (fixed)

        
        % Output calculation with 2 x 1 matrix
        y = w.' * x+mu; % Compute output as 2 x 1 matrix
        
        % Compute error
        e = d - y; % Error as 2 x 1 matrix
        MSE(n) = norm(e).^2; % Mean Squared Error (scalar)
        
        % Update weights
        w = w + mu * (x * e.');
    end
    
    % Plot MSE for the first iteration
    if m == 1
        figure;
        mse_db = 10 * log10(MSE);
        plot(mse_db);
        title('MSE in dB');
        xlabel('Iteration');
        ylabel('MSE (dB)');
    end

    % Store MSE values
    MSE1(:, m) = MSE; % Store MSE values
end

% Compute average MSE
for i = 1:N
    MSE2(i) = mean(MSE1(i, :));
end

% Plot average MSE
figure;
mse_db = 10 * log10(MSE2);
plot(mse_db);
title('Average MSE in dB');
xlabel('Iteration');
ylabel('MSE (dB)');
