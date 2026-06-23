import("time").
set swra to LIST(0, 4, 6, 30, 60, 600, 6000, 60000).
set wftune to {
local rl is kuniverse:timewarp:railsratelist.
for wf in range(rl:length) {
set warp to wf.
wait until kuniverse:timewarp:issettled.
wait 1/10.
set dt to time:seconds.
set warp to 0.
wait until kuniverse:timewarp:issettled.
wait 1/10.
set dt to ceiling(time:seconds - dt).
print "for wf "+wf+", dt is "+dt+" seconds.".
}
}.
set wfnow to { return kuniverse:timewarp:rate. }.
set wfcmd to { return kuniverse:timewarp:ratelist[warp]. }.
set mpsw0 to { mpadd({
if warp>0 set warp to 0.
return choose mpinc() if kuniverse:timewarp:issettled else 1/10.}).}.
set swend to {
if warp>0 set warp to 0.
wait until kuniverse:timewarp:issettled.}.
set swfac to { parameter dt.
local i is swra:length - 1.
until i=0 or dt>swra[i]
set i to i - 1.
return i.}.
set swadj to { parameter dt.
set o to warp.
set n to swfac(dt).
if o = n return.
if o = 0 set kuniverse:timewarp:mode to "RAILS".
set warp to n.}.
