import("agl").
import("nv").
import("fmt").
import("time").
set mss to nvget(1,"status","KOSPLAN Initializing").
set putstat to { parameter m.
set mss to nvput(1,"status",m). }.
set mpstat to { parameter m. return mpone({putstat(m).}).}.
set mpcount to { mpadd({
local t is -met().
local d is round(t).
if d<=1 mpinc().
if d<=5 hud(TEE()).
return t-round(t-1)-1/50.}).} .
set mplaunch to {
mpone({t0put(0).}).
mpstat("Ignition").
mpadd({
if agl()>50 return mpinc().
lock steering to facing.
lock throttle to 1.
if availablethrust>0 return 1/100.
if stage:ready stage.
return 1/100.}).}.
.
set mpmeco to {mpadd({
lock throttle to 0.
lock steering to prograde.
return mpinc().}).}.
set mpcoast to {mpadd({
if altitude>=body:atm:height or verticalspeed<0 return mpinc().
lock throttle to 0. lock steering to prograde. return 1.}).}.
set mpcirc to {
mpadd({
if periapsis>apoapsis-100 return mpinc().
lock steering to prograde.
lock throttle to max(0,min(1,(2-eta:apoapsis/10))) *
max(1/100,min(1,1-vang(steering:vector,prograde:vector)/5)).
return 1.}).
mpone({ lock throttle to 0. lock steering to prograde.}).}.
set mppdab to { mpadd({ lock throttle to 0. bays on. lights on.
lock steering to lookdirup(vcrs(body:position,ship:velocity:orbit),-body:position).
local fa is vang(facing:forevector,steering:forevector).
local ua is vang(facing:upvector,steering:upvector).
if fa<5 and ua<5 mpinc(). return 1. }).}.
set mppdas to { mpadd({ lock throttle to 0. bays on. lights on.
lock steering to lookdirup(vcrs(sun:velocity:orbit,sun:position),-sun:position).
local fa is vang(facing:forevector,steering:forevector).
local ua is vang(facing:upvector,steering:upvector).
if fa<5 and ua<5 mpinc(). return 1. }).}.
set pr to { parameter u,w.
if w<1 return "".
return u:tostring:trim:padright(w):substring(0,w).}.
set pl to { parameter u,w.
if w<1 return "".
return u:tostring:trim:padleft(w):substring(0,w).}.
set openterm to {
if career():candoactions
core:part:getmodule("kOSProcessor"):
doevent("Open Terminal").}.
set pagenew to {
openterm().
set tw to terminal:width-1.
clearscreen.
for i in range(24) print pr(" ",tw-1).
}.
set pageupdate to {
set tw to terminal:width-1.
print pr(time:full,tw-1) at (0,0).
print pr(TEE(),16) at (0,1).
print pr(ship:name,tw-17) at (16,1).
print pr(status,16) at (0,2).
print pr(mss,tw-17) at (16,2).
local ps is fmt(periapsis/1000,0,1).
if periapsis<0 or ps:length>7 set ps to "***".
local as is fmt(apoapsis/1000,0,1).
if apoapsis<0 or as:length>7 set as to "***".
print pr("",16) at (0,3).
print pr(body:name,7) at (16,3).
print pr(ps+"x"+as+" km",20) at (24,3).
print pr(fmt(orbit:inclination,5,1)+"°", tw-45) at (44,3).
}.
pagenew().
set pagetime to round(time:seconds).
when pagetime<=time:seconds then {
set pagetime to round(time:seconds + 1)+1/50.
pageupdate(). return not abort. }
