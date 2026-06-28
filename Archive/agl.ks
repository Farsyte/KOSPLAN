set agl_box to ship:bounds.
set agl to {return agl_box:bottomaltradar.}.
on stage:number {set agl_box to ship:bounds. return true.}.
