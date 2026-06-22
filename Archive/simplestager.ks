set simplestager to {
local t is time:seconds.
local mt is 0.
when t <= time:seconds then { if abort or stage:number<1 return false.
set t to time:seconds + 1. if not stage:ready return true.
set omt to mt. set mt to ship:maxthrustat(0).
if mt<omt or mt=0 stage. return true. }.}.
