import("mp").
set mpascent to { parameter d, h.
mpadd({
if verticalspeed<0 or apoapsis>=h return mpinc().
lock steering to heading(d, max(0,90-120*sqrt(altitude/h)), 0).
lock throttle to sqrt(max(0,(h+20-apoapsis)/1000)).
return 1.}).}.
