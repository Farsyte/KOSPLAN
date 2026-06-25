import("mp").
import("airspeed").
set go to {
local lf is home:combine("takeoff.log").
deletepath(lf).
log "Alt,GS,VS" to lf.
when SAS then{
print "SAS activated. You have the stick.".
unlock steering.
return false. }
mpone({
BRAKES ON.
set Ct to 1.
lock throttle to Ct.
lock steering to heading(90, 5, 0).
}).
mpadd({
print "Activate engines to launch".
return choose mpinc() if availablethrust>0 else 2.}).
mpadd({ if ship:thrust>availablethrust/4 or groundspeed>2 return mpinc(). return 1/10. }).
mpone({ BRAKES OFF. }).
mpadd({ if groundspeed<60 return 1/10.
lock steering to heading(90, 15, 0). return mpinc(). }).
mpadd({ if altitude>=2000 return mpinc().
log round(alt:radar)+","+round(groundspeed,1)+","+round(verticalspeed,1) to lf.
return 1/10.}).
mpadd({
asn(1/10,1/1000,1).
astest().
until abort { }}).
mprun(). print "program terminated".}.
