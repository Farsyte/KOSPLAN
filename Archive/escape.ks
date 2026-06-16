import("mn").
set escape to {
local dpro is 10.
local t1 is time:seconds + 300.
mnclr().
local mnv is node(t1, 0, 0, dpro). add mnv. wait 0.
local assure_mun_escape is {
until false {
if nextnode:orbit:hasnextpatch return.
set mnv:prograde to mnv:prograde + dpro. wait 0. }}.
local assure_kerbin_ret is {
until false {
assure_mun_escape().
if not nextnode:orbit:nextpatch:hasnextpatch return.
set mnv:time to mnv:time + orbit:period/36. wait 0.}}.
local skip_past_max_ka is {
until false { until false {
assure_kerbin_ret().
local old_ka is nextnode:orbit:nextpatch:semimajoraxis.
set mnv:time to mnv:time + orbit:period/36. wait 0.
if not nextnode:orbit:hasnextpatch break.
if nextnode:orbit:nextpatch:hasnextpatch break.
local new_ka is nextnode:orbit:nextpatch:semimajoraxis.
local chg_ka is new_ka - old_ka.
if chg_ka < 0 return.}}}.
local skip_past_min_ka is {
until false { until false {
assure_kerbin_ret.
local old_ka is nextnode:orbit:nextpatch:semimajoraxis.
set mnv:time to mnv:time + orbit:period/36. wait 0.
if nextnode:orbit:nextpatch:hasnextpatch break.
local new_ka is nextnode:orbit:nextpatch:semimajoraxis.
local chg_ka is new_ka - old_ka.
if chg_ka > 0 return.}}}.
local seek_kerbin_peri is {
parameter des_peri.
parameter eps_dpro is 1/100.
parameter good_enough is 1.
for iter in range(100) {
local old_peri is nextnode:orbit:nextpatch:periapsis.
if abs(des_peri - old_peri) <= good_enough return.
set mnv:prograde to mnv:prograde + eps_dpro. wait 0.
local new_peri is nextnode:orbit:nextpatch:periapsis.
local chg_peri is new_peri - old_peri.
local peri_per_pro is chg_peri / eps_dpro.
set mnv:prograde to mnv:prograde + (des_peri - new_peri) / peri_per_pro. wait 0.}}.
skip_past_max_ka().
skip_past_min_ka().
seek_kerbin_peri(35000).
return mpinc(). }.
