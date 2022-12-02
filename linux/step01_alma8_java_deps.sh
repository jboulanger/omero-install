#!/bin/bash
JAVAVER=${JAVAVER:-openjdk11}

# Java installation
if [ "$JAVAVER" = "openjdk1.8" ]; then
    dnf -y install java-1.8.0-openjdk
elif [ "$JAVAVER" = "openjdk1.8-devel" ]; then
    dnf -y install java-1.8.0-openjdk-devel
elif [ "$JAVAVER" = "openjdk11" ]; then
	#start-recommended
    dnf -y install java-11-openjdk
    #end-recommended
elif [ "$JAVAVER" = "openjdk11-devel" ]; then
    dnf -y install java-11-openjdk-devel
fi