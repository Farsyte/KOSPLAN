import os
import sys

wrf = {}
def tangleto(rd, wrname):
    if wrname not in wrf:
        print(f"# creating {wrname}")
        wrf[wrname] = open(wrname, 'w')
    wr = wrf[wrname]
    while True:
        line = rd.readline()
        if line.startswith("#+end_src"): break
        line = line.strip()
        print(f"{line}", file=wr)
        

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
    uname = os.uname()
    print(f"{uname.sysname:15} {uname.release} ({uname.machine}) {uname.version}")
    print(f"Python          {sys.version}")
    main(sys.argv)
