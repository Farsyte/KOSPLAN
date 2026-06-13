import("mp").
import("nv").
set pitchover_altitude to nvget(1,"pitchover_altitude",50).
set launch_azimuth to nvget(1,"launch_azimuth",90).
set pitchover_angle to nvget(1,"pitchover_angle",2).
set parachute_altitude to nvget(1,"parachute_altitude",3000).
set landing_altitude to nvget(1,"landing_altitude",50).
set launch_hold to { if maxthrust>0 return mpinc().
return 1/10. }.
set liftoff to { if alt:radar>=pitchover_altitude return mpinc().
lock throttle to 1.
lock steering to facing.
return 1/10. }.
set ascent to { if verticalspeed <= 0 return mpinc().
lock pitch to max(-90,min(90-pitchover_angle, 90-vang(up:vector,velocity:surface))).
lock steering to heading(launch_azimuth,pitch,0).
lock throttle to 1.
return 1/10. }.
set descent to { if alt:radar <= parachute_altitude { stage. return mpinc(). }
lock steering to heading(launch_azimuth,pitch,0).
lock throttle to 0.
return 1/10. }.
set chute to { if alt:radar <= landing_altitude return mpinc().
lock steering to facing.
return 1/10. }.
set landing to { if verticalspeed >= 0 return mpinc().
lock steering to heading(launch_azimuth,90,0).
return 1/10. }.
set parking to {
lock steering to heading(launch_azimuth,0,0).
return 1. }.
set go to {
mponce({print "Press SPACE to go toward SPACE".}).
mpadd(launch_hold).
mpadd(liftoff).
mpadd(ascent).
mpadd(descent).
mpadd(chute).
mpadd(landing).
mpadd(parking).
mprun().
}.
