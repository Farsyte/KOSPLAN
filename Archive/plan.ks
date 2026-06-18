import("nv").
import("math").
import("fmt").
import("fancystager").
import("mn").
local pt is {parameter h1,h2,h3,h4,dv.
print ("ΔV "+po(h1,h2)+" to "+po(h3,h4)+": "):padright(40)+fmt(dv,5,0)+" m/s". return dv.}.
local po is {parameter h1,h2. return round(min(h1,h2)/1000)+"x"+round(max(h1,h2)/1000).}.
local pb is {parameter h1,h2,h3,b. return pt(h1,h2,h1,h3, burndvh(h1,h2,h3,b)). }.
set plan_sat to {
parameter park_h.
parameter sat_peri.
parameter sat_apo.
parameter b.
local b2 is pb(park_h,park_h,sat_apo,b).
local b3 is pb(sat_apo,park_h,sat_peri,b).
return list(b2,b3,pt(park_h,park_h,sat_peri,sat_apo,b2+b3)).
}.
