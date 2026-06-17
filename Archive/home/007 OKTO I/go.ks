import("nv").
import("math").
import("fmt").
import("fancystager").
import("mn").
import("sw").
set go to {
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
import("plan"). deletepath("1:/plan.ks").
plan_sat(80000,ccorb:periapsis,ccorb:apoapsis,ccorb:body).
t0put(0).
set msgnext to { parameter s. print s. return mpinc(). }.
fancystager().
local data_csv is home:combine("data.csv").
deletepath(data_csv).
local ll is
TEE()+","+
fmt("h dot p",8,3)+","+
fmt("h dot v",8,3)+","+
fmt("angle",8,3)+","+
fmt("quad",5,0)+","+
fmt("aeoq",8,3)+","+
fmt("qeta",8,3).
print "ll                      "+ll.
log ll to data_csv.
local next_log_time is time:seconds.
mpadd({
local th is vcrs(ccorb:position-body:position,ccorb:velocity:orbit):normalized.
local sp is -body:position:normalized.
local sv is ship:velocity:orbit:normalized.
local h_dot_p is vdot(th, sp).
local h_dot_v is vdot(th, sv).
local angle is arctan2(h_dot_v, h_dot_p)+180.
local quad is floor(angle/90).
if quad=0 or quad=2 {swadj(body:rotationperiod/8). return 1/10.}
local aeoq is angle-90*quad.
local dadt is 360/body:rotationperiod.
local qeta is aeoq / dadt.
swadj(qeta-30).
if warp>0 or not kuniverse:timewarp:issettled return 1/10.
set next_log_time to next_log_time + body:rotationperiod/360.
local ll is TEE()+","+
fmt(h_dot_p,8,3)+","+
fmt(h_dot_v,8,3)+","+
fmt(angle,8,3).
set ll to ll+","+fmt(quad,5,0)+","+fmt(aeoq,8,3)+","+fmt(qeta,8,3).
print "ll                      "+ll.
log ll to data_csv.
return mod(qeta-1/10,5).
}).
mprun(). print "program terminated".}.
import("nv").
import("math").
import("fmt").
import("fancystager").
import("mn").
