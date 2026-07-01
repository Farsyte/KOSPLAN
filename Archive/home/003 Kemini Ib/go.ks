import("mp").
import("hold").
import("fancystager").
import("simple").
import("ascent").
import("aero").
set go to {
fancystager().
mphold_thrust().
mplaunch().
mpstat("Powered Ascent").
mpascent(355,80000).
mpstat("Unpowered Ascent").
mpcoast().
mpstat("Circularizing").
mpcirchere().
mpstat("Science Orbit").
mppdab().
mphold_brakes().
mpaero().
mprun(). print "program terminated".}.
