wrf = {}
def tangleto(rd, wrname):
    if wrname not in wrf:
        wrf[wrname] = open(wrname, 'w')
    wr = wrf[wrname]
    while True:
        line = rd.readline()
        if line.startswith("#+end_src"): break
        if "//" in line:
            csa = line.find("//")
            if csa < 1: continue
            line = line[0:csa]
        line = line.strip()
        if line: print(f"{line}", file=wr)
def tangle(rdname):
    with open(rdname, 'r') as rd:
        for line in rd:
            line = line.strip()
            if not line.startswith("#+begin_src "): continue
            for w in line.split(":"):
                if w.startswith("tangle "):
                    tangleto(rd, w[7:])
                    break

def main(args):
    for arg in args[1:]:
        tangle(arg)
    pass

if __name__ == "__main__":
    import sys
    main(sys.argv)
