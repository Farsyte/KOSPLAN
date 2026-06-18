import("nv").
import("math").
import("fmt").
import("mn").
import("sw").
import("ascent").
import("simplecirc").
import("hud").
set go to {
set okto_log to home:combine("okto.log").
if exists(okto_log) open(okto_log):clear().
log fmt("sa",8,3)+", "+fmt("sf",8,3) to okto_log.
set launch_t0 to nvget(1, "launch_t0", t0).
set launch_az to nvget(1, "launch_az", 90).
set launch_ap to nvget(1, "launch_ap", 80000).
if not nvhas(1,"ccsma") {
print "reading current contract".
import("current_contract").
deletepath("1:/current_contract").
} else print "using saved contract data.".
set ccinc to nvget(1,"ccinc", 0).
set ccecc to nvget(1,"ccecc", 0).
set ccsma to nvget(1,"ccsma", 80000).
set cclan to nvget(1,"cclan", 0).
set ccaop to nvget(1,"ccaop", 0).
set ccmep to nvget(1,"ccmep", 0).
set cctep to nvget(1,"cctep", 0).
set ccbod to nvget(1,"ccbod", "kerbin").
set ccorb to CREATEORBIT(ccinc, ccecc, ccsma, cclan, ccaop, ccmep, cctep, ccbod).
set msgnext to { parameter s. print s. return mpinc(). }.
if stage:number>2
when stage:number<3 and maxthrust=0 and stage:ready then {
stage. return stage:number>0. }
if stage:number>1
when altitude>70000 and stage:ready then {
if stage:number>1 stage. return stage:number>1. }
mpadd({
local th is vcrs(ccorb:position-body:position,ccorb:velocity:orbit):normalized.
local sp is -body:position:normalized.
local sv is ship:velocity:orbit:normalized.
local hp is vdot(th, sp).
local hv is vdot(th, sv).
local angle is arctan2(hv, hp)+180.
local quad is floor(angle/90).
if quad=0 or quad=2 {swadj(body:rotationperiod/8). return 1/10.}
local aeoq is angle-90*quad.
local qeta is aeoq * body:rotationperiod/360.
set qeta to qeta - 2*body:rotationperiod/360.
swadj(qeta-30).
if warp>0 or not kuniverse:timewarp:issettled return 1/10.
log TEE()+": "+
"hp: "+fmt(hp,8,5)+", "+
"hv: "+fmt(hv,8,5)+", "+
"angle: "+fmt(angle,8,3)+", "+
"qeta: "+fmt(qeta,8,3) to okto_log.
if qeta>20 return 1-mod(met()+100,1)-1/10.
t0put(qeta-10).
set launch_t0 to nvput(1, "launch_t0", t0).
set launch_az to nvput(1, "launch_az", choose 356 if hv > 0 else 184).
set launch_ap to nvput(1, "launch_ap", 80000).
return mpinc(). }).
mpadd({
local t is -met().
if t<=5.5 print TEE().
if t<=0.5 return mpinc().
return mod(t,1).
}).
mpone({
if maxthrust>0 return mpinc().
if not stage:ready return 1/10.
lock throttle to 1.
lock steering to facing.
hud("ignition"). stage. t0put(0).
set launch_t0 to nvput(1, "launch_t0", t0).
}).
mpadd({ if alt:radar>=50 return mpinc().
lock throttle to 1. lock steering to facing. return 1/10. }).
mpone({hud("pitchover").}).
mpadd({
if verticalspeed<0 return mpinc().
if altitude>=70000 and apoapsis>=launch_ap return mpinc().
lock af to limit(0,1,altitude/launch_ap).
lock cp to limit(0,90,90-120*sqrt(af)).
lock steering to heading(launch_az, cp, 0).
lock tf to min(1,sqrt(max(0,(launch_ap+20-apoapsis)/1000))).
lock mt to max(eps, ship:availablethrust).
lock throttle to tf*min(1,20*mass/mt).
return 1. }).
mpone({hud("vs="+verticalspeed+", apo="+apoapsis+", la="+launch_ap).}).
mpone({lock throttle to 0. hud("MECO").}).
mpadd({ if altitude>body:atm:height return mpinc().
lock steering to prograde. lock throttle to 0. return 1. }).
mpone({hud("SPACE!").}).
mpone({hud("simplecirc...").}).
mpadd(simplecirc).
mpone({hud("ORBIT!").}).
mprun(). print "program terminated".}.
