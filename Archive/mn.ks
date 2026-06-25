import("math").
import("mp").
import("sw").
import("bt").
import("predict").
import("time").
set mnclr to { for n in allnodes remove n. }.
set mnexec to { mpadd({
if not hasnode return mpinc().
if warp>0 set warp to 0.
if not kuniverse:timewarp:issettled return 1/10.
if ship:liquidfuel <= 0 { mnclr(). return mpinc(). }
local mnv is nextnode.
local dv is mnv:deltav:mag.
local dt is bt(dv).
if dv<1/10 or dt<1/1000 {
lock throttle to 0.
lock steering to facing.
remove mnv.
return mpinc().
}
lock steering to mnv:deltav.
lock throttle to sqrt(
limit(0,1,2*mnv:deltav:mag*ship:mass/max(eps,availablethrust)) *
limit(1/100,1,1-(vang(mnv:deltav,facing:vector)-1)/4)).
return 1.}).}.
set mnfini to { mpadd({
lock throttle to 0.
lock steering to facing.
mnclr().
return mpinc().}).}.
set mnwait to { mpadd({
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
swadj(dt-30). return 1/10. }). }.
