function [rSodb, tem, roRS] = poprawka_pozycja(wspSatelity, todb, wspPrzyblizone)

%todb - czas odbioru
%roRS - odleglosc odbiornik - satelita


c = 299792458;
omegaE = 7.2921151467 * 10^(-5);

roRS = sqrt((wspSatelity(1)-wspPrzyblizone(1))^2 + (wspSatelity(2)-wspPrzyblizone(2))^2 + (wspSatelity(3)-wspPrzyblizone(3))^2);

%czas propagacji sygnalu 
tauSR = roRS/c;

%czas emisji
tem = todb - tauSR;

%transformacja ukladu z momentu emisji do ukladu z momentu odbioru 

%polozenie - moment emisji
rSem = wspSatelity;

%macierz obrotu wokol osi Z
alfa = omegaE * tauSR;
Rs = [ cos(alfa) sin(alfa) 0;
       -sin(alfa) cos(alfa) 0;
       0 0 1];
%polozenie - moment odbioru
rSodb = Rs * rSem';

