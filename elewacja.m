function [alfa, elew, z, phi, lambda] = elewacja(wspPrzyblizone, wspSat)

%wspó³rzêdne obserwatora wzglêdem uk³adu GRS80
xo = wspPrzyblizone(1);
yo = wspPrzyblizone(2);
zo = wspPrzyblizone(3);

wgs84 = wgs84Ellipsoid('meters');
[phi,lambda,h] = ecef2geodetic(wgs84,xo,yo,zo);

phi = deg2rad(phi);
lambda = deg2rad(lambda);

R = [-sin(phi)*cos(lambda) -sin(lambda) cos(phi)*cos(lambda);
     -sin(phi)*sin(lambda) cos(lambda) cos(phi)*sin(lambda);
      cos(phi) 0 sin(phi)];
 
%wspó³rzêdne satelity
xs = wspSat(1);
ys = wspSat(2);
zs = wspSat(3);

Xt = xs - xo;
    
Yt = ys - yo;
    
Zt = zs - zo;

Xij = [Xt;Yt;Zt];

xij = R'*Xij;
    
n = xij(1);
e = xij(2);
u = xij(3);

%azymut w stopniach
alfa = atan2d(e,n);

%zenit w stopniach
z = acosd(u/sqrt(n^2 + e^2 + u^2));

%elewacja w stopniach
elew = 90 - z;

