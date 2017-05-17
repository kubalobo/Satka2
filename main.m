function [xyz, Xhat, wektor, sigmy] = main(jono, tropo, radioSelected, zegar, aber)

c = 299792458;

t = 518400;

% wsp. przyb. odbiornika
wspPrzyblizone = [5009051.3990 -42072.4720 3935057.5040];
% pseudoodleglosci z rinexu
odlRinex = [20279017.485; 25716551.950; 21875028.343; 23779959.609; 23259526.375; 21034103.473; 24265078.504; 20669965.650; 23270445.268; 22744417.506; 21962780.866];

[wspolrzedneSatelitow, efe] = rinexLoad(t);
%wspolrzedneSatelitow
efe(1,1);
efe(1,2);
% =============== WSZYSTKIE POPRAWKI ZAPISYWANE SA W ODDZIELNYCH ZMIENNYCH ==================

wspSatPop = zeros(11,3);
odlGeom = zeros(11,1);

% POPRAWKA r�znicy czasu i uk�adu | odlGeom - odleglosc na podstawie przyblizen
for i = 1:11
    [wspSatPop(i,:), tem, odlGeom(i)] = poprawka_pozycja(wspolrzedneSatelitow(i,:), efe(i,1), wspPrzyblizone);
end



% POPRAWKA JONOSFERYCZNA - KLOBUCHAR
%E - wysoko�� horyzontalna w p�okr�gachgach - podzielona przez 180st. - w
%stopniach
%A - azymut w stopniach
klobWyn = zeros(11, 1);
elew = zeros(11, 1);
for i = 1:11
    [A, E, z, phi, lambda] = elewacja(wspPrzyblizone, wspSatPop(i,:));

    if(jono)
        klobWyn(i) = klobuchar(deg2rad(E/180), deg2rad(A), phi, lambda, efe(i,1)); % t zamiast efe ?
    end
    elew(i) = E; % STOPNIE!
end

% POPRAWKA TROPOSFERYCZNA - HOPFIELD
%hr - wysokosc ortometryczna odbiornika
%e - wysokosc horyzontalna

hop1 = zeros(11, 1);
saas1 = zeros(11, 1);
hop2 = zeros(11,1);
saas2 = zeros(11, 1);

if(tropo)
    for i = 1:11
        md = 1/sin(sqrt(elew(i)^2+6.25));
        mw = 1/sin(sqrt(elew(i)^2+2.25));
        if(radioSelected == 1)
            hop1(i) = hopfield(0, deg2rad(elew(i)), md, mw);
        elseif(radioSelected == 2)
           saas1(i) = saastamoinen(md, mw, phi);
        end
    end

    % wariant 2 - mapowanie niella

    for i = 1:11
        [md, mw] = niell(21, wspPrzyblizone, deg2rad(elew(i)));
        if(radioSelected == 3)
            hop2(i) = hopfield(0, deg2rad(elew(i)), md, mw);
        elseif(radioSelected == 4)
            saas2(i) = saastamoinen(md, mw, phi);
        end
    end
end

% POPRAWKA zegara i relatywistyczna
clockCor = zeros(11,1);
timeAbber = zeros(11, 1);
for i = 1:11
    if(aber)
        timeAbber(i) = EccentricityTimeAbberration(efe(i, 11)^2, efe(i, 9), efe(i, 21)); 
    end
    if(zegar)
        clockCor(i) = ClockCorrections(efe(i, 2), efe(i, 3), efe(i, 4), t, tem, timeAbber(i)); %tu nie wiem, czy wszystko jest ok
    end
end


%odlRinex - odlGeom;

C = diag(1./sin(deg2rad(elew)).^2);
P = inv(C);

A = zeros(11,4);
l = zeros(4,1);

wspPrawdziwe = [5009051.058 -42071.954 3935057.894];


for i = 1:11
    A(i,1) = -(wspSatPop(i,1) - wspPrawdziwe(1))/odlGeom(i);
    A(i,2) = -(wspSatPop(i,2) - wspPrawdziwe(2))/odlGeom(i);
    A(i,3) = -(wspSatPop(i,3) - wspPrawdziwe(3))/odlGeom(i);
    A(i,4) = 1;
end


if(radioSelected == 1)
    tropo = hop1;
elseif(radioSelected == 2)
    tropo = saas1;
elseif(radioSelected == 3)
    tropo = hop2;
elseif(radioSelected == 4)
    tropo = saas2;
end

l = odlRinex - klobWyn - tropo + clockCor*c + timeAbber*c;


roznice = l - odlGeom;
P=P(elew>10,elew>10);
roznice=roznice(elew>10);
A = A(elew>10,:);
Xhat = (A'*P*A)\(A'*P*roznice);

wektor = sqrt((Xhat(1))^2 + (Xhat(2))^2 + (Xhat(3))^2);


xyz = wspPrawdziwe + Xhat(1:3)';

 vhat =  roznice-A*Xhat;
 varUnitWeight = (vhat'*P*vhat)./(11-4);
 Cx = varUnitWeight * inv(A'*P*A);
 sigX = sqrt(Cx(1,1));
 
 sigY = sqrt(Cx(2,2));
 sigZ = sqrt(Cx(3,3));

 sigmy = [sigX sigY sigZ];