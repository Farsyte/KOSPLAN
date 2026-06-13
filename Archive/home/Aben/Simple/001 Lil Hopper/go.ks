import("mp").
print "loading Lil Hopper code".
set pitchover_altitude to 50.
set launch_azimuth to 90.
set pitchover_angle to 2.
set parachute_altitude to 3000.
set landing_altitude to 50.
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
mponce({print "LIFTOFF".}).
mpadd(liftoff).
mponce({print "PITCHOVER by "+pitchover_angle+" at "+round(alt:radar,1)+" m.".}).
mpadd(ascent).
mponce({print "DESCENT from max altitude "+round(alt:radar/1000,1)+" km".}).
mpadd(descent).
mponce({print "PARACHUTE armed at "+round(alt:radar/1000,1)+" km".}).
mpadd(chute).
mponce({print "LANDING mode activated at "+round(alt:radar/1000,1)+" km".}).
mpadd(landing).
mponce({print "PARKING".}).
mpadd(parking).
mprun().
}.
