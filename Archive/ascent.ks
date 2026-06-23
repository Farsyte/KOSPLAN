import("mp").
set mpascent to { parameter d, h.
mpadd({
if verticalspeed<0 or (apoapsis>=h and altitude>body:atm:height) return mpinc().
lock steering to heading(d, max(0,90-120*sqrt(altitude/h)), 0).
lock throttle to sqrt(max(0,(h+1-apoapsis)/1000)).
return 1.}).
mpone({ lock throttle to 0. lock steering to prograde.}).}.
