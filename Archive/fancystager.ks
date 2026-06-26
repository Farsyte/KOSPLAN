import("mp").
import("agl").
import("time").
local slf is home:combine("stager.log").
local lls is "".
local sl is { parameter m.
if m=lls return.
set lls to m.
log TEE()+": "+m to slf.
}.
if met()<0 and exists(slf) open(slf):clear().
sl("package loaded").
local lol is { parameter n. local res is list().
until res:length >= n res:add(list()). return res. }.
local loe is lol(stage:number+1).
for en in ship:engines
if en:decoupledin>=0
loe[en:decoupledin]:add(en).
local lot is lol(stage:number+1).
for p in ship:parts
if p:decoupledin>=0
for res in p:resources
if res:name="LiquidFuel"
lot[p:decoupledin]:add(list(p,res)).
local lof is lol(stage:number+1).
for p in ship:parts
if p:hasmodule("FaringSometing")
lof[p:stage]:add(p).
for s in range(stage:number+1) {
sl("Stage "+s+" summary:").
for en in loe[s] sl("- drop "+en:title).
for ft in lot[s] sl("- drop "+ft[0]:title).
for lc in lof[s] sl("- activate "+lc:title).
}
set fancystager to {
local t is time:seconds.
when t <= time:seconds then {
if abort {sl("abort"). return false.}
if stage:number<1 { sl("stage is 0"). return false. }
set t to time:seconds+1/10.
if not stage:ready { sl("not ready"). return true. }
if met()<=0 { sl("not launched"). return true. }
for en in loe[stage:number-1]
if not en:flameout {
sl("engine "+en:title+" active"). return true.}
for pr in lot[stage:number-1]
if pr[1]:amount>0.02 {
sl("tank "+pr[0]:name+" not empty"). return true.}
stage. sl("stage to "+stage:number). return true. }}.
