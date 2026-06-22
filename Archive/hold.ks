import("mp").
set mphold_thrust to {
mpadd({
return choose mpinc() if maxthrust>0 else 1/100.}).}.
set mphold_brakes to {
mpadd({
if not brakes return 1/10.
brakes off. return mpinc().}).}.
set mphold_sas to {
mpadd({
if not sas return 1/10.
sas off. return mpinc().}).}.
set mphold_rcs to {
mpadd({
if not rcs return 1/10.
rcs off. return mpinc().}).}.
set mphold_bay to {
mpadd({
if bays return 1/10.
return mpinc().}).}.
