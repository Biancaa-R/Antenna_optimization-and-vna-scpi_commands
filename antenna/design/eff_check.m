% Create a uniform linear array
lambda=0.3;
elementSpacing = 0.5*lambda;
array = phased.ULA('NumElements',8,'ElementSpacing',elementSpacing);

% Define frequency and angle
fc = 1e9; % 1 GHz
angle = [-180:1:180];
D=zeros(1,length(angle));

% Calculate directivity
for i =1:length(angle)
    D(i) = directivity(array, fc, angle(i));
end

% Plot directivity
polarplot(deg2rad(angle), db(D))
