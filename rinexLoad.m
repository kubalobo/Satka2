function [mac, efemerydy] = rinexLoad(t)

format longg;

filePath = 'rinex.rnx';
file  = fopen (filePath);

%Loading variables 
%Specials: delta, sqrt, omega(duza), om(mala), omegaPrim, sigma
mac = zeros(11,3);
efemerydy = zeros(11,21);

for i = 1:11
    line1 = fgetl(file);
    %Read time
            year = str2double(line1(5:8));
            month = str2double(line1(10:11));
            day = str2double(line1(13:14));
            hour = str2double(line1(16:17));
            minute = str2double(line1(19:20));
            second = str2double(line1(22:23));
            %time = datetime(year, month, day, hour, minute, second);
            timejd=julday(year, month, day, hour, minute, second);
            timeGPS = GPST(timejd); %1
            %[tow,gpsWeek]=Date2GPSTime(time(1),time(2),time(3),time(4)+time(5)/60+time(6)/3600); %Transform date to seconds of week

            a0 = str2num(line1(24:42)); %2
            a1 = str2num(line1(43:61)); %3
            a2 = str2num(line1(62:80)); %4

    line2 = fgetl(file);
        IODE = str2num(line2(5:23));
        Crs = str2num(line2(24:42)); %5
        deltan = str2num(line2(43:61)); %6
        M0 = str2num(line2(62:80)); %7

    line3 = fgetl(file);
        Cuc = str2num(line3(5:23)); %8
        e = str2num(line3(24:42)); %9
        Cus= str2num(line3(43:61)); %10
        sqrta = str2num(line3(62:80)); %11

    line4 = fgetl(file);
        toe= str2num(line4(5:23)); %12
        Cic = str2num(line4(24:42)); %13
        omega0= str2num(line4(43:61)); %14
        Cis = str2num(line4(62:80)); %15

    line5 = fgetl(file);
        i0= str2num(line5(5:23)); %16
        Crc = str2num(line5(24:42)); %17
        om = str2num(line5(43:61)); %18
        omegaPrim = str2num(line5(62:80)); %19

    line6 = fgetl(file);
        IDOT = str2num(line6(5:23)); %20
    line7 = fgetl(file);
    line8 = fgetl(file);

    
        
    % Constants
    mi = 3.986005 * 10 ^ 14;
    ome = 7.2921151467 * 10 ^ -5;

    % Alghoritm - position
    sigmat = a0 + a1 * (t - toe) + a2 * (t - toe) ^ 2;
    tk = t - sigmat - toe;
    a = sqrta ^ 2;
    n0 = sqrt(mi / a^3);
    n = n0 + deltan;
    Mk = M0 + n * tk;

    Ek = Mk;
    dE = 1;

    while(abs(dE) > 0.1*10^-12) %???
        Epop = Ek;
        Ek = Mk + e * sin(Epop); %21
        dE = rem(Ek-Epop, 2*pi);
    end

    Vk = 2 * atan(sqrt((1+e)/(1-e)) * tan(Ek / 2));
    u = om + Vk;
    sigmauk = Cus * sin(2 * u) + Cuc * cos(2 * u);
    sigmark = Crs * sin(2 * u) + Crc * cos(2 * u);
    sigmaik = Cis * sin(2 * u) + Cic * cos(2 * u) + IDOT * tk;
    uk = u + sigmauk;
    rk = a * (1 - e * cos(Ek)) + sigmark;
    ik = i0 + sigmaik;
    omegak = omega0 + (omegaPrim - ome) * tk - ome * toe;
    xprim = rk * cos(uk);
    yprim = rk * sin(uk);

    x = xprim * cos(omegak) - yprim * cos(ik) * sin(omegak);
    y = xprim * sin(omegak) + yprim * cos(ik) * cos(omegak);
    z = yprim * sin(ik);

    mac(i,:) = [x y z];

    efemerydy(i,:) = [timeGPS a0 a1 a2 Crs deltan M0 Cuc e Cus sqrta toe Cic omega0 Cis i0 Crc om omegaPrim IDOT Ek];
end
