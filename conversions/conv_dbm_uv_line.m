% Number of data points
n = 1000;

% Generate random data for x
x = (10e-3:-10e-6:10e-6);

x1 = zeros(1, n);
y1 = zeros(1, n);

% Create a scatter plot
figure;
plot(x);
hold on;

hold off;
title('dB mic V');
xlabel('X-axis');
ylabel('Y-axis');

% Convert to dBm
for i = 1:length(x)
    x1(i) = x(i) - 10*log10(50) + 90;
end

figure;
plot(x1, 'b');
hold on;
hold off;
title('dBm');
xlabel('X-axis');
ylabel('Y-axis');
