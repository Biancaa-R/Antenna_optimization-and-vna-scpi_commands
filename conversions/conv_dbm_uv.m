% Number of data points
n = 1000;

% Generate random data for x and y
x = rand(1, n);
y=rand(1,n)+5;

x1=zeros(1,n);
y1=zeros(1,n);
% Create a scatter plot
figure
plot(x);
hold on;
plot(y);
hold off;
title('Random Graph');
xlabel('X-axis');
ylabel('Y-axis');

%dBm = dBmicV - 10log10 (Z) + 90
for i=1:1000
    x1(i)=x(i)-10*log10(50)+90;
    y1(i)=y(i)-10*log10(50)+90;
end
figure
plot(x1,'b');
hold on;
plot(y1,'r');
hold off;
title('Random Graph');
xlabel('X-axis');
ylabel('Y-axis');
