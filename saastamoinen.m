function [Tsr] = saastamoinen(md, mw, phi, t)

%wysoko�� elipsoidalna
H = 0;
%szeroko�� geodezyjna
%phi;

%wysoko�� ortometryczna odbiornika
hr = 0;
%atmosfera standardowa
p0 = 1013.25;
T0 = 291.15;
Rh0 = 0.50;

p = p0*(1-0.0000226*hr)^(5.225);
T = T0 - 0.0065*hr;

%Rh = Rh0*e^(-0.0006396*hr);
%e = 6.11*Rh * 10^(7.5*(T-273.15)/(T-35.85));
e = 0.5; % wilgotnosc wzgledna = 50%

%warto�� refrakcji troposferycznej w kierunku zenitu - sucha
ZTDd = 0.0022767*p/(1-0.00266*cos(2*phi)-0.00000028*H);
%warto�� refrakcji troposferycznej w kierunku zenitu - mokra
ZTDw = 0.0022767*e/(1-0.00266*cos(2*phi)-0.00000028*H)*(1225/t + 0.05);


Tsr = ZTDd*md + ZTDw*mw;