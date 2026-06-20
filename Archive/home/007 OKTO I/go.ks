import("nv").
import("math").
import("fmt").
import("mn").
import("sw").
import("ascent").
import("simplecirc").
import("hud").
set okto_log to home:combine("okto.log").
if exists(okto_log) open(okto_log):clear().
if homeconnection:isconnected {
print "importing current_contract".
import("current_contract").
deletepath("1:/current_contract").}
else print "no connection: using saved contract".
set ccinc to nvget(1,"ccinc", 0).
set ccecc to nvget(1,"ccecc", 0).
set ccsma to nvget(1,"ccsma", 80000).
set cclan to nvget(1,"cclan", 0).
set ccaop to nvget(1,"ccaop", 0).
set ccmep to nvget(1,"ccmep", 0).
set cctep to nvget(1,"cctep", 0).
set ccbod to nvget(1,"ccbod", "kerbin").
set ccorb to CREATEORBIT(ccinc, ccecc, ccsma, cclan, ccaop, ccmep, cctep, ccbod).
set launch_t0 to nvget(1, "launch_t0", t0).
set launch_az to nvget(1, "launch_az", 90).
set launch_ap to nvget(1, "launch_ap", 80000).
lock maxt to max(eps, ship:availablethrust).
lock maxa to maxt/mass.
set pdas to { lights on. lock throttle to 0.
lock steering to lookdirup(vcrs(sun:velocity:orbit,sun:position),-sun:position).
if wfcmd>1 or 5>vang(facing:upvector,steering:upvector) mpinc().
return 1. }.
set go to {
if stage:number>0
when stage:ready and (
(stage:number=3) or
(stage:number=2 and altitude>70000) or
(stage:number<3 and maxthrust=0)) then {
stage. HUD(TEE()+": STAGE "+stage:number).
lock throttle to 0.
return stage:number>0.}
mpadd({
local th is vcrs(ccorb:position-body:position,ccorb:velocity:orbit):normalized.
local sp is -body:position:normalized.
local sv is ship:velocity:orbit:normalized.
local hp is vdot(th, sp).
local hv is vdot(th, sv).
local angle is arctan2(hv, hp)+180.
local quad is floor(angle/90).
if quad=0 or quad=2 {swadj(body:rotationperiod/8). return wfcmd/10.}
local aeoq is angle-90*quad.
local qeta is aeoq * body:rotationperiod/360.
set qeta to qeta - 2*body:rotationperiod/360.
swadj(qeta-30).
if wfnow>1 return wfcmd/10.
if qeta>20 return mod(qeta+9.9,1).
t0put(qeta-10).
set launch_t0 to nvput(1, "launch_t0", t0).
set launch_az to nvput(1, "launch_az", choose 356 if hv > 0 else 184).
set launch_ap to nvput(1, "launch_ap", 80000).
HUD("Will launch in "+round(t0-time:seconds,1)+" seconds.").
return mpinc(). }).
mpadd({
local t is -met().
if round(t)<=5 HUD(TEE()).
if t<=0.5 return mpinc().
return mod(t,1).}).
mpone({
if maxthrust>0 return mpinc().
if not stage:ready return 1/10.
lock throttle to 1.
lock steering to facing.
hud(TEE()+": Ignition"). stage. t0put(0).
set launch_t0 to nvput(1, "launch_t0", t0).}).
mpadd({ if alt:radar>=50 return mpinc().
lock throttle to 1. lock steering to facing. return 1/10. }).
mpone({hud(TEE()+": Pitchover").}).
mpadd({
if verticalspeed<0 return mpinc().
if altitude>=70000 and apoapsis>=launch_ap return mpinc().
lock af to limit(0,1,altitude/launch_ap).
lock cp to limit(0,90,90-120*sqrt(af)).
lock steering to heading(launch_az, cp, 0).
lock tf to min(1,sqrt(max(0,(launch_ap+20-apoapsis)/1000))).
lock va to vang(FACING:VECTOR, STEERING:VECTOR).
lock ef to limit(.01,1,(45-va)/30).
lock throttle to ef*tf*min(1,20/maxa).
return 1. }).
mpone({lock throttle to 0. hud(TEE()+": MECO").}).
mpadd({ if altitude>body:atm:height return mpinc().
lock steering to prograde. lock throttle to 0. return 1. }).
mpone({hud(TEE()+": SPACE!").}).
mpone({hud(TEE()+": "+round(stage:deltav:vacuum,1)+ " m/s ΔV remains").}).
mpadd(simplecirc).
mpone({hud(TEE()+": "+round(stage:deltav:vacuum,1)+ " m/s ΔV remains").}).
mpadd(pdas).
mpadd({
local dv is burndvh(altitude,altitude,ccorb:apoapsis,body).
mnclr(). add node(time:seconds, 0, 0, dv). wait 0.
local aop_ref is ccorb:argumentofperiapsis.
local f is {parameter t. set nextnode:time to t. wait 0.
return sa(nextnode:orbit:argumentofperiapsis-aop_ref)^2.}.
local dt is orbit:period/12.
local t1 is time:seconds + dt.
local c1 is f(t1).
local t2 is t1 + dt.
local c2 is f(t2).
until c2<=c1 {
set t1 to t2.
set c1 to c2.
set t2 to t1 + dt.
set c2 to f(t2).
}
until c2>=c1 {
set t1 to t2.
set c1 to c2.
set t2 to t1 + dt.
set c2 to f(t2).
}
until c1<=1e-8 {
set dcdt to (c2-c1) / (t2-t1).
set dt to c1/dcdt.
if abs(dt) < 1/100 break.
set t1 to t1 - 2*dt.
set c1 to f(t1).
set t2 to t1 + dt/10.
set c2 to f(t2).
}
set c1 to f(t1). return mpinc().}).
mpadd(pdas). mpadd(mnwait). mpadd(mnexec). mpadd(mnfini). mpadd(pdas).
mpone({hud("Moving from Parking to Assigned Orbit").}).
mpadd({
mnclr().
local h1 is apoapsis.
local h2 is periapsis.
local h3 is ccorb:periapsis.
local dv is burndvh(h1,h2,h3,body).
add node(time:seconds + eta:apoapsis, 0, 0, dv).
return mpinc().
}).
mpadd(pdas). mpadd(mnwait). mpadd(mnexec). mpadd(mnfini). mpadd(pdas).
{ local mpi_park is mpl:length.
local mnv_plan is false.
mpadd({
hud(TEE()+": Maintaining Assigned Orbit").
set mnv_plan to false. mnclr().
return mpinc(). }).
mpadd({
local ie is orbit:inclination-ccorb:inclination.
local le is orbit:lan-ccorb:lan.
if abs(ie)<=1/10 and abs(le)<=1/10 return mpinc().
local ccdir is vcrs(ccorb:position-body:position,ccorb:velocity:orbit):normalized.
local ccpos is vdot(ccdir,body:position).
local ccvel is vdot(ccdir,velocity:orbit).
if ccpos*ccvel<=0 {swadj(orbit:period/8). return 1/10.}
local mydir is vcrs(-body:position,velocity:orbit):normalized.
local cceta is ccpos / ccvel.
local lt is abs(ccvel)*2/maxa.
local etb is cceta - lt.
local ld is ccvel^2/maxa.
local swtime is etb/2 - 30.
swadj(swtime).
if wfnow>1 return 1/10.
set Cs to -ccpos*mydir.
set Ct to limit(0,1,1.5-cceta/lt).
lock steering to Cs.
lock throttle to Ct.
return 1/50.
}).
mpadd({
local dt is eta:periapsis.
if dt<0 return mpinc().
if dt<300 set dt to dt+orbit:period.
if mnv_plan:typename = "Node" and mnv_plan:eta<dt return mpinc().
local mnv is mnaph(time:seconds + dt, ccorb:apoapsis).
if abs(mnv:prograde)>1/10 set mnv_plan to mnv.
return mpinc().}).
mpadd({
if apoapsis < 0 return mpinc().
local dt is eta:apoapsis.
if dt<300 set dt to dt+orbit:apood.
if mnv_plan:typename = "Node" and mnv_plan:eta<dt return mpinc().
local mnv is mnaph(time:seconds + dt, ccorb:periapsis).
if abs(mnv:prograde)>1/10 set mnv_plan to mnv.
return mpinc().}).
mpadd({
local err is orbit:argumentofperiapsis-ccorb:argumentofperiapsis.
if abs(err)<1 return mpinc().
local l is "aop:  "
+fmt(orbit:argumentofperiapsis,12,4)
+fmt(ccorb:argumentofperiapsis,12,4)
+fmt(err,12,4)
+" deg".
until false {
break.
}
print l. log l to okto_log.
return mpinc().}).
mpone({if mnv_plan:typename="Node" add mnv_plan.}).
mpadd(pdas). mpadd(mnwait). mpadd(mnexec). mpadd(mnfini). mpadd(pdas).
mpadd({return mpput(mpi_park, 5*wfcmd).}).}
mprun(). print "program terminated".}.
lock wfnow to kuniverse:timewarp:rate.
lock wfcmd to kuniverse:timewarp:ratelist[warp].
