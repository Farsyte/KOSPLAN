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
