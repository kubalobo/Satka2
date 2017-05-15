function add = leapseconds(time)
 
if time>datetime(2015,7,1)
    add = 17;
elseif time>datetime(2012,7,1)
    add = 16;    
elseif time>datetime(2009,1,1)
    add = 15;
elseif time>datetime(2006,1,1)
    add = 14;
elseif time>datetime(1999,1,1)
    add = 13;
elseif time>datetime(1997,7,1)
    add = 12;   
elseif time>datetime(1996,1,1)
    add = 11;   
elseif time>datetime(1994,7,1)
    add = 10;    
elseif time>datetime(1993,7,1)
    add = 9;    
elseif time>datetime(1992,7,1)
    add = 8;    
elseif time>datetime(1991,1,1)
    add = 7;    
elseif time>datetime(1990,1,1)
    add = 6;
elseif time>datetime(1988,1,1)
    add = 5;    
elseif time>datetime(1985,7,1)
    add = 4;    
elseif time>datetime(1983,7,1)
    add = 3;   
elseif time>datetime(1982,7,1)
    add = 2;    
elseif time>datetime(1981,7,1)
    add = 1;          

end