function [md,mw]=niell(t0,xyz,el)
% niell - Niell Mapping Function for calculating tropospheric delay
% Input:
% t0 .......... observation DOY converted by datenum
% xyz ......... WGS-84 ECEF approximate coordinates of the receiver
% el .......... elevation of the SV in radians
% Output:
% md .......... mapping coefficient for dry component
% mw .......... mapping coefficient for wet component

% empirical values
D=[1.2769934e-3, 1.2683230e-3, 1.2465397e-3, 1.2196049e-3, 1.2045996e-3;...
   2.9153695e-3, 2.9152299e-3, 2.9288445e-3, 2.9022565e-3, 2.9024912e-3;...
   62.610505e-3, 62.837393e-3, 63.721774e-3, 63.824265e-3, 64.258455e-3;...
   0.0, 1.2709626e-5, 2.6523662e-5, 3.4000452e-5, 4.1202191e-5;...
   0.0, 2.1414979e-5, 3.0160779e-5, 7.2562722e-5, 11.723375e-5;...
   0.0, 9.0128400e-5, 4.3497037e-5, 84.795348e-5, 170.37206e-5;];

W=[5.8021897e-4, 5.6794847e-4, 5.8118019e-4, 5.9727542e-4, 6.1641693e-4;...
   1.4275268e-3, 1.5138625e-3, 1.4572752e-3, 1.5007428e-3, 1.7599082e-3;...
   4.3472961e-2, 4.6729510e-2, 4.3908931e-2, 4.4626982e-2, 5.4736038e-2;];

aht=2.53e-5; bht=5.49e-3; cht=1.14e-3;

% calculating ellipsoidal coordinates
[fi,~,he]=hirvonen(xyz(1),xyz(2),xyz(3),1);
% considering geoid height
h=he-34.5;

% different reference day on both hemispheres: DOY 28 on N, DOY 211 on S
if fi >= 0
    T=datenum(str2num(datestr(t0,10)),1,28);
else
    T = datenum(str2num(datestr(t0,10)),1,1)+210;
end

% interpolation for values between 15 and 75 deg, otherwise - values from
% the table, no extrapolation
x =[15 30 45 60 75];
if abs(fi) > deg2rad(15) && abs(fi) < deg2rad(75)
    Add = interp1(x,D',abs(fi));
    Ad = Add(1:3)' - Add(4:6)'*cos((t0-T)*2*pi/365.25);
    Aw = interp1(x,W',abs(fi))';
elseif abs(fi) <= deg2rad(15)
    Ad = D(1:3,1);
    Aw = W(1:3,1);
else 
    Ad = D(1:3,5) - D(4:6,5)*cos((t0-T)*2*pi/365.25);
    Aw = W(1:3,5);
end

% height correction for dry component
mh=h*((1/sin(el))-map(aht,bht,cht,el))/1000;
% Marini mapping
md=map(Ad(1),Ad(2),Ad(3),el)+mh;
mw=map(Aw(1),Aw(2),Aw(3),el);
end

function m=map(a,b,c,el)
% map - Marini mapping
m=(1+(a/(1+(b/(1+c)))))/(sin(el)+(a/(sin(el)+(b/(sin(el)+c))))); 
end

function[B1,L1,H1]=hirvonen(X,Y,Z,el)
% hirvonen - computing lat[deg], lon[deg] & ellipsoidal height [meters]
% from geocentric X,Y,Z coordinates in meters by the method of Hirvonen
% input:
% X, Y, Z ......... geocentric orthocartesian coordinates in meters;
% el .............. parameters of reference ellipsoid - semimajor axis and 
%                   eccentricity squared:
%                   el = 1 : GRS 80 ellipsoid
%                   el = 2 : Krassovsky ellipsoid
% output:
% B1 .............. latitude in degrees
% L1 .............. longitude in degrees
% H1 .............. ellipsoidal height in meters
format long;

% definition of ellipsoid
if el==1
    a = 6378137;
    e2 = 0.00669438002290;
elseif el==2
    a = 6378245;
    e2 = 0.00669342162297;
end

r = (X^2+Y^2)^(0.5);
B=atan2(Z,(r*(1-e2)));
B0=1;
while abs(B-B0)>(0.000001/206265) 
   N = a/((1-e2*(sin(B0))^2)^(0.5));
   H = (r/cos(B0))-N;
   B0=B;
   B = atan2(Z,(r*(1-(e2*(N/(N+H))))));
end;

B1 = rad2deg(B);
L1 = atan2(Y,X)*180/pi;
N1 = a/(1-e2*(sin(deg2rad(B1)))^2)^(0.5);
H1 = (r/cos(deg2rad(B1)))-N1;
end