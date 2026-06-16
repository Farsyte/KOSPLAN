set fmt to { parameter u,w. parameter d is 0.
if u:typename="Scalar" {
set u to round(u,d).
set u to (u:tostring+".0"):split(".").
set u to u[0]+(choose ("."+u[1]:padright(d)) if d > 0 else "").
} return u:tostring:padleft(w). }.
