set pi to constant:pi.
set g0 to constant:g0.
set e to constant:e.
set inf to 10^30.
set eps to 1/inf.
set limit to { parameter l,h,u. return max(l,min(h,u)). }.
set ua to { parameter a. return choose 360-mod(-a,360) if a<0 else mod(a,360). }.
set sa to { parameter a. return ua(a+180)-180. }.
set vv to { parameter r1,r2,r3,mu.
return sqrt(max(0,2*mu*(1/r1-1/(r2+r3)))). }.
set burndv to { parameter r1,r2,r3,mu.
return vv(r1,r1,r3,mu)-vv(r1,r1,r2,mu). }.
set burndvh to { parameter h1,h2,h3,b.
local r0 is b:radius.
return burndv(r0+h1,r0+h2,r0+h3,b:mu). }.
set lefthand to { parameter u. return v(u:x,u:z,u:y). }.
