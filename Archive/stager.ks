import("mp").
set stager to { 
local t is time:seconds.
local mt is 0.
when t <= time:seconds then { if abort or stage:number<1 return false.
set t to time:seconds + 1/10. if not stage:ready return true.
set omt to mt. set mt to ship:maxthrustat(0).
if mt>=omt return true.
print "autostaging". stage. return true. }.}.
set fancystager to {
local lol is { parameter n. local res is list().
until res:length >= n res:add(list()). return res.}.
local loe is lol(stage:number+1).
local lot is lol(stage:number+1).

for e in ship:engines
loe[e:decoupledin]:add(e).

for p in ship:parts
for res in p:resources
print res:name+": "+res:amount.

for p in ship:parts
for res in p:resources
if res:name="LiquidFuel"
lot[p:decoupledin]:add(list(p,res)).

for s in range(0,stage:number+1) {
  print " ".
  print "stage "+s+" engines:".
  for e in loe[s]
    print e:title.
  print "stage "+s+" fuel:".
  for pr in lot[s]
    print pr[0]:title+" has "+pr[1]:amount+" "+pr[1]:name.
}

local t is time:seconds.
local mt is 0.
when t <= time:seconds then { if abort or stage:number<1 return false.
set t to time:seconds + 1. if not stage:ready return true.

local sn is stage:number-1.
print "autostager: sn "+sn.

for e in loe[sn] {
  if not e:flameout {
    print "engine "+e:title+" is not flameout.".
    return true.
  }
  print "engine "+e:title+" is flameout.".
}

for pr in lot[sn] {
  if pr[1]:amount>0 {
    print pr[0]:title+" has "+pr[1]:amount+" "+pr[1]:name.
    return true.
  }
  print pr[0]:title+" has "+pr[1]:amount+" "+pr[1]:name.
}

if alt:radar < 100 {
  print "alt:radar is "+round(alt:radar)+", not staging.".
  return true.
}
print "autostaging". stage. return true. }.}.
