FROM toolchain:latest

COPY newt.sh /newt
COPY _scratch/newt /bin/newt
COPY _scratch/newtmgr /newtmgr

