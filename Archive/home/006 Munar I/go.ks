import("ascent").
import("fancystager").
import("hud").
import("mp").
import("simple").
import("sw").
import("time").
import("xfer").
import("aeroperi").
local pdas is {
local h is vcrs(body:position,ship:velocity:orbit).
lock throttle to 0.
lock steering to lookdirup(h,-sun:position).
BAYS ON. }.
local hold is { if not bays mpinc().
hud("BAY "+(choose "OPEN" if BAYS else "OK"), false). return 2. }.
set go to {
fancystager().
mpone({BAYS ON.}).
mpadd(hold).
mpone({t0put(7-mod(time:seconds,1)).}).
mpadd({
local t is met().
local d is round(-t).
if d<=0 return mpinc().
if d<=5 hud("T-"+d).
return 1-mod(t,1)-1/50.
}).
mpone({
if maxthrust>0 return mpinc().
if not stage:ready return 1/10.
lock throttle to 1.
lock steering to facing.
stage. t0put(0).
}).
mpone({hud("ignition").}).
mpadd({ if alt:radar>=50 return mpinc().
lock throttle to 1.
lock steering to facing.
bays off.
return 1/10. }).
mpone({hud("pitchover at T+"+ydhms(met())).}).
mpadd(ascent(90,80000)).
mpone({lock throttle to 0. hud("MECO at T+"+ydhms(met())).}).
mpadd({ if altitude>body:atm:height return mpinc().
lock steering to prograde. lock throttle to 0. return 1. }).
mpone({hud("SPACE! at T+"+ydhms(met())).}).
mpadd(simplecirc).
mpone({hud("ORBIT! at T+"+ydhms(met())).}).
mpone(pdas). mpadd(hold). mpone(pdas).
mpone(xfer("mun")).
mpone(pdas). mpadd(hold). mpone(pdas).
mpadd(mnwait).
mpadd(mnexec).
mpadd(mnfini).
mpone(pdas). mpadd(hold). mpone(pdas).
mpadd({ if not orbit:hasnextpatch return mpinc().
local dt is eta:transition-60.
if dt<=0 return mpinc().
swadj(dt). return 1/10. }).
mpadd(swend).
mpadd({ if not orbit:hasnextpatch return mpinc().
if body:name <> "Kerbin" return mpinc().
return 1. }).
mpone(pdas). mpadd(hold). mpone(pdas).
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
mpone(pdas). mpadd(hold). mpone(pdas).
mpadd({ if eta:periapsis<60 return mpinc().
local dt is eta:periapsis-120.
if dt<=0 return mpinc().
swadj(dt). return 1/10. }).
mpadd(swend).
mpone(pdas). mpadd(hold). mpone(pdas).
mpadd({ if not orbit:hasnextpatch return mpinc().
local dt is eta:transition-60.
if dt<=0 return mpinc().
swadj(dt). return 1/10. }).
mpadd(swend).
mpadd({ if not orbit:hasnextpatch return mpinc().
if body:name = "Kerbin" return mpinc().
return 1. }).
mpadd(aeroperi).
mpone(pdas). mpadd(hold). mpone(pdas).
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
mpadd(mnwait).
mpone({ mnclr(). }).
mpone(pdas).
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
