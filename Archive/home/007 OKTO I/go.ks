import("ascent").
import("fmt").
import("hud").
import("math").
import("mnpro").
import("nv").
import("simple").
import("sw").
import("current_contract").
local okto_log_file is home:combine("okto.log").
set okto_log to { parameter m. log TEE()+m to okto_log_file. }.
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
set go to {
if stage:number>0
when stage:ready and (
(stage:number=3) or
(stage:number=2 and altitude>70000) or
(stage:number<3 and availablethrust=0)) then {
stage. lock throttle to 0. return stage:number>0.}
mpstat("Waiting for Launch Window").
mpadd({
local th is vcrs(ccorb:position-body:position,ccorb:velocity:orbit):normalized.
local sp is -body:position:normalized.
local sv is ship:velocity:orbit:normalized.
local hp is vdot(th, sp).
local hv is vdot(th, sv).
local angle is arctan2(hv, hp)+180.
local quad is floor(angle/90).
if quad=0 or quad=2 {
swadj(body:rotationperiod/8).
return wfcmd()/10.
}
local aeoq is angle-90*quad.
local qeta is aeoq * body:rotationperiod/360.
set qeta to qeta - 2*body:rotationperiod/360.
swadj(qeta-30).
if wfnow()>1 return 1/100.
if qeta>20 return mod(qeta+9.9,1).
local dfi is { parameter incl, hv.
local az is choose 450-incl if hv>0 else 450+incl.
local afh to abs(90-incl)-90.
if hv<0 set afh to -afh.
return mod(az+afh*4/90, 360).}.
t0put(qeta-10).
set launch_t0 to nvput(1, "launch_t0", t0).
set launch_az to nvput(1, "launch_az", dfi(ccinc,hv)).
set launch_ap to nvput(1, "launch_ap", 80000).
okto_log(" launch AZ "+fmt(launch_az,0,1)+" AP "+fmt(launch_ap/1000,0,1)).
HUD("Will launch in "+round(t0-time:seconds,1)+" seconds.").
return mpinc(). }).
mpcount().
mpstat("Launching").
mplaunch().
mpstat("Powered Ascent").
mpascent(launch_az,launch_ap).
mpstat("Unpowered Ascent").
mpcoast().
mpstat("Circularization").
mpcirc().
mpstat("Parking Orbit").
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
mpstat("Transfer to Assigned Orbit").
mppdas(). mnwait(). mnexec(). mnfini(). mppdas().
mnata(ccorb:periapsis). mppdas().
mnatp(ccorb:apoapsis). mppdas().
{ local mpi_park is mpl:length.
if mpi>=mpi_park {
print "rewind MPI from "+mpi+" to "+mpi_park.
mpput(mpi_park).
}
mpstat("Maintain Assigned Orbit").
mnclr(). mppdas().
mpstat("Check Assigned Orbit: Plane").
mpadd({
local ie is orbit:inclination-ccorb:inclination.
local le is orbit:lan-ccorb:lan.
if abs(ie)<=1/10 and abs(le)<=1/10 {
lock throttle to 0.
lock steering to facing.
set warp to 0.
return mpinc().
}
local ccdir is vcrs(ccorb:position-body:position,ccorb:velocity:orbit):normalized.
local ccpos is vdot(ccdir,body:position).
local ccvel is vdot(ccdir,velocity:orbit).
if ccpos*ccvel<=0 {
swadj(orbit:period/8).
return 1/10.}
local mydir is vcrs(-body:position,velocity:orbit):normalized.
local cceta is ccpos / ccvel.
local lt is abs(ccvel)*2/maxa.
local etb is cceta - lt.
local ld is ccvel^2/maxa.
local swtime is etb/2 - 30.
swadj(swtime).
if wfnow()>1 {return 1/10.}
set Cs to -ccpos*mydir.
set Ct to limit(0,1,1.5-cceta/lt).
lock steering to Cs. lock throttle to Ct. return 1/50.}).
mpstat("Check Assigned Orbit: AOP").
mpadd({
local aop_curr is orbit:argumentofperiapsis.
local aop_want is ccorb:argumentofperiapsis.
local adj is aop_want-aop_curr.
if abs(adj)<1 return mpinc().
local ang_burn is ua(aop_curr + ua(adj)/2).
local adir is angleaxis(-orbit:lan, V(0,1,0)) * solarprimevector.
local hdir is angleaxis(-orbit:inclination,adir) * V(0,1,0).
local newpe is angleaxis(-aop_want,hdir) * adir.
local vdap is vcrs(hdir,newpe):normalized.
{
local startpos is body:position.
local veclen is body:radius + periapsis.
clearvecdraws().
local ana is vecdraw(startpos, adir*veclen, blue,"Ascending Node",1,true).
local nva is vecdraw(startpos, hdir*veclen, green,"Normal",1,true).
local pvc is vecdraw(startpos, newpe*veclen, cyan,"New PE",1,true).
local pvd is vecdraw(startpos-newpe*(body:radius+apoapsis), vdap*veclen, red,"vdap",1,true).
}
return mpinc().}).
mpstat("Check Assigned Orbit: Periapsis").
mnata(ccorb:periapsis).
mppdas().
mpstat("Check Assigned Orbit: Apoapsis").
mnatp(ccorb:apoapsis).
mppdas().
mpstat("Check Assigned Orbit: Done").
mpadd({return mpput(mpi_park, 10).}).}
mprun(). print "program terminated".}.
