import("math").
import("time").
import("fmt").
import("mn").
set plan to { parameter park, apo, peri, b.
local r0 is b:radius.
local mu is b:mu.
local r1 is r0 + park.
local r2 is r0 + apo.
local r3 is r0 + peri.
local v0 is velocity:orbit:mag.
local v1 is visviva(r1, r1,r2, mu).
local v2 is visviva(r2, r1,r2, mu).
local v3 is visviva(r2, r3,r2, mu).
return list(v1-v0, v3-v2).}.
set plan_nodes to { parameter t1, apo, peri.
local result is plan(altitude, apo, peri, body).
local b1 is result[0].
local b2 is result[2].
mnclr().
local mn1 is node(t1, 0, 0, b1).
add mn1. wait 0.
local mn2 is node(t1+mn1:eta, 0, 0, b2).
add mn2. wait 0.
return list(mn1, mn2).
}.
