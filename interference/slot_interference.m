%model shielding enclosures and analyze electromagnetic interference from slots or apertures in the enclosure excited by the interior sources. Enclosure and the interior source is modeled using custom 3-D shapes and performance is evaluated at a particular distance away from the setup. 
% The integrity of shielding enclosures for high-speed digital designs is compromised by slots and apertures for heat dissipation,
% CD-ROMs, input/output (I/O) cable penetration, and plate-covered unused connector ports among other possibilities. 

enclosureLength = 220e-3;
enclosureWidth = 300e-3;
enclosureHeight = 140e-3;
slotLength = 2e-3;
slotWidth = 120e-3;

box = shape.Box(Length=enclosureLength, Width=enclosureWidth, Height=enclosureHeight);

slot = shape.Box(Length=enclosureLength/2, Width=slotWidth, Height=slotLength, Color="r");
box.Transparency = 0.3;
[~] = translate(slot,[enclosureLength/2 0 -50e-3]);
boxEnclosure = box - slot;
[~] = translate(boxEnclosure,[0 0 40e-3]);
show(boxEnclosure);

feed = shape.Circle(Radius=0.8e-3, Center=[0.05 0], NumPoints=20, Color="r");
[~] = translate(feed,[0 0 -0.11]);
[~] = rotateY(boxEnclosure,180);
antShape = extrude(boxEnclosure,feed,Height=0.12);
[~] = rotateY(antShape,180);
show(antShape)


ant = customAntenna(Shape=antShape);
[~] = createFeed(ant,[-0.05 0 0.11],20);
show(ant);


[E,H] = EHfields(ant,linspace(0.7e9,1.6e9,100),[3 0 0]');
%Calculate the E-field magnitude.

Et = abs(E);
Et = sqrt(Et(1,:).^2+Et(2,:).^2+Et(3,:).^2);

plot(linspace(0.7e9,1.6e9,100),10*log10(Et./1e-6));
xlabel("Frequency(Hz)");
ylabel("|E|dBuV/m");