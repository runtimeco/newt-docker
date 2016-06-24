FROM toolchain:latest

COPY newt.sh /newt
COPY _scratch/bin/newt /bin/newt
COPY _scratch/bin/newtmgr /newtmgr

