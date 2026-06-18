import("math").
import("nv").
set t0 to nvget(1, "t0", inf).
local met_h is { return -3600. }.
local met_f is { return time:seconds - t0. }.
set met to choose met_f if t0 < inf else met_h.
set t0put to { parameter dt.
set t0 to nvput(1, "t0", TIME:SECONDS+dt).
set met to choose met_f if t0 < inf else met_h.
return t0. }.
set ydhms to { parameter sec.
set sec to round(sec).
if sec<0 return "-"+ydydhms(-sec).
local ts is TIMESTAMP(round(sec)).
if ts:year<2 and ts:day<2 return ts:CLOCK.
if ts:year<2 return (ts:day-1)+"d+"+ts:CLOCK.
return (ts:year-1)+"y "+(ts:day-1)+"d+"+ts:CLOCK.
}.
set TEE to { local t is met().
return "T"+(choose "-" if t<0 else "+")+ydhms(abs(t)). }.
