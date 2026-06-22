from pathlib import Path

wrf = {}

def tangleto(rd, wrname):
    lc = 0
    if wrname not in wrf:
        Path(wrname).parents[0].mkdir(parents=True, exist_ok=True)
        wrf[wrname] = open(wrname, 'w')
    wr = wrf[wrname]
    while True:
        line = rd.readline()
        if line.startswith("#+end_src"): return lc
        if "//" in line:
            csa = line.find("//")
            if csa < 1: continue
            line = line[0:csa]
        line = line.strip()
        if line:
            print(f"{line}", file=wr)
            lc += 1

def tangle(rdname):
    wrote = {}
    with open(rdname, 'r') as rd:
        for line in rd:
            line = line.strip()
            if not line.startswith("#+begin_src "): continue
            for w in line.split(":"):
                if w.startswith("tangle "):
                    wrname = w[7:]
                    lc = tangleto(rd, wrname)
                    x = wrname.find('Archive/')
                    if x>=0: wrname = wrname[x+8:]
                    wrote[wrname] = wrote.get(wrname,0) + lc
                    break

    if len(wrote) != 1:
        print(f"WARNING: wrote {len(wrote)} files from {rdname}")
    for wf,wc in wrote.items():
        print(f"{rdname:32} {wc:3} {wf}")

def main(args):
    for arg in args[1:]:
        tangle(arg)
    pass

if __name__ == "__main__":
    import sys
    main(sys.argv)
