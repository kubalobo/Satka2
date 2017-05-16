function [xyz, Xhat] = main(jono, tropo, radioSelected, zegar, aber)
radioSelected
c = 299792458;

t = 518400;

% wsp. przyb. odbiornika
wspPrzyblizone = [5009051.3990 -42072.4720 3935057.5040];
% pseudoodleglosci z rinexu
odlRinex = [20279017.485; 25716551.950; 21875028.343; 23779959.609; 23259526.375; 21034103.473; 24265078.504; 20669965.650; 23270445.268; 22744417.506; 21962780.866];

[wspolrzedneSatelitow, efe] = rinexLoad(t);
%wspolrzedneSatelitow

% =============== WSZYSTKIE POPRAWKI ZAPISYWANE SA W ODDZIELNYCH ZMIENNYCH ==================

wspSatPop = zeros(11,3);
odlGeom = zeros(11,1);

% POPRAWKA r�znicy czasu i uk�adu | odlGeom - odleglosc na podstawie przyblizen
for i = 1:11
    [wspSatPop(i,:), tem, odlGeom(i)] = poprawka_pozycja(wspolrzedneSatelitow(i,:), t, wspPrzyblizone);
end



% POPRAWKA JONOSFERYCZNA - KLOBUCHAR
%E - wysoko�� horyzontalna w p�okr�gachgach - podzielona przez 180st. - w radianach
%A - azymut w radianach
klobWyn = zeros(11, 1);
elew = zeros(11, 1);
for i = 1:11
    [A, E, z, phi, lambda] = elewacja(wspPrzyblizone, wspSatPop(i,:));
    
    if(jono)
        klobWyn(i) = klobuchar(deg2rad(E), deg2rad(A), phi, lambda, t);
    end
    elew(i) = E; % STOPNIE!
end

% POPRAWKA TROPOSFERYCZNA - HOPFIELD
%hr - wysoko�� ortometryczna odbiornika
%e - wysoko�� horyzontalna

e = 0.5; % wilgotnosc wzgledna = 50%

md = 1/sin(sqrt(e^2+6.25));
mw = 1/sin(sqrt(e^2+2.25));
hop1 = zeros(11, 1);
saas1 = zeros(11, 1);
hop2 = zeros(11,1);
saas2 = zeros(11, 1);

if(tropo)
    for i = 1:11
        if(radioSelected == 1)
            hop1(i) = hopfield(0, deg2rad(elew(i)), md, mw);
        elseif(radioSelected == 2)
            saas1(i) = saastamoinen(md, mw, phi, t);
        end
    end

    % wariant 2 - mapowanie niella

    for i = 1:11
        [md, mw] = niell(21, wspPrzyblizone, deg2rad(elew(i)));
        if(radioSelected == 3)
            hop2(i) = hopfield(0, elew(i), md, mw);
        elseif(radioSelected == 4)
            saas2(i) = saastamoinen(md, mw, phi, t);
        end
    end
end

% POPRAWKA zegara i relatywistyczna
clockCor = zeros(11,1);
timeAbber = zeros(11, 1);
for i = 1:11
    if(zegar)
        clockCor(i) = ClockCorrections(efe(i, 2), efe(i, 3), efe(i, 4), t, efe(i, 1), efe(i, 6)); %ostatnie to deltarel - ???
    end
    if(aber)
        timeAbber(i) = EccentricityTimeAbberration(efe(i, 11)^2, efe(i, 9), efe(i, 21)); 
    end
end


%odlRinex - odlGeom;

C = diag(1./sin(deg2rad(elew)).^2);
P = inv(C);

A = zeros(11,4);
l = zeros(4,1);

for i = 1:11
    A(i,1) = -(wspSatPop(i,1) - wspPrzyblizone(1))/odlGeom(i);
    A(i,2) = -(wspSatPop(i,2) - wspPrzyblizone(2))/odlGeom(i);
    A(i,3) = -(wspSatPop(i,3) - wspPrzyblizone(3))/odlGeom(i);
    A(i,4) = 1;
    l(i) = odlRinex(i) + klobWyn(i) + hop1(i) - clockCor(i)- timeAbber(i);
end




roznice = l - odlGeom;

Xhat = (A'*P*A)\(A'*P*roznice);

xyz = wspPrzyblizone + Xhat(1:3)';

% Jeszcze brakuje koncowego wyliczenia wspolrzednych i chyba tych dziwnych sigm