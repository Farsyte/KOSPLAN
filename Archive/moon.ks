set fixperi to {
parameter lo,md,hi. return {
if periapsis<lo {
lock steering to prograde.
lock throttle to limit(0,1,(md-periapsis)/1000) *
limit(1/100,1,(10-vang(prograde:vector,facing:vector))/5).
return 1/100.}
if periapsis>hi {
lock steering to retrograde.
lock throttle to limit(0,1,(periapsis-md)/1000) *
limit(1/100,1,(10-vang(retrograde:vector,facing:vector))/5).
return 1/100.}
return mpinc().}.}.
