import("mp").
set ascent to { if verticalspeed<0 or apoapsis>=80000 return mpinc().
lock altitude_fraction to altitude/80000.
lock desired_pitch to max(0,90-120*sqrt(altitude_fraction)).
lock steering to heading(90, desired_pitch, 0).
lock throttle to sqrt(max(0,(80000+20-apoapsis)/1000)).
return 1.}.
