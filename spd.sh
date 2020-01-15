#!/bin/bash


# Docs like pew pew
# https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-net
# idk if its the best way to get what I need but hehe
# if it works: 
#  - Dont hate it
#  - Dont change it
#  Feel free to "bash" the code.
#

IF0=$1
IF1=$2

if [ -z "$IF0" ]; then
        IF=`ls -1 /sys/class/net/ | head -1`
fi

if [ -z "$IF1" ]; then 	
        IF2=`(ls -1 /sys/class/net | tail -2) | head -1`
fi

RXPREV0=-1
TXPREV0=-1
RXE0=-1
TXE0=-1
RXD0=-1 
TXD0=-1

RXPREV1=-1
TXPREV1=-1
RXE1=-1
TXE1=-1
RXD1=-1 
TXD1=-1


echo "Listening $IF..."
while [ 1 == 1 ] ; do
        rx_bytes0=`cat /sys/class/net/${IF0}/statistics/rx_bytes`
        tx_bytes0=`cat /sys/class/net/${IF0}/statistics/tx_bytes`
        rx_bytes1=`cat /sys/class/net/${IF1}/statistics/rx_bytes`
        tx_bytes1=`cat /sys/class/net/${IF1}/statistics/tx_bytes`

        if [ $RXPREV0 -ne -1 ] ; then
                let rx_bytes_bw0=$rx_bytes0-$RXPREV0
                let tx_bytes_bw0=$tx_bytes0-$TXPREV0
                let rx_bytes_bw1=$rx_bytes1-$RXPREV1
                let tx_bytes_bw1=$tx_bytes1-$TXPREV1
                (echo -e " $rx_bytes_bw0 $tx_bytes_bw0 "| awk '{ rx = $1 / 1024 / 1024 ; tx = $2 / 1024 / 1024 ; printf "↓ %0.2f || ↑ %0.2f \n",rx,tx}') >> ~/interface_1.log
                (echo -e " $rx_bytes_bw1 $tx_bytes_bw1 "| awk '{ rx = $1 / 1024 / 1024 ; tx = $2 / 1024 / 1024 ; printf "↓ %0.2f || ↑ %0.2f \n",rx,tx}') >> ~/interface_2.log


        fi
        RXPREV0=$rx_bytes0
        TXPREV0=$tx_bytes0
        RXPREV1=$rx_bytes1
        TXPREV1=$tx_bytes1
        sleep 1
    done
