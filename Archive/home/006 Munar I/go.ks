import("hold").
import("fancystager").
import("simple").
import("ascent").
import("xfer").
import("aeroperi").
import("mp").
import("sw").
import("time").
set go to {
fancystager().
mpstat("Launchpad Science").
mpone({bays on.}).
mphold_bay().
mpstat("Launching Soon").
mpone({t0put(7-mod(time:seconds,1)).}).
mpcount().
mpone({bays off.}).
mplaunch().
mpstat("Powered Ascent").
mpascent(90,80000).
mpstat("Unpowered Ascent").
mpcoast().
mpstat("Circularizing").
mpcirc().
mpstat("Orbital Science").
mppdas(). mphold_bay(). mppdas().
mpxfer("mun").
mppdas(). mppdas(). mppdas().
mpadd({ if not orbit:hasnextpatch return mpinc().
local dt is eta:transition-60.
if dt<=0 return mpinc().
swadj(dt). return 1/10. }).
mpadd(swend).
mpadd({ if not orbit:hasnextpatch return mpinc().
if body:name <> "Kerbin" return mpinc().
return 1. }).
mppdas(). mppdas(). mppdas().
mpadd({
if periapsis<20000 {
lock steering to prograde.
lock throttle to limit(0,1,(periapsis+100-40000)/1000) *
limit(1/100,1,(10-vang(prograde:vector,facing:vector))/5).
return 1/10.
}
if periapsis>50000 {
lock steering to retrograde.
lock throttle to limit(0,1,(periapsis+100-40000)/1000) *
limit(1/100,1,(10-vang(retrograde:vector,facing:vector))/5).
return 1/10.
}
return mpinc(). }).
mppdas(). mppdas(). mppdas().
mpadd({ if eta:periapsis<60 return mpinc().
local dt is eta:periapsis-120.
if dt<=0 return mpinc().
swadj(dt). return 1/10. }).
mpadd(swend).
mppdas(). mppdas(). mppdas().
mpadd({ if not orbit:hasnextpatch return mpinc().
local dt is eta:transition-60.
if dt<=0 return mpinc().
swadj(dt). return 1/10. }).
mpadd(swend).
mpadd({ if not orbit:hasnextpatch return mpinc().
if body:name = "Kerbin" return mpinc().
return 1. }).
mpadd(aeroperi).
mppdas(). mppdas(). mppdas().
mpone({
local t1 is time:seconds + 60.
local t2 is time:seconds + eta:periapsis.
local rx is body:radius + 120000.
until (t2-t1)<1 {
local t3 is t1 + (t2-t1)/2.
local r3 is posat(t3,ship):mag.
if r3 < rx set t2 to t3. else set t1 to t3. }
mnclr().
add node(t1,0,0,-1).}).
mnwait().
mpone({ mnclr(). }).
mppdas().
mpadd({
if altitude>80000 return 1.
if altitude<40000 and apoapsis<60000 return mpinc().
lock steering to srfretrograde.
lock throttle to limit(1/100,1,(10-vang(srfretrograde:vector,facing:vector))/5).
return 1. }).
mpadd({ lock throttle to 0. lock steering to srfretrograde.
if stage:number=0 mpinc().
if stage:ready stage. return 1. }).
mpadd({ unlock throttle. unlock steering. return mpinc(). }).
mprun(). print "program terminated".}.
