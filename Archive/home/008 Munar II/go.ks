import("aeroperi").
import("agl").
import("ascent").
import("escape").
import("fancystager").
import("hold").
import("mnpro").
import("mp").
import("simple").
import("sw").
import("time").
import("xfer").
set go to {
local mptwp is { parameter s.
mppdas(). mpadd({
local dt is eta:periapsis-s.
return choose swadj(dt) if dt>0 else mpinc(). }).
mpsw0(). mppdas(). }.
local mptwt is { parameter s.
mppdas(). mpadd({
local dt is choose eta:transition-s if orbit:hasnextpatch else 0.
return choose swadj(dt) if dt>0 else mpinc(). }).
mpsw0(). mppdas(). }.
if body:name="Kerbin" and
body:atm:altitudepressure(altitude)>0.1
when ship:q>0.1 then
when ship:q<0.01 then
lights on.
fancystager().
mpstat("Launching Soon").
mpone({t0put(7-mod(time:seconds,1)).}).
mpone({bays off.}).
mpcount().
mplaunch().
mpstat("Powered Ascent").
mpascent(90,80000).
mpstat("Unpowered Ascent").
mpcoast().
mpstat("Circularizing").
mpcirc().
mppdas().
mpstat("Starting Mun Transfer").
mpxfer("mun").
mppdas().
mpstat("Transfer Orbit to MUN SOI").
mptwt(60).
mpadd({ if not orbit:hasnextpatch return mpinc().
if body:name <> "Kerbin" return mpinc().
return 1. }).
mppdas().
mpstat("Refining MUN Approach").
mpadd({
if periapsis<(10000-200) {
lock steering to prograde.
lock throttle to limit(0,1,(10000-periapsis)/1000) *
limit(1/100,1,(10-vang(prograde:vector,facing:vector))/5).
return eps.
}
if periapsis>(10000+200) {
lock steering to retrograde.
lock throttle to limit(0,1,(periapsis-10000)/1000) *
limit(1/100,1,(10-vang(retrograde:vector,facing:vector))/5).
return eps.
}
lock throttle to 0. return mpinc(). }).
mppdas().
mpstat("Entering MUN Orbit").
mpcirc().
mppdas().
mpsw0().
mppdas().
mphold_brakes("Release Brakes to Test").
local land_log_file is home:combine("landing.log").
if exists(land_log_file) open(land_log_file):clear().
function land_log { parameter m. log TEE()+m to land_log_file.}
land_log(" Rebooted into landing test").
mpadd({
}).
mpadd({
}).
mphold_brakes("Release Brakes to Leave MUN").
mpstat("Leaving Mun").
mpadd({lock steering to heading(270,90,0). lock throttle to 1.
if agl()<50 return 1/10.
gear off. lights on. return mpinc().}).
mpstat("Powered Ascent").
mpascent(270,10000).
mpstat("Unpowered Ascent").
mpcoast().
mpstat("Circularizing").
mpcirc().
mppdas().
mpstat("Leaving MUN Orbit").
mpescape().
mpstat("Leaving Mun SOI").
mptwt(60).
mpadd({ if not orbit:hasnextpatch return mpinc().
if body:name = "Kerbin" return mpinc().
return 1. }).
mpstat("Returning to Kerbin").
mpaero().
mppdas().
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
mppdas().
mnwait().
mpone({ mnclr(). }).
mppdas().
mpstat("Aerocapture").
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
mpstat("Test Done, ABORT to reboot").
mpone({abort off. wait until abort. abort off. reboot.}).
mprun(). print "program terminated".}.
