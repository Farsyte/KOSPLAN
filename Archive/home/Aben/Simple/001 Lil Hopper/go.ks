import("mp").
set go to {
mponce({print "Press SPACE to go toward SPACE".}).
mpadd({ if maxthrust>0 return mpinc().
return 1/10. }).
mpadd({ if alt:radar>=50 return mpinc().
lock throttle to 1.
lock steering to facing.
return 1/10. }).
mpadd({ if verticalspeed <= 0 return mpinc().
lock pitch to max(-90,min(90-2, 90-vang(up:vector,velocity:surface))).
lock steering to heading(90,pitch,0).
lock throttle to 1.
return 1/10. }).
mpadd({ if altitude <= 3000 { stage. return mpinc(). }
lock steering to heading(90,pitch,0).
lock throttle to 0.
return 1/10. }).
mpadd({ if alt:radar <= 50 return mpinc().
lock steering to facing.
return 1/10. }).
mpadd({ if verticalspeed >= 0 return mpinc().
lock steering to heading(90,90,0).
return 1/10. }).
mpadd({
lock steering to heading(90,0,0).
return 1. }).
mprun(). }.
