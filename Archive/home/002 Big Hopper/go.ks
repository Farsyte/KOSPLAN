import("mp").
import("simple").
set po to 89.
set az to 270.
set h1 to body:atm:height + 1000.
set h2 to h1 + 1000.
set go to {
mpstat("Waiting for Launch").
mphold_thrust().
mpstat("Liftoff").
mplaunch().
mpstat("Powered Ascent").
mpadd({ if verticalspeed<=0 or apoapsis>=h2 return mpinc().
lock steering to heading(az,po,0).
lock throttle to max(5/100,(h2-apoapsis)/1000).
return 1/10. }).
mpstat("Unpowered Ascent").
mpadd({ if verticalspeed<=0 or altitude>=h1 return mpinc().
lock steering to heading(az,po,0).
lock throttle to 0.
return 1/10. }).
mpstat("Prepare for Descent").
mpadd({ if not stage:ready return 1/10.
lock steering to heading(az,90,0).
lock throttle to 0.
if vdot(steering:vector,facing:vector) > 5 return 1/10.
stage. return 1/10. }).
mpstat("Descent").
mpadd({ if altitude <= 5000 { return mpinc(). }
lock steering to heading(az,90,0).
lock throttle to 0.
return 1/10. }).
mpstat("Deploy Chutes").
mpadd({ if not stage:ready return 1/10.
lock steering to heading(az,90,0).
lock throttle to 0.
stage. return mpinc(). }).
mpstat("Prepare for Landing").
mpadd({ if alt:radar <= 50 return mpinc().
lock steering to facing.
lock throttle to 0.
return 1/10. }).
mpstat("Landing").
mpadd({
if verticalspeed >= 0 mpinc().
lock steering to heading(90,90,0).
lock throttle to 0.
return 1. }).
mpstat("Landed").
mpadd({
unlock steering.
unlock throttle.
return 1.}).
mprun(). }.
