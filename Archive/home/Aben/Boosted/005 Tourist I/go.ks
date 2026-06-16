import("mp").
import("fancystager").
import("ascent").
import("simplecirc").
set go to {
fancystager().
mponce({
if maxthrust>0 return mpinc().
if not stage:ready return 1/10.
lock throttle to 1.
lock steering to facing.
bays off.
stage. }).
mpadd({ if alt:radar>=50 return mpinc().
lock throttle to 1.
lock steering to facing.
bays off.
return 1/10. }).
mpadd(ascent(90,80000)).
mpadd({ if altitude>body:atm:height return mpinc().
lock steering to prograde. lock throttle to 0. return 1. }).
mpadd(simplecirc).
mpadd({ if periapsis<40000 return mpinc().
lock steering to retrograde.
lock throttle to max(0,min(1,(periapsis+100-40000)/1000)) *
max(1/100,min(1,(10-vang(retrograde:vector,facing:vector))/5)).}).
mpadd({
lock throttle to 0.
lock steering to vcrs(body:position,ship:velocity:orbit).
if altitude>body:atm:height return 1/10.
if not stage:ready return 1/10.
if vdot(north:vector,facing:vector) > 5 return 1/10.
stage. return mpinc(). }).
mpadd({ if altitude <= 60000 { return mpinc(). }
lock steering to retrograde. bays off.
return 1/10. }).
mpadd({ if altitude <= 5000 { return mpinc(). }
lock steering to srfretrograde. bays on.
return 1/10. }).
mpadd({ if not stage:ready return 1/10.
lock steering to heading(90,90,0).
stage. return mpinc(). }).
mpadd({ if alt:radar <= 50 return mpinc().
lock steering to facing.
return 1/10. }).
mpadd({
lock steering to heading(90,90,0).
return 1. }).
mprun(). print "program terminated".}.
