function [ var ] = ClockCorrections( a0,a1,a2,t,toc,deltarel )

var =a0+a1*(t-toc)+a2*(t-toc)^2+deltarel;
end

