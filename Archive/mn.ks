import("math").
import("mp").
import("sw").
import("bt").
import("predict").
import("time").
set mnclr to { for n in allnodes remove n. }.
set mnexec to {
if not hasnode return mpinc().
if warp>0 set warp to 0.
if not kuniverse:timewarp:issettled return 1/10.
if ship:liquidfuel <= 0 return mpinc().
local mnv is nextnode.
if mnv:deltav:mag<1/10 return mpinc().
lock steering to mnv:deltav.
lock mnl_mt to max(eps, maxthrust).
lock mnl_dv to mnv:deltav:mag.
lock mnl_dt to mnl_dv * ship:mass / mnl_mt.
lock mnl_dtdf to limit(0,1,mnl_dt/0.5).
lock mnl_ae to vang(mnv:deltav,facing:vector).
lock mnl_aedf to limit(1/100,1,1-(mnl_ae-1)/4).
lock throttle to sqrt(mnl_dtdf * mnl_aedf).
return min(1,mnl_dt). }.
set mnfini to {
lock throttle to 0.
lock steering to facing.
mnclr().
return mpinc().
}.
set mnwait to {
if not hasnode return mpinc().
local mnv is nextnode.
if mnv:eta <= 0 return mpinc().
local hbt is bt(mnv:deltav:mag/2).
local dt is mnv:eta - hbt.
if dt < 60
lock steering to
choose mnv:deltav
if hasnode and mnv:deltav:mag > 0
else facing.
if dt <= 0 return mpinc().
swadj(dt-30). return 1/10. }.
set mncirc to {
mnclr().
local dt is min(eta:periapsis, eta:apoapsis).
if dt>0 and dt<inf {
local t is time:seconds+dt.
local dv is sqrt(body:mu/posat(t,ship):mag)-velat(t,ship):mag.
if abs(dv)*mass*1000>=maxthrust add node(t,0,0,dv).
} return mpinc(1/50).}.
set mnaph to {
parameter t.
parameter h.
local mu is body:mu.
local r0 is body:radius.
local r1 is posat(t,ship).
local v1 is velat(t,ship).
local vr is vdot(v1,r1:normalized).
local dp is burndv(r1:mag,r0*2+apoapsis+periapsis-r1:mag,r0+h,mu).
return node(t,-vr,0,dp). }.
set mnatp to { parameter des_apo. return {
mnclr().
if eta:periapsis<0 return mpinc().
local mnv is mnaph(time:seconds+eta:periapsis,des_apo).
if bt(mnv:prograde)>1/1000 add mnv.
return mpinc(1/50).}.}.
set mnata to { parameter des_peri. return {
mnclr().
if apoapsis<0 return mpinc().
local mnv is mnaph(time:seconds+eta:apoapsis,des_peri).
if bt(mnv:prograde)>1/1000 add mnv.
return mpinc(1/50).}.}.
