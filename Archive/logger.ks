import("time").
import("mp").
local lq is list().
on homeconnection:isconnected {
if homeconnection:isconnected
for lg in lq lg("").
return true.}
set mklogger to { parameter n.
local lfn is home:combine(n+".log").
local lfq is queue().
local prev is "".
if mpi=0 and homeconnection:isconnected and exists(lfn)
open(lfn):clear().
local lfd is { parameter m.
if m:length>0 and m<>prev {
lfq:push(TEE()+" "+m).
set prev to m.
}
if homeconnection:isconnected
until lfq:empty
log lfq:pop to lfn.}.
lfd("log starts").
lq:add(lfd).
return lfd.}.
