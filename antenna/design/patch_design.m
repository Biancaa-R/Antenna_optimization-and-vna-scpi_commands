% Define the microstrip patch antenna element
p = patchMicrostrip;
p.Height = 0.01; % Set the height of the substrate

% Plot the impedance over a range of frequencies
figure;
impedance(p, (5e8: 10e6 : 2e9)); % Frequency range from 0.5 GHz to 2 GHz

% Plot the current distribution at a specific frequency (1.66 GHz)
figure;
current(p, 1.66e9);

% Plot the radiation pattern at a specific frequency (1.66 GHz)
figure;
pattern(p, 1.66e9);

% Define another microstrip patch antenna element with different properties
helement = patchMicrostrip;
helement.Conductor = metal('Copper'); % Set the conductor to copper
helement.Length = 0.01; % Length of the patch (10 mm)
helement.Width = 0.01;  % Width of the patch (10 mm)

% Ensure the feed location is within the patch geometry
helement.FeedOffset = [0, 0]; % Center feed for simplicity, adjust if needed

% Define the linear array using the patch element
harray = linearArray;
harray.Element = helement;

% Calculate and display the efficiency at 1.5 GHz
frequency = 1.5e9; % 1.5 GHz
E = efficiency(harray,frequency);
disp(class(helement));
disp(class(harray));
disp(E);
