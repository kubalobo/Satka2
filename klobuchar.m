function [IL1GPS] = klobuchar(E, A, phiU, lambdaU, tGPS)

%model Klobuchar

%dane

%wysokoœæ horyzontalna w pó³okrêgach - podzielona przez 180st. - w
%radianach
%E;

%azymut w radianach
%A;

%wspó³czynniki
alfa0 = 7.4506D-09; 
alfa1 = -1.4901D-08; 
alfa2 = -5.9605D-08;  
alfa3 = 1.1921D-07;       
beta0 = 8.8064D+04; 
beta1 = -4.9152D+04; 
beta2 = -1.9661D+05;  
beta3 = 3.2768D+05;

%obliczenie k¹ta geocentrycznego
psi = 0.0137/(E+0.11) - 0.022;

%oblicznie szerokoœci IPP
phiI = phiU + psi * cos(A);

if phiI>0.416
    phiI = 0.416;
elseif phiI<-0.416
        phiI = - 0.416;
end

%obliczanie d³ugoœci IPP
lambdaI = lambdaU + (psi*sin(A))/cos(phiI);

%obliczenie szerokoœci geomagnetycznej IPP
phim = phiI + 0.064*cos(lambdaI - 1.617);
%obliczanie czasu lokalnego dla IPP
t = 43200*lambdaI + tGPS;

if t>=86400
    t = t - 86400;
elseif t<0
    t = t +86400;
end

%oblicznie amplitudy opóŸnienia jonosferycznego
AI = alfa0*phim^0+alfa1*phim^1+alfa2*phim^2+alfa3*phim^3;

if AI<0
    AI = 0;
end

%obliczanie okresu opóŸnienia jonosferycznego 
PI = beta0*phim^0+beta1*phim^1+beta2*phim^2+beta3*phim^3;

if PI<72000
    PI = 72000;
end

%obliczenie fazy opóŸnienia jonosferycznego - radiany
XI = 2*pi*(t-50400)/PI;

%obliczenie wspó³czynnika ukoœnoœci 
F = 1.0+ 16.0*(0.53-E)^3;

%obliczenie opóŸnienia jonosferycznego 
if abs(XI)<=1.57
    IL1GPS = (5*10^(-9) + (alfa0*phim^0+alfa1*phim^1+alfa2*phim^2+alfa3*phim^3)*(1-XI^2/2+XI^4/24)) *F;
else
    IL1GPS = 5*10^(-9) * F;
end





