import("mn").
import("math").
set mnpro to { parameter t,h.
local mu is body:mu.
local r0 is body:radius.
local r1 is posat(t,ship).
local v1 is velat(t,ship).
local vr is vdot(v1,r1:normalized).
local dp is burndv(r1:mag,r0*2+apoapsis+periapsis-r1:mag,r0+h,mu).
if availablethrust=0 return 1.
if tb(dp) return mpinc().
add node(t,-vr,0,dp). return mpinc(1/50). }.
set mnatp to { parameter des_apo.
mpadd({mnclr(). if eta:periapsis<0 return mpinc().
return mnpro(time:seconds+eta:periapsis,des_apo).}).
mnwait(). mnexec(). mnfini().}.
set mnata to { parameter des_peri.
mpadd({mnclr(). if apoapsis<0 return mpinc().
return mnpro(time:seconds+eta:apoapsis,des_peri).}).
mnwait(). mnexec(). mnfini().}.
set mncirc to {
mpadd({ mnclr().
local dt is eta:periapsis. if dt<0 return mpinc().
local ta is eta:apoapsis. local h1 is apoapsis.
if ta>0 and ta<dt set dt to ta. else set h1 to periapsis.
return mnpro(time:seconds+dt, h1).}).
mnwait(). mnexec(). mnfini().}.
