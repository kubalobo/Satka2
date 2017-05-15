function [rSodb, tem, roRS] = poprawka_pozycja(wspSatelity, todb, wspPrzyblizone)

%todb - czas odbioru
%roRS - odleglosc odbiornik - satelita

wspSatelity;
wspPrzyblizone;

c = 299792458;
omegaE = 7.2921151467 * 10^(-5);

roRS = sqrt((wspSatelity(1)-wspPrzyblizone(1))^2 + (wspSatelity(2)-wspPrzyblizone(2))^2 + (wspSatelity(3)-wspPrzyblizone(3))^2);

%czas propagacji sygna�u 
tauSR = roRS/c;

%czas emisji
tem = todb -tauSR;

%transformacja uk�adu z momentu emisji do uk�adu z momentu odbioru 

%polozenie - moment emisji
rSem = wspSatelity;

%macierz obrotu wok� osi Z
alfa = omegaE * tauSR;
Rs = [ cos(alfa) sin(alfa) 0;
       -sin(alfa) cos(alfa) 0;
       0 0 1];
%polozenie - moment odbioru
rSodb = Rs * rSem';

