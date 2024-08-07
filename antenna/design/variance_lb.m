clc;
clear all;
close all;

len=-1:4;
bre=-1:4;

efficiencyMatrix=NaN(length(len),length(bre));

for i=1:length(len)
    for j=1:length(bre)
        frequency=1.5e9;
        helement = patchMicrostrip;
        helement.Length = power(10,len(i)); % Length of the patch
        helement.Width = power(10,bre(i));  % Width of the patch
        helement.FeedOffset = [0, 0]; % Center feed for simplicity
        helement.Conductor = metal('Copper'); % Set the conductor to Copper
        
        % Define the linear array using the patch element
        harray = linearArray;
        harray.Element = helement;
        
        % Calculate efficiency
        e = efficiency(harray, frequency);
        disp(e);
        
        
    end
end
