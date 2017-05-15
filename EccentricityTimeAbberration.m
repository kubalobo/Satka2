function [ EccenCorr ] = EccentricityTimeAbberration(a, e, ek)
C = 299792458;
mi = 3.986005 * 10 ^ 14;

EccenCorr=-2*sqrt(mi*a)/(C^2)*e*sin(ek);   %ek to iteracyjnie wyznaczona anomalia mimosrodowa, a e to mimosrod orbity
end

