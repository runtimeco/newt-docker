#!/bin/bash

if [[ $NEWT_USER ]] && [[ $NEWT_GROUP ]] && [[ $NEWT_HOST == "Linux" ]]; then
    groupadd -o -g $NEWT_GROUP newt
    useradd -u $NEWT_USER -g newt newt
    chown newt:newt /dev/hidraw*
    sudo -u newt /bin/newt "$@"
else
    /bin/newt "$@"
fi
