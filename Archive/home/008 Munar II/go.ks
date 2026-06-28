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
mppdas().
mphold_brakes("Collect Science, Release Brakes").
mpstat("Starting Mun Transfer").
mpxfer("mun").
mppdas().
mpdvlog("kerbin to mun soi").
mppdas().
mphold_brakes("Collect Science, Release Brakes").
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
mppdas().
mphold_brakes("Collect Science, Release Brakes").
mpstat("Entering MUN Orbit").
mpcirc().
mppdas().
mpdvlog("in 10x10 over mun").
mpsw0().
mppdas().
mphold_brakes("Release Brakes to start landing").
local mun_landing_lng is nvget(1,"mun_landing_lng", 47.436).
local mun_landing_lng_lead is nvget(1,"mun_landing_lng_lead", 3).
mpstat("Finding Landing Site").
mpone({if hasnode {
local lng is body:geopositionof(posat(nextnode:time)+body:position):lng.
set mun_landing_lng to nvput(1,"mun_landing_lng", lng).
mnclr().}}).
mpadd({
local sec_per_deg is 1/(360*(1/orbit:period + 1/body:rotationperiod)).
local curr_lng is body:geopositionof(ship:position):lng.
local lng_to_site is ua(curr_lng - mun_landing_lng).
local dt is (lng_to_site - mun_landing_lng_lead) * sec_per_deg.
return choose swadj(dt) if dt>1 else mpinc(). }).
mpsw0().
mpstat("Breaking Mun Orbit").
mpadd({
lock vh to vxcl(body:position,velocity:surface).
if vh:mag<1 return mpinc().
lock steering to -vh.
lock throttle to limit(0,1,vh:mag/10) *
limit(1/100,1,(10-vang(-vh,facing:vector))/5).
return 1.}).
mpadd({
if stage:number>2 { if stage:ready stage. return 1/10. }
lock throttle to 0. lock steering to heading(270,90,0).
return mpinc(5).}).
mpstat("Adjust Landing then Cancel SAS").
mpone({
unlock steering. unlock throttle.
sas on. gear on. lights on.}).
mpadd({if not sas return mpinc().
local grav is body:mu / body:radius^2.
local anom is 5.
local gain is 10.
local bias is gain*grav -gain*anom +anom.
local wthr is mass*(bias+0.5*gain*verticalspeed^2/agl()).
return choose 1 if 100*wthr<ship:availablethrust else mpinc().}).
mpstat("Auto-Land Sequence").
mpone({sas off. gear on. lights on.}).
mpadd({
if agl()<1/100 or verticalspeed>=0 return mpinc().
local grav is body:mu / body:radius^2.
local anom is 5.
local gain is 10.
local bias is gain*grav -gain*anom +anom.
lock steering to lookdirup(srfretrograde:vector-10*body:position:normalized,facing:topvector).
lock throttle to limit(0,1,(bias+0.5*gain*verticalspeed^2/agl())*mass/ship:availablethrust).
return 1.}).
mpone({unlock throttle. unlock steering. SAS ON.}).
mpdvlog("At Mun Landing Site").
mphold_brakes("Collect Science, Release Brakes").
local mun_ret_az is 270.
local mun_ret_ap is 10000.
mpstat("Leaving Mun").
mpone({
nvput(1,"launch_az", mun_ret_az).
nvput(1,"launch_ap", mun_ret_ap).}).
mpadd({
sas off. lights on.
lock steering to heading(mun_ret_az,90,0). lock throttle to 1.
return choose 1/10 if agl()<50 else mpinc(). }).
mpone({gear off.}).
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
