import("mp").
set fancystager to {
local lol is { parameter n. local res is list().
until res:length >= n res:add(list()). return res. }.
local loe is lol(stage:number+1).
for e in ship:engines
loe[e:decoupledin]:add(e).
local lot is lol(stage:number+1).
for p in ship:parts
for res in p:resources
if res:name="LiquidFuel"
lot[p:decoupledin]:add(list(p,res)).
local t is time:seconds.
local mt is 0.
when t <= time:seconds then {
if abort or stage:number<1 return false.
set t to time:seconds + 1.
if not stage:ready or alt:radar<100 return true.
for e in loe[stage:number-1]
if not e:flameout
return true.
for pr in lot[stage:number-1]
if pr[1]:amount>0.01
return true.
stage.
return true. }}.
