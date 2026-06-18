import("mp").
import("fancystager").
import("ascent").
import("simplecirc").
set go to {
set msgnext to { parameter s. print s. return mpinc(). }.
fancystager().
mpone({print "Activate engines when ready.".}).
mpadd({ if maxthrust>0 return mpinc().
return 1/10. }).
mpadd({ if alt:radar>=50 return mpinc().
lock throttle to 1.
lock steering to facing.
return 1/10. }).
mpadd(ascent(90,80000)).
mpadd({ if altitude>body:atm:height return mpinc().
lock steering to prograde. lock throttle to 0. return 1. }).
mpadd(simplecirc).
mpone({ brakes on. print "Release brakes to land.". }).
mpadd({ if not brakes return mpinc().
lock throttle to 0.
lock steering to heading(0,0,0).
return 1.
}).
mpadd({ if periapsis<40000 return mpinc().
lock steering to retrograde.
lock throttle to max(0,min(1,(periapsis+100-40000)/1000)) *
max(1/100,min(1,(10-vang(retrograde:vector,facing:vector))/5)).}).
mpadd({
lock throttle to 0.
lock steering to north.
if altitude>body:atm:height return 1/10.
if not stage:ready return 1/10.
if vdot(north:vector,facing:vector) > 5 return 1/10.
stage. return mpinc(). }).
mpadd({ if altitude <= 5000 { return mpinc(). }
lock steering to srfretrograde.
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
