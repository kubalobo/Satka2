function sow = GPST(jd)
a = floor(jd+0.5);
b = a+1537;
c = floor((b-122.1)/365.25);
d = floor(365.25 * c);
e = floor((b-d)/30.6001);
D = b - d - floor(30.6001*e) + rem(jd+0.5,1);
DOW = rem(floor(jd+0.5),7);
week = floor((jd-2444244.5)/7);
sow = (rem(D,1) + DOW + 1)*86400;

end

