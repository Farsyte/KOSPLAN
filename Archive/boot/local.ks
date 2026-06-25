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
set import to { parameter p.
wait until homeconnection:isconnected.
runoncepath(find(p)).}.
import("go"). go().
