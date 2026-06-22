import("aeroperi").
import("ascent").
import("escape").
import("fancystager").
import("fmt").
import("hud").
import("mnpro").
import("moon").
import("mp").
import("simple").
import("sw").
import("time").
import("xfer").
local pdas is {
local h is vcrs(body:position,ship:velocity:orbit).
lock throttle to 0.
lock steering to lookdirup(h,-sun:position).
BAYS ON.
local a is vang(facing:upvector,sun:position).
if a>175 mpinc(). return 1. }.
local hold is { if not bays mpinc().
hud("BAY "+(choose "OPEN" if BAYS else "OK"), false). return 2. }.
set go to {
fancystager().
mpone({t0put(7-mod(time:seconds,1)).}).
mpadd(docount).
mpone({hud(TEE()+" Ignition").}).
mpadd(dolaunch).
mpone({hud(TEE()+" Pitchover").}).
mpadd(ascent(90,80000)).
mpadd(meco).
mpone({hud(TEE()+" MECO").}).
mpadd(coast).
mpone({hud(TEE()+" SPACE!").}).
mpadd(simplecirc).
mpone({hud(TEE()+" ORBIT!").}).
mpadd(pdas).
mpadd(xfer("mun")).
mpadd(mnwait).
mpone({hud(TEE()+" Trans-Munar Injection").}).
mpadd(mnexec).
mpadd(mnfini).
mpone({hud(TEE()+" Trans-Munar Trajectory Established").}).
mpadd(pdas).
mpadd({ if not orbit:hasnextpatch return mpinc().
local dt is eta:transition-60.
if dt<=0 return mpinc().
swadj(dt). return 1/10. }).
mpadd(swend).
mpadd(pdas).
mpadd({
if not orbit:hasnextpatch return mpinc().
if body:name <> "Kerbin" return mpinc().
return 1. }).
mpone({hud(TEE()+" Entering MUN SOI").}).
mpadd(pdas).
mpadd(fixperi(12000,14000,16000)).
mpadd(pdas).
mpadd(mncirc).
mpadd(pdas).
mpadd(mnwait).
mpadd(mnexec).
mpadd(mnfini).
mpone({hud(TEE()+" MUN Orbit").}).
mpadd(pdas). mpadd(hold). mpadd(pdas).
mpone({hud(TEE()+" Planning MUN Escape").}).
mpadd(escape).
mpadd(pdas).
mpadd(mnwait).
mpone({hud(TEE()+" Leaving MUN Orbit").}).
mpadd(mnexec).
mpadd(mnfini).
mpadd({ if not orbit:hasnextpatch return mpinc().
local dt is eta:transition-60.
if dt<=0 return mpinc().
swadj(dt). return 1/10. }).
mpadd(swend).
mpadd({ if not orbit:hasnextpatch return mpinc().
if body:name = "Kerbin" return mpinc().
return 1. }).
mpone({hud(TEE()+" Returning to KERBIN").}).
mpadd(aeroperi).
mpadd(pdas).
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
mpone({hud(TEE()+" Ready for AEROBRAKING").}).
mpone({ mnclr(). }).
mpadd(pdas).
mpadd({
if altitude>80000 return 1.
if altitude<40000 and apoapsis<60000 return mpinc().
lock steering to srfretrograde.
lock throttle to limit(1/100,1,(10-vang(srfretrograde:vector,facing:vector))/5).
return 1. }).
mpone({hud(TEE()+" Final Stage Separation").}).
mpadd({ lock throttle to 0. lock steering to srfretrograde.
if stage:number=0 mpinc().
if stage:ready stage. return 1. }).
mpone({hud(TEE()+" What CPU is running this code?").}).
mpadd({ unlock throttle. unlock steering. return mpinc(). }).
mpone({hud(TEE()+" Falling Off the Bottom").}).
mprun(). HUD(TEE()+" program terminated").}.
