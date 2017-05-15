function [Tsr] = hopfield(hr, e, md, mw)

%temperatura standardowa
p0 = 1013.25;
T0 = 291.15;
Rh0 = 50;
p = p0*(1-0.0000226*hr)^(5.225);
T = T0 - 0.0065*hr;
%Rh = Rh0*e^(-0.0006396*hr);
%e = 6.11*Rh * 10^(7.5*(T-273.15)/(T-35.85));
e = 0.5; % wilgotnosc wzgledna = 50%

hd = 40136 + 148.72*(T-273.16);
hw = 11000;
c1 = 77.64;
c2 = -12.96;
c3 = 3.718 * 10^5;

Nd0 = c1*p/T;
Nw0 = c2*e/T+c3*e/(T^2);

%ZTD = 10^(-6)/5*(Nd0*hd + Nw0*hw);

Tsr = 10^(-6)/5*(Nd0*hd*md + Nw0*hw*mw);