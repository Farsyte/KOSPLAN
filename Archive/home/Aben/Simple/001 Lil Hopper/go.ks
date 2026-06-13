set launch_azimuth to 90.
set pitchover_altitude to 50.
set pitchover_angle to 2.
set parachute_altitude to 3000.
set landing_altitude to 50.
function go {
set h0 to alt:radar.
lock h to alt:radar-h0.
brakes on.
clearscreen.
print " ".
print "Release BRAKES to Launch".
wait until not brakes.
print "Launch Phase".
set h0 to alt:radar.
lock h to alt:radar - h0.
lock throttle to 1.
lock steering to facing.
stage. // ignite engines.
wait until h > pitchover_altitude.
print "Ascent Phase at "+round(h)+" m".
lock pitch to max(-90,min(90-pitchover_angle, 90-vang(up:vector,velocity:surface))).
print "Pitch-Over by "+pitchover_angle+" degrees.".
lock steering to heading(launch_azimuth,pitch,0).
wait until verticalspeed<=0.
print "Descent Phase at "+round(h/1000,3)+" km".
wait until h < parachute_altitude.
print "Parachute Phase at "+round(h/1000,3)+" km".
stage. // activate parachute.
lock steering to facing.
wait until h < landing_altitude.
print "Landing Phase at "+abs(round(verticalspeed,1))+" m/s".
lock steering to heading(launch_azimuth,90,0).
wait until verticalspeed >= 0.
print "Mission Complete".
lock steering to heading(launch_azimuth,0,0).
wait until false.
}
