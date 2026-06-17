set soget to {
parameter apo, peri.
parameter inc is 0.
parameter lan is 0.
parameter aop is 0.
local sma is body:radius + (apo + peri)/2.
local ecc is abs(apo - peri) / (2*sma).
return createorbit(inc, ecc, sma, lan, aop, 0, 0, body). }.
