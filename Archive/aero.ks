import("mp").
set mpaero to {
mpstat("Adjusting Periapsis for Aerocapture").
mpadd({if periapsis<40000 return mpinc().
lock steering to retrograde.
lock throttle to max(0,min(1,(periapsis+100-40000)/1000)) *
max(1/100,min(1,(10-vang(retrograde:vector,facing:vector))/5)).}).
mpstat("Approaching Aerocapture").
mpadd({if altitude<70000 return mpinc().
lock steering to retrograde.
lock throttle to 0.
return 1/100.}).
mpstat("Configure for Aerobraking").
mpadd({if stage:number=0 return mpinc().
lock steering to srfretrograde.
if not stage:ready return 1/100.
stage. return 1/10.}).
mpstat("Aerobraking").
mpadd({if alt:radar<5000 return mpinc().
lock steering to srfretrograde. return 1/100.}).
mpstat("Prepare for Landing").
mpadd({if alt:radar<50 return mpinc().
lock steering to facing. return 1/10.}).
mpstat("Landing").
mpadd({if verticalspeed>=0 return mpinc().
lock steering to heading(90,90,0). return 1/10.}).
mpstat("Mission Complete").
mpadd({unlock steering. sas on. return mpinc(5).}).}.
