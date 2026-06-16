import("mp").
import("math").
set gpl to {
local l is list(). if not hasnode return l.
local o is nextnode:orbit.
until false {
l:add(o:periapsis).
if not o:hasnextpatch return l.
set o to o:nextpatch. }}.
set xfer to { parameter target_name. return {
local dest is body(target_name).
local mu is body:mu.
local target_flyby_altitude is 45000.
local return_altitude is 45000.
local planned_beyond is dest:soiradius / 2.
local t1_min is time:seconds + 300.
local t1 is t1_min + 300.
local t2 is t1.
mnclr().
local mnv is node(t1, 0, 0, 0). add mnv. wait 0.
local xapo is { parameter beyond.
set t2 to time:seconds + mnv:orbit:eta:apoapsis.
local curr_r is posat(t1, ship):mag.
local new_rmax is posat(t2, dest):mag + beyond.
local old_rmin is mnv:orbit:periapsis + mnv:orbit:body:radius.
local old_rmax is mnv:orbit:apoapsis + mnv:orbit:body:radius.
local v1 is visviva(curr_r, old_rmin, old_rmax, mu).
local v2 is visviva(curr_r, old_rmin, new_rmax, mu).
set mnv:prograde to mnv:prograde + v2 - v1. wait 0. }.
xapo(planned_beyond).
xapo(planned_beyond).
local first_est_time is nextnode:time.
local first_est_dpro is nextnode:prograde.
local ae is 0.
local daedt is 0.
local measure_daedt is {
if mnv:orbit:hasnextpatch return false.
local old_ae is vang(posat(t2, ship), posat(t2, dest)).
set t1 to t1 + 1. set mnv:time to t1. wait 0.
if mnv:orbit:hasnextpatch return false.
set ae to vang(posat(t2, ship), posat(t2, dest)).
set daedt to ae - old_ae. return true. }.
until measure_daedt() {
set t1 to t1 + orbit:period/36.
set mnv:time to t1. wait 0. }
local dt is -ae / daedt.
set t1 to t1 + dt.
until t1 > t1_min
set t1 to t1 + 1/(1/orbit:period + 1/dest:orbit:period).
set mnv:time to t1. wait 0.
local fix_aero_using_prograde is {
local pstep is 1/100.
local hr is return_altitude.
local hm is hr - 1000.
local hp is hr + 1000.
local good_dpro is mnv:prograde.
until false {
local pl is gpl(). if pl:length < 3 {
set mnv:prograde to good_dpro. wait 0. break. }
set good_dpro to mnv:prograde.
local h1 to pl[2].
if hm <= h1 and h1 <= hp break.
set mnv:prograde to mnv:prograde + pstep. wait 0.
local pl is gpl(). if pl:length < 3 {
set mnv:prograde to good_dpro. wait 0. break. }
local h2 is pl[2].
local peri_per_dpro is (h2 - h1) / pstep.
local adj_dpro to (hr - h2) / peri_per_dpro.
set mnv:prograde to mnv:prograde + adj_dpro. wait 0. }}.
local fix_flyby_using_time is {
local tstep is 1/1000.
local hr is target_flyby_altitude.
local hm is hr - 1000.
local hp is hr + 1000.
local good_time is mnv:time.
until false {
fix_aero_using_prograde().
local pl is gpl(). if pl:length < 3 {
set mnv:time to good_time. wait 0. break.}
set good_time to mnv:time.
local h1 to pl[1].
if hm <= h1 and h1 <= hp break.
set mnv:time to mnv:time + tstep. wait 0.
local pl is gpl(). if pl:length < 3 {
set mnv:time to good_time. wait 0. break. }
local h2 is pl[1].
local peri_per_time is (h2 - h1) / tstep.
local adj_time to (hr - h2) / peri_per_time.
set mnv:time to mnv:time + adj_time/10.
wait 0. }}.
fix_flyby_using_time().
return mpinc(). }.}.
