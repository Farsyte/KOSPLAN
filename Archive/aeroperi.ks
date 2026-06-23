import("math").
import("bt").
set aeroperi to {
if ship:LiquidFuel<=eps return mpinc().
local r0 is ship:body:radius.
local r1 is r0 + altitude.
local r2 is r0 + 35000.
local r3 is r0 + apoapsis.
local vo is velocity:orbit:mag.
local vd is vv(r1, r2, r3, body:mu).
local ds is vd - vo.
local dv is ds * prograde:vector.
if tb(ds) or ship:LiquidFuel<=0 {
lock throttle to 0. lock steering to facing. return mpinc(). }
if availablethrust=0 return 1.
lock steering to lookdirup(dv,facing:topvector).
local ae is vang(facing:vector,dv).
local ka is limit(1/100,1,(5-ae)*1.2/5).
local th is limit(0,1,ka*5*dv:mag/ma).
lock throttle to th.
return 1/1000. }.
