import("burndv").
set mnpro to {
parameter t.
parameter h.
local mu is body:mu.
local r0 is body:radius.
local r1 is posat(t,ship).
local v1 is velat(t,ship).
local vr is vdot(v1,r1:normalized).
local dp is burndv(r1:mag,r0*2+apoapsis+periapsis-r1:mag,r0+h,mu).
return node(t,-vr,0,dp). }.
set mnatp to { parameter des_apo. return {
mnclr().
if eta:periapsis<0 return mpinc().
local mnv is mnpro(time:seconds+eta:periapsis,des_apo).
if bt(mnv:prograde)>1/1000 add mnv.
return mpinc(1/50).}.}.
set mnata to { parameter des_peri. return {
mnclr().
if apoapsis<0 return mpinc().
local mnv is mnpro(time:seconds+eta:apoapsis,des_peri).
if bt(mnv:prograde)>1/1000 add mnv.
return mpinc(1/50).}.}.
set mncirc to {
mnclr().
local tp is eta:periapsis. if tp<0 return mpinc().
local ta is eta:apoapsis.
local h1 is choose apoapsis if ta>0 and ta<tp else periapsis.
local mnv is mnpro(time:seconds+dt, h1).
if bt(mnv:prograde)>1/1000 add mnv.
return mpinc(1/50).}.
