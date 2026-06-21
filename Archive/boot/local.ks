wait until ship:unpacked.
if not homeconnection:isconnected
print "WARNING: no connection to archive".
set home to path("0:/home"):combine(ship:name).
set find to { parameter p.
set d to home.
until false {
set n to d:combine(p).
if exists(n) return n.
if d:length < 1 return home:combine(p).
set d to d:parent.}}.
set ius to uniqueset("import").
set import to { parameter p.
if ius:contains(p) return.
ius:add(p).
wait until homeconnection:isconnected.
runpath(find(p)). }.
import("go"). go().
