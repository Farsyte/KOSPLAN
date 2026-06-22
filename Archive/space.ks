import("mp").
set mpspace to {
mpadd({
if altitude>body:atm:height return mpinc().
lock steering to prograde. lock throttle to 0. return 1.}).}.
