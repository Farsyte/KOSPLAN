import("mn").
set go to {
mpadd({
set h to vcrs(body:position,ship:velocity:orbit).
lock steering to lookdirup(h,-sun:position).
return choose mpinc() if vang(steering:vector,facing:vector)<1 else 1.}).
mpadd(mncirc).
mpadd(mnwait).
mpadd(mnexec).
mpadd(mnfini).
mpclr(). mprun().
print "program complete. ABORT to reboot.".
wait until abort. abort off. reboot.
}.
