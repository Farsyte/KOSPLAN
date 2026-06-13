// import("nv").
set mpl to list().
set mpi to 0. // nvget(1,"mpi",0).
set mpadd to { parameter d. mpl:add(d). }.
set mponce to { parameter d. mpl:add({ d(). return mpinc(). }). }.
set mpsay to { parameter s. mpl:add({ print s. return mpinc(). }). }.
set mpinc to { parameter t is 0.
set mpi to mpi + 1.
// nvput(1, "mpi", mpi).
return t. }.
set mprun to {
until abort or mpi>=mpl:length {
local dt is mpl[mpi]().
if dt>0 wait dt. }}.
