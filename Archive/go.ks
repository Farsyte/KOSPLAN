function go {
local p is home:combine("go.ks").
copypath(find("gonew"), p).
print "New GO script created:".
print "  "+p.
print "rebooting into new GO script in 3 seconds.".
wait 3.
reboot. }
