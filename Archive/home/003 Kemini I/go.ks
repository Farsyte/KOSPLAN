import("mp").
import("hold").
import("fancystager").
import("simple").
import("ascent").
import("aero").
set go to {
brakes off.
fancystager().
mpstat("Waiting for Launch").
mphold_thrust().
mplaunch().
mpstat("Powered Ascent").
mpascent(90,80000).
mpstat("Unpowered Ascent").
mpcoast().
mpstat("Circularizing").
mpcirc().
mpstat("Science Orbit").
mppdab().
mphold_brakes().
mpaero().
mprun(). print "program terminated".}.
