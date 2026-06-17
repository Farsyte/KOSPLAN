local pad0r is { parameter s,w.
until s:length>=w set s to s+"0". return s. }.
local padbl is { parameter s,w.
until s:length>=w set s to " "+s. return s. }.
set fmt to { parameter u,w. parameter d is 0.
if u:typename="Scalar" {
set u to round(u,d).
set u to (u:tostring+".0"):split(".").
set u to u[0]+(choose ("."+pad0r(u[1],d)) if d>0 else "").
} return padbl(u,w). }.
