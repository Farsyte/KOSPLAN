import("mp").
set mphold_thrust to {
mpstat("Activate Engines to Continue").
mpadd({return choose mpinc() if maxthrust>0 else 1/100.}).
mpstat("Resuming Mission").}.
set mphold_brakes to {
mpone({brakes on.}).
mpstat("Release Brakes to Continue").
mpadd({ return choose 1/10 if brakes else mpinc(). }).
mpstat("Resuming Mission").}.
set mphold_sas to {
mpone({sas off.}).
mpstat("Activate SAS to Continue").
mpadd({ if not sas return 1/10. sas off. return mpinc().}).
mpstat("Resuming Mission").}.
set mphold_rcs to {
mpone({rcs off.}).
mpstat("Activate RCS to Continue").
mpadd({ if not rcs return 1/10. rcs off. return mpinc().}).
mpstat("Resuming Mission").}.
set mphold_bay to {
mpone({bays on.}).
mpstat("Close Bays to Continue").
mpadd({if bays return 1. return mpinc().}).
mpstat("Resuming Mission").}.
