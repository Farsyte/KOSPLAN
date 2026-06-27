import("aeroperi").
import("agl").
import("ascent").
import("escape").
import("fancystager").
import("hold").
import("logger").
import("mnpro").
import("mp").
import("simple").
import("sw").
import("time").
import("xfer").
local dvlog is mklogger("deltav").
local mpdvlog is {parameter m. mpone({
dvlog(" | "+pr(m,32)+" | "+fmt(ship:deltav:vacuum,8,2)+" |").
}).}.
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
altitude<body:atm:height
when altitude>body:atm:height then
lights on.
fancystager().
mpstat("Launching Soon").
mpone({t0put(7-mod(time:seconds,1)).}).
mpone({bays off.}).
mpdvlog("before launch").
mpcount().
mplaunch().
mpstat("Powered Ascent").
mpascent(90,80000).
mpstat("Unpowered Ascent").
mpcoast().
mpdvlog("arriving 80k over kerbin").
mpstat("Circularizing").
mpcirc().
mppdas().
mpdvlog("in 80x80 over kerbin").
mpstat("Starting Mun Transfer").
mpxfer("mun").
mppdas().
mpdvlog("kerbin to mun soi").
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
mpdvlog("mun soi to mun 10k").
mpstat("Entering MUN Orbit").
mpcirc().
mppdas().
mpdvlog("in 10x10 over mun").
mpsw0().
mppdas().
mphold_brakes("Release Brakes to start landing").
mpstat("Finding Landing Site").
mpadd({
lock vh to vxcl(body:position,velocity:surface).
if vh:mag<1 return mpinc().
lock steering to -vh.
lock tef to (10-vang(-vh,facing:vector))/5.
lock throttle to limit(0,1,vh:mag/10) * limit(1/100,1,tef).
}).
mpone({lock throttle to 0. return mpinc(1).}).
mpdvlog("at 10km over mun landing site").
mpstat("Descent to Mun Surface").
mpadd({if stage:number<=2 return mpinc().
if stage:ready stage. return 1/10. }).
mpone({gear on.}).
mpadd({
lock high to agl().
if high<1 return mpinc().
lock down to -verticalspeed.
lock grav to body:mu / body:radius^2.
lock wacc to 0.5*down^2/high + grav.
set anom to 5.
lock maxt to max(eps, ship:availablethrust).
lock maxa to maxt/mass.
lock tnom to anom/maxa.
lock werr to wacc-anom.
lock thro to limit(0,1,(anom+werr*10)/maxa).
lock steering to lookdirup(
choose srfretrograde:vector if down>10 else -body:position,
facing:topvector).
lock throttle to thro.
return 1.
}).
mpone({
lock throttle to 0.
lock steering to facing.
}).
mpdvlog("landed on mun").
mphold_brakes("Release Brakes to Leave MUN").
local mun_ret_az is 270.
local mun_ret_ap is 10000.
mpstat("Leaving Mun").
mpone({
nvput(1,"launch_az", mun_ret_az).
nvput(1,"launch_ap", mun_ret_ap).}).
mpadd({lock steering to heading(mun_ret_az,90,0). lock throttle to 1.
if agl()<50 return 1/10.
gear off. lights on. return mpinc().}).
mpstat("Powered Ascent").
mpascent(mun_ret_az,mun_ret_ap).
mpstat("Unpowered Ascent").
mpcoast().
mpdvlog("arriving 10k over mun").
mpstat("Circularizing").
mpcirc().
mppdas().
mpdvlog("in 10x10 over mun").
mpstat("Leaving MUN Orbit").
mpescape().
mpdvlog("mun to kerbin soi").
mpstat("Leaving Mun SOI").
mptwt(60).
mpadd({ if not orbit:hasnextpatch return mpinc().
if body:name = "Kerbin" return mpinc().
return 1. }).
mpstat("Returning to Kerbin").
mpaero().
mppdas().
mpdvlog("descent to kerbin 40k aero").
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
mpadd({ if altitude<80000 return mpinc().
return 1.}).
mpadd({ if stage:number=0 return mpinc().
if stage:ready stage. return 1/10.}).
mpdvlog("configured for aerobraking").
mpadd({ if agl()<1000 return mpinc().
lock steering to srfretrograde. return 1. }).
mpadd({
lock steering to heading(90,90,0). return 1. }).
mpstat("Test Done, ABORT to reboot").
mpone({abort off. wait until abort. abort off. reboot.}).
mprun(). print "program terminated".}.
