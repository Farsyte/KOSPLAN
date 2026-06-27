import("math").
import("pre").
set tb to { parameter dv.
return (abs(dv)<1/10) or (abs(dv)*mass*1000<availablethrust).}.
set bt to { parameter dv.
local dt is 0.
local s is stage:number.
local m is ship:mass.
local f is availablethrust.
local d is stage:deltav:vacuum.
until false {
local d is min(d, dv).
if d>0 and f>0 {
set dv to dv-d.
local gi is sisp[s].
local d is m * gi * (1 - e^(-d/gi)) / f.
set dt to dt + d.
if dv<=0 return dt. }
if s<1 return dt.
set s to s - 1.
set dt to dt + 3.
set m to swet[s].
set f to sthr[s].
set d to ship:stagedeltav(s):vacuum.}}.
