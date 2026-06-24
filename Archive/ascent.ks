import("mp").
set mpascent to { parameter d, h. mpadd({
local az is nvget(1,"launch_az",d).
local ap is nvget(1,"launch_ap",h).
if verticalspeed<0 return mpinc().
if (apoapsis>=ap and altitude>=body:atm:height) return mpinc().
lock steering to heading(az,
limit(0,90,90-120*sqrt(
limit(0,1,altitude/ap))),0).
lock throttle to
limit(.01,1,(45-vang(FACING:VECTOR, STEERING:VECTOR))/30) *
sqrt(limit(0,1,(ap+1-apoapsis)/1000)) *
min(1,20*ship:availablethrust/mass).
return 1.}).
mpone({ lock throttle to 0. lock steering to facing.}).}.
