set asp to false.
set asn to { parameter Kp, Ki, Kd.
set asp to PIDLOOP(Kp, Ki, Kd, 0, 1).
set asp:setpoint to airspeed.
lock C_throttle to asp:update(time:seconds, airspeed).
lock THROTTLE to C_throttle. }.
set asv to { parameter value.
if asp:typename <> "PIDLoop" return.
print "asv: seeking airspeed "+round(value,1)+" m/s.".
set asp:setpoint to value.
}.
set astest to {
for cmd in list(airspeed-20,140,120,140,160,200) {
asv(cmd).
local matchcount is 0.
until matchcount > 4 { wait 1.
set matchcount to choose matchcount + 1 if abs(airspeed-cmd)<2 else 0.}
}}.
