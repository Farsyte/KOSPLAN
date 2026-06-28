from pathlib import Path

wrf = {}

def tangleto(rd, wrname):
    cc = 0
    if wrname not in wrf:
        Path(wrname).parents[0].mkdir(parents=True, exist_ok=True)
        wrf[wrname] = open(wrname, 'w')
    wr = wrf[wrname]
    while True:
        line = rd.readline()
        if not line: break
        line = line.strip()
        if line.startswith("#+end_src"): return cc
        if "//" in line:
            csa = line.find("//")
            if csa < 1: continue
            line = line[0:csa]
            line = line.strip()
        if line:
            print(f"{line}", file=wr)
            cc += len(line)+1

def tangle(rdname):
    wrname = ""
    wrsize = 0
    ppfx = "#+PROPERTY: header-args :tangle "
    with open(rdname, 'r') as rd:
        for line in rd:
            if not line: break
            line = line.strip()
            if line.startswith(ppfx):
                wrname = line[len(ppfx):]
            if line.startswith("#+begin_src ks"):
                wrsize += tangleto(rd, wrname)
    x = wrname.find('Archive/')
    if x>=0: wrname = wrname[x+8:]
    print(f"{rdname:32} {wrsize:3} {wrname}")

def main(args):
    for arg in args[1:]:
        tangle(arg)
    pass

if __name__ == "__main__":
    import sys
    main(sys.argv)
