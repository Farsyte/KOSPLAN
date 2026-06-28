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
mphold_brakes("Collect Science, Release Brakes").
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
local llog is mklogger("landing").
local mun_landing_lng is nvget(1,"mun_landing_lng", 47.436).
llog("loading mun_landing_lng "+fmt(mun_landing_lng,10,6)).
local mun_landing_lng_lead is nvget(1,"mun_landing_lng_lead", 2.879488).
llog("loading mun_landing_lng_lead "+fmt(mun_landing_lng_lead,10,6)).
mpstat("Finding Landing Site").
mpone({if hasnode {
local lng is body:geopositionof(posat(nextnode:time)+body:position):lng.
set mun_landing_lng to nvput(1,"mun_landing_lng", lng).
llog("update mun_landing_lng "+fmt(mun_landing_lng,10,6)).
mnclr().}}).
mpone({
local lng is body:geopositionof(ship:position):lng.
llog("want decel at:          "+fmt(mun_landing_lng+mun_landing_lng_lead,10,6)).
}).
mpadd({
local sec_per_deg is 1/(360*(1/orbit:period + 1/body:rotationperiod)).
local curr_lng is body:geopositionof(ship:position):lng.
local lng_to_site is ua(curr_lng - mun_landing_lng).
local dt is (lng_to_site - mun_landing_lng_lead) * sec_per_deg.
return choose swadj(dt) if dt>1 else mpinc(). }).
mpsw0().
mpstat("Breaking Mun Orbit").
mpone({
local lng is body:geopositionof(ship:position):lng.
llog("decel at lng:           "+fmt(lng,10,6)).
}).
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
mpone({
putstat("Mun Landing Site Check").
local lng is body:geopositionof(ship:position):lng.
llog("start descent at lng:   "+fmt(lng,10,6)).
unlock steering.
unlock throttle.
sas on.
gear on.
lights on.}).
mpadd({
local grav is body:mu / body:radius^2.
local anom is 5.
lock high to agl().
if high<1 return mpinc().
lock down to -verticalspeed.
lock wacc to 0.5*down^2/high + grav.
lock maxt to ship:availablethrust.
lock maxa to maxt/mass.
lock werr to wacc-anom.
lock thro to limit(0,1,(anom+werr*10)/maxa).
if sas and thro>1/100 {
putstat("Auto-Land Sequence").
local lng is body:geopositionof(ship:position):lng.
llog("start descent at lng:   "+fmt(lng,10,6)).
lock throttle to 0.
sas off.
lock steering to srfretrograde.
gear on. lights on.
llog(
","+fmt("high",6,0)+
","+fmt("down",6,1)+
","+fmt("wacc",8,3)+
","+fmt("maxt",8,3)+
","+fmt("maxa",8,3)+
","+fmt("werr",8,3)+
","+fmt("thro",8,3)+
"").
}
if not sas {
lock steering to lookdirup(
choose srfretrograde:vector if down>10 else -body:position,
facing:topvector).
lock throttle to thro *
limit(1/100,1,(10-vang(steering:vector,facing:vector))/5).
llog(""+
","+fmt(high,6,0)+
","+fmt(down,6,1)+
","+fmt(wacc,8,3)+
","+fmt(maxt,8,3)+
","+fmt(maxa,8,3)+
","+fmt(werr,8,3)+
","+fmt(thro,8,3)+
""
).
}
return 1.}).
mpone({
local lng is body:geopositionof(ship:position):lng.
local lng_err is lng - mun_landing_lng.
local adj_lead is mun_landing_lng_lead - lng_err.
llog("at mun landing site: ship is at"+
" lat "+fmt(ship:latitude,8,3)+", "+
" lng "+fmt(ship:longitude,8,3)).
llog("if no landing site maneuvering ...").
llog("  position error:       "+fmt(lng_err,10,6)).
llog("  updated lead:         "+fmt(adj_lead,10,6)).
lock throttle to 0.
lock steering to facing.}).
mpdvlog("At Mun Landing Site").
mphold_brakes("Collect Science, Release Brakes").
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
