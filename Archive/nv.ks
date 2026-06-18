set nve to lex().
set nve:Scalar to { parameter u. return u:tostring. }.
set nve:String to { parameter u. return """"+u. }.
set nvd to list(home, path("1:")).
set nvf to { parameter d, n. return nvd[d]:combine("nv.d", n). }.
set nvl to lex().
set nvp to { parameter f,n,u.
set nvl[n] to u. set eu to nve[u:typename](u).
if not exists(f) create(f). set f to open(f). f:clear. f:write(eu).
return u. }.
set nvhas to { parameter d,n.
return nvl:haskey(n) or exists(nvf(d,n)). }.
set nvput to { parameter d,n,u.
if nvl:haskey(n) and nvl[n] = u return u.
return nvp(nvf(d,n),n,u). }.
set nvget to { parameter d,n,u.
if nvl:haskey(n) return nvl[n].
set f to nvf(d,n).
if not exists(f) return nvp(f,n,u).
set c to open(f):readall().
if c:empty return nvp(f,n,u).
set c to c:string.
if c:startswith("""") return c:remove(0,1).
return c:toscalar(0).}.
