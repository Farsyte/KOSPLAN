import("mp").
local voice is getvoice(0).
set slide_u to slidenote(440,880,0.2,0.25,1).
set slide_d to slidenote(880,440,0.2,0.25,1).
set mpchime to { parameter n. return mpone({getvoice(0):play(n).}).}.
set mphold_thrust to {
mpchime(slide_u).
mpstat("Activate Engines to Continue").
mpadd({ return choose mpinc() if availablethrust>0 else 1/100. }).
mpchime(slide_d).
mpstat("Resuming Mission").}.
set mphold_brakes to {
mpchime(slide_u).
mpone({brakes on.}).
mpstat("Release Brakes to Continue").
mpadd({ return choose 1/10 if brakes else mpinc(). }).
mpchime(slide_d).
mpstat("Resuming Mission").}.
set mphold_sas to {
mpchime(slide_u).
mpone({sas off.}).
mpstat("Activate SAS to Continue").
mpadd({ if not sas return 1/10. sas off. return mpinc().}).
mpchime(slide_d).
mpstat("Resuming Mission").}.
set mphold_rcs to {
mpchime(slide_u).
mpone({rcs off.}).
mpstat("Activate RCS to Continue").
mpadd({ if not rcs return 1/10. rcs off. return mpinc().}).
mpchime(slide_d).
mpstat("Resuming Mission").}.
set mphold_bay to {
mpchime(slide_u).
mpone({bays on.}).
mpstat("Close Bays to Continue").
mpadd({if bays return 1. return mpinc().}).
mpchime(slide_d).
mpstat("Resuming Mission").}.
