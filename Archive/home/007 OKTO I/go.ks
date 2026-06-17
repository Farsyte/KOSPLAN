import("ascent").
import("fancystager").
import("hud").
import("fmt").
import("ltso").
import("plan").
import("time").
import("mp").
import("simplecirc").
set sat_apo to 14561934.
set sat_peri to 11827733.
set sat_inc to 90.0.
set sat_lan to 92.7.
set sat_aop to 34.0.
set sat_orb to soget(sat_apo, sat_peri, sat_inc, sat_lan, sat_aop).
plan(sat_apo, sat_peri).
set go to {
t0put(0).
set msgnext to { parameter s. print s. return mpinc(). }.
fancystager().
local data_csv is home:combine("data.csv").
deletepath(data_csv).
local ll is
TEE()+","+
fmt("angle_1",8,3)+","+
fmt("whichway",8,3)+","+
fmt("h_dot_p",8,3)+","+
fmt("h_dot_v",8,3).
print ll.
log ll to data_csv.
mpadd({
if next_time>time:seconds return time:seconds-next_time.
set next_time to time:seconds + time_per_print.
local P is body:rotationperiod.
local time_per_print is P/360.
local next_time is time:seconds.
print "Rotation period is "+ydhms(P).
print "Time per Degree is "+ydhms(P/360).
local sat_h is vcrs(sat_orb:position-body:position,sat_orb:velocity:orbit).
local sat_norm is sat_h:normalized.
local body_to_ship is -body:position:normalized.
local body_ship_v is ship:velocity:orbit:normalized.
local angle_1 is vang(body_to_ship, sat_norm).
local whichway is vdot(north:vector,vcrs(body_to_ship,sat_norm)).
local h_dot_p is vdot(sat_norm, body_to_ship).
local h_dot_v is vdot(sat_norm, body_ship_v).
local ll is
fmt(angle_1,8,3)+","+
fmt(whichway,8,3)+","+
fmt(h_dot_p,8,3)+","+
fmt(h_dot_v,8,3).
print ll.
log ll to data_csv.
return 5.
}).
mprun(). print "program terminated".}.
