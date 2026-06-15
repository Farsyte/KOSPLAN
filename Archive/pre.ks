import("math").
set swet to list().
local s is 0.
until s>stage:number {
local m is 0.
for pt in ship:parts
if pt:decoupledin<s
set m to m+pt:wetmass.
swet:add(m).
set s to s+1.}
set sthr to list().
local s is 0.
until s>stage:number {
local t is 0.
for en in ship:engines
if en:stage>=s and en:decoupledIn<s
set t to t+en:possiblethrustat(0).
sthr:add(t).
set s to s+1.}
set sisp to list().
local s is 0.
until s>stage:number {
local i is 0.
local t is sthr[s].
if t>0 {
for en in ship:engines
if en:stage>=s and en:decoupledIn<s
set i to i+en:ispat(0)*en:possiblethrustat(0).
set i to g0*i/t. }
sisp:add(i).
set s to s+1.}
