import("mp").
set po to 89.
set az to 270.
set h1 to body:atm:height + 1000.
set h2 to h1 + 1000.
set go to {
mponce({print "Press SPACE to go toward SPACE".}).
mpadd({ if maxthrust>0 return mpinc().
return 1/10. }).
mpadd({ if alt:radar>=50 return mpinc().
lock throttle to 1.
lock steering to facing.
return 1/10. }).
mpadd({ if verticalspeed<=0 or apoapsis>=h2 return mpinc().
lock steering to heading(az,po,0).
lock throttle to max(5/100,(h2-apoapsis)/1000).
return 1/10. }).
mpadd({ if verticalspeed<=0 or altitude>=h1 return mpinc().
lock steering to heading(az,po,0).
lock throttle to 0.
return 1/10. }).
mpadd({ if not stage:ready return 1/10.
lock steering to heading(az,90,0).
lock throttle to 0.
if vdot(steering:vector,facing:vector) > 5 return 1/10.
stage. return 1/10. }).
mpadd({ if altitude <= 5000 { return mpinc(). }
lock steering to heading(az,90,0).
lock throttle to 0.
return 1/10. }).
mpadd({ if not stage:ready return 1/10.
lock steering to heading(az,90,0).
lock throttle to 0.
stage. return mpinc(). }).
mpadd({ if alt:radar <= 50 return mpinc().
lock steering to facing.
lock throttle to 0.
return 1/10. }).
mpadd({
lock steering to heading(90,90,0).
lock throttle to 0.
return 1. }).
mprun(). }.
