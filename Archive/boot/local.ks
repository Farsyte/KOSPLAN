wait until ship:unpacked.
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
if not homeconnection:isconnected {
print "ARCHIVE: no connection. waiting ...".
wait until homeconnection:isconnected.
set warp to 0.
print "ARCHIVE: no connection. waiting ... done".}
runoncepath(find(p)).
}.
import("go"). go().
