set agl_box to ship:bounds.
set agl_log to {log "stage "+stage:number+": agl "+agl() to home:combine("agl.log").}.
set agl to {return agl_box:bottomaltradar.}.
on stage:number {set agl_box to ship:bounds. agl_log(). return true.}.
agl_log().
