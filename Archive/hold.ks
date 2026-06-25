import("mp").
local voice is getvoice(0).
set note_c4 to note("C4",0.2,0.25,1).
set note_g4 to note("G4",0.2,0.25,1).
set slide_u to list(note_c4, note_g4).
set slide_d to list(note_g4, note_c4).
set mpchime to { parameter n. return mpone({getvoice(0):play(n).}).}.
set mphold_thrust to { parameter s is "Activate Engines to Continue".
mpchime(slide_u).
mpstat(s).
mpadd({ return choose mpinc() if availablethrust>0 else 1/100. }).
mpchime(slide_d).
mpstat("Resuming Mission").}.
set mphold_brakes to { parameter s is "Release Brakes to Continue".
mpchime(slide_u).
mpone({brakes on.}).
mpstat(s).
mpadd({ return choose 1/10 if brakes else mpinc(). }).
mpchime(slide_d).
mpstat("Resuming Mission").}.
set mphold_sas to { parameter s is "Activate SAS to Continue".
mpchime(slide_u).
mpone({sas off.}).
mpstat(s).
mpadd({ if not sas return 1/10. sas off. return mpinc().}).
mpchime(slide_d).
mpstat("Resuming Mission").}.
set mphold_rcs to { parameter s is "Activate RCS to Continue".
mpchime(slide_u).
mpone({rcs off.}).
mpstat(s).
mpadd({ if not rcs return 1/10. rcs off. return mpinc().}).
mpchime(slide_d).
mpstat("Resuming Mission").}.
set mphold_bay to { parameter s is "Close Bays to Continue".
mpchime(slide_u).
mpone({bays on.}).
mpstat(s).
mpadd({if bays return 1. return mpinc().}).
mpchime(slide_d).
mpstat("Resuming Mission").}.
