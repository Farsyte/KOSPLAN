import("mp").
set circ_apo to {
if periapsis>apoapsis-100 return mpinc().
lock steering to prograde.
lock throttle to max(0,min(1,(2-eta:apoapsis/10))) *
max(1/100,min(1,1-vang(steering:vector,prograde:vector)/5)).
return 1. }.
