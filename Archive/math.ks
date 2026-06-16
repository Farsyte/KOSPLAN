set pi to constant:pi.
set g0 to constant:g0.
set e to constant:e.
set inf to 10^30.
set eps to 1/inf.
set limit to { parameter l,h,u. return max(l,min(h,u)). }.
set visviva to { parameter r1,r2,r3,mu.
return sqrt(max(0,2*mu*(1/r1 - 1/(r2+r3)))). }.
