function slope_calculation {
parameter p1.
local upvec is (p1:position - p1:body:position):normalized.
return vang(upvec,surface_normal(p1)).
}
function surface_normal {
parameter p1.
local localbody is p1:body.
local basepos is p1:position.
local upvec is (basepos - localbody:position):normalized.
local northvec is vxcl(upvec,latlng(90,0):position - basepos):normalized * 3.
local sidevec is vcrs(upvec,northvec):normalized * 3.
local apos is localbody:geopositionof(basepos - northvec + sidevec):position - basepos.
local bpos is localbody:geopositionof(basepos - northvec - sidevec):position - basepos.
local cpos is localbody:geopositionof(basepos + northvec):position - basepos.
return vcrs((apos - cpos),(bpos - cpos)):normalized.
}
