import("mp").
import("mnpro").
import("hold").
import("aero").
import("fancystager").
import("ascent").
import("simple").
set go to {
fancystager().
mpone({bays off.}).
mplaunch().
mpstat("Powered Ascent").
mpascent(90,80000).
mpstat("Unpowered Ascent").
mpcoast().
mpstat("Circularizing").
mpcirchere().
mpone({bays on.}).
mpaero().
mprun(). print "program terminated".}.
