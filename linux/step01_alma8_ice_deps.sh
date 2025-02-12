#!/bin/bash

ICEVER=${ICEVER:-ice36}

# Ice installation
if [ "$ICEVER" = "ice36" ]; then
   #start-recommended
    curl -sL https://zeroc.com/download/Ice/3.6/el7/zeroc-ice3.6.repo > \
    /etc/yum.repos.d/zeroc-ice3.6.repo

    dnf -y install glacier2 \
                   icebox \
                   icegrid \
                   icepatch2 \
                   libfreeze3.6-c++ \
                   libice3.6-c++ \
                   libicestorm3.6

    #end-recommended
    # locales are missing in alma 8
    dnf -y install glibc-all-langpacks
    # reset the locale
    localedef -i en_US -f UTF-8 en_US.UTF-8
elif [ "$ICEVER" = "ice36-devel" ]; then
    curl -sL https://zeroc.com/download/Ice/3.6/el7/zeroc-ice3.6.repo > \
    /etc/yum.repos.d/zeroc-ice3.6.repo

    dnf -y install glacier2 \
                   icebox \
                   icegrid \
                   icepatch2 \
                   libfreeze3.6-c++ \
                   libice3.6-c++ \
                   libicestorm3.6 \
                   ice-all-devel
    # locales are missing in alma 8
    dnf -y install glibc-all-langpacks
    # reset the locale
    localedef -i en_US -f UTF-8 en_US.UTF-8
fi
