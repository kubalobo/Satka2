function [Tsr] = saastamoinen(md, mw, phi)

%wysokosc elipsoidalna
H = 0;
%szerokosc geodezyjna
%phi;

%wysokosc ortometryczna odbiornika
hr = 0;
%atmosfera standardowa
p0 = 1013.25;
T0 = 291.15;
% wilgotnosc wzgledna = 50%
Rh0 = 0.50;

p = p0*(1-0.0000226*hr)^(5.225);
T = T0 - 0.0065*hr;

%Rh = Rh0*e^(-0.0006396*hr);

e = 6.11*Rh0 * 10^(7.5*(T-273.15)/(T-35.85));


%wartosc refrakcji troposferycznej w kierunku zenitu - sucha
ZTDd = 0.0022767*p/(1-0.00266*cos(2*phi)-0.00000028*H);
%wartosc refrakcji troposferycznej w kierunku zenitu - mokra
ZTDw = 0.0022767*e/(1-0.00266*cos(2*phi)-0.00000028*H)*(1225/T + 0.05);


Tsr = ZTDd*md + ZTDw*mw;