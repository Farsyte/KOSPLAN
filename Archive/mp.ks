import("nv").
import("math").
set mpl to list().
set mpi to nvget(1,"mpi",0).
set mpadd to { parameter d. mpl:add(d). }.
set mpone to { parameter d. mpl:add({ d(). return mpinc(). }). }.
set mpsay to { parameter s. mpl:add({ print s. return mpinc(). }). }.
set mpput to {
parameter i.
parameter t is 0.
set mpi to nvput(1, "mpi", i).
return t. }.
set mpclr to { parameter t is 0.
return mpput(0, t). }.
set mpinc to { parameter t is 0.
return mpput(mpi+1, t). }.
set mprun to {until abort or mpi>=mpl:length {
local dt is mpl[mpi](). if dt>0 wait dt. }}.
