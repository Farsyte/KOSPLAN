import("math").
set t0 to inf.
lock met to time:seconds - t0.
set ydhms to { parameter sec.
if sec < 0 return "-"+ydhms(-sec).
local ts is sec + time - time.
local ts is ts:full.
if ts:startswith("0y") local ts is ts:remove(0,2).
if ts:startswith("0d") local ts is ts:remove(0,2).
if ts:startswith("0h") local ts is ts:remove(0,2).
if ts:startswith("0m") local ts is ts:remove(0,2).
return ts.
}.
