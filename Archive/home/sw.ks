import("mn").
set swra to LIST(0, 4, 6, 30, 60, 600, 6000, 60000).
set swend to {
if warp>0 set warp to 0.
if not kuniverse:timewarp:issettled return 1/10.
return mpinc(). }.
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
