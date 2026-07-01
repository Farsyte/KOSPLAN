import("mp").
import("sw").
import("fmt").
import("time").
import("logger").
local log_stager is mklogger("fancystager").
local lol is { parameter n. local res is list().
until res:length >= n res:add(list()). return res. }.
local loe is lol(stage:number+1).
for en in ship:engines
if en:decoupledin>=0
loe[en:decoupledin]:add(en).
local lolf is lol(stage:number+1).
for p in ship:parts
if p:decoupledin>=0
for res in p:resources
if res:name="LiquidFuel"
lolf[p:decoupledin]:add(list(p,res)).
local loox is lol(stage:number+1).
for p in ship:parts
if p:decoupledin>=0
for res in p:resources
if res:name="Oxidizer"
loox[p:decoupledin]:add(list(p,res)).
local lof is lol(stage:number+1).
for p in ship:parts
if p:hasmodule("FaringSometing")
lof[p:stage]:add(p).
set fancystager to {
local t is time:seconds.
when t <= time:seconds then {
if abort or stage:number<1 return false.
set t to time:seconds+1/10.
if not stage:ready or met()<=0 return true.
for en in loe[stage:number-1]
if not en:flameout return true.
local tlf is 0.
for pr in lolf[stage:number-1]
set tlf to tlf + pr[1]:amount.
local tox is 0.
for pr in loox[stage:number-1]
set tox to tox + pr[1]:amount.
for pr in lolf[stage:number-1]
log_stager("observed "+
fmt(pr[1]:amount,8,4)+" "+
pr[1]:name+" in "+pr[0]:title).
for pr in loox[stage:number-1]
log_stager("observed "+
fmt(pr[1]:amount,8,4)+" "+
pr[1]:name+" in "+pr[0]:title).
log_stager("total "+
fmt(tlf,8,4)+" lf, "+
fmt(tox,8,4)+" ox "+
"in stage "+stage:number).
if tlf>0.01 and tox>0.01 return true.
if warp>0 set warp to 0.
if not kuniverse:timewarp:issettled {
wait until kuniverse:timewarp:issettled.
wait until vang(steering:vector,facing:vector)<5.
wait 1.}
log_stager("staging from stage "+stage:number).
stage. return true. }}.
