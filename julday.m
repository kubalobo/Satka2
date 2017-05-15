function jd = julday(y,m,d,h,min,s) 
% JULDAY Conversion of date to Julian Day 
% input y ... year (four digits ) 
% m ... month % d ... day 
% h ... hour and fraction hereof 
% output jd ... Julian Day in days 
% The conversion is only valid in the time span 
% from March, 1, 1900 to February , 28, 2100
% For further information see 
% Meeus, Jean (1998) Astronomical Algorithms , Second English Edition 
% Willmann?Bell , Inc. , Richmond, Virginia , p. 60??61

if m <= 2, y = y-1; m = m+12; end 

% if the date is in January or February , it ’s considered to be in the 13th 
% or 14th month of the preceding year 

jd = floor (365.25*(y+4716))+floor(30.6001*(m+1))+d+h/24+min/(24*60)+s/(24*60*60)-1537.5;


