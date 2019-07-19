#!/bin/bash
#
# https://stackoverflow.com/a/17102611
#

help() {
  echo "usage: if_throughput [-1|-10] [--cont] swpX"
  echo "       if_throughput [-help]"
  echo
  echo "   Display troughput saturation bar graph."
  echo
  echo "     -1 or -10 mean 1Gbps respectively 10Gps. Default is -10"
  echo
  echo "     --cont will print subsequential measurement lines. Default"
  echo "            is to print in place."
  echo
  echo '   try "bridge" as interface for global forwarded traffic'
  echo
  exit
}

# https://www.linuxquestions.org/questions/linux-newbie-8/unix-shell-script-to-generate-a-bar-graph-861737/#post4253716
#
bar() {
  len="$1"

  bar="=================================================="
  barlength=${#bar}

  n=$((len*barlength / 100))       # Number of bar segments to draw $((i/2))
  printf "$INPLACE[%-${barlength}s]" "${bar:0:n}"
}

[ "$1" == "" -o "$1" == "--help" ] && help

# input + output bandwidth in Bps
# by default we assume 10Gbit/s = 10'000'000'000 bps
#
BW=$((   2 * 10000000000 / 8 ))

if   [ "$1" = "-1" ]; then
  BW=$(( 2 * 1000000000  / 8 ))
  shift
elif [ "$1" = "-10" ]; then
  BW=$BW # default
  shift
fi

if   [ "$1" = "--cont" ]; then
  INPLACE=''
  CONT='\n'
  shift
else
  INPLACE='\r'
  CONT=''
fi

IF="$1"
[ "$IF" == "" ] && help

RXPREV=-1
TXPREV=-1

# wait interval
# stats only get updated every two seconds
INTERVAL=2

echo "Listening $IF..."
while [ 1 == 1 ] ; do
        RX=`cat /sys/class/net/${IF}/statistics/rx_bytes`
        TX=`cat /sys/class/net/${IF}/statistics/tx_bytes`
        if [ $RXPREV -ne -1 ] ; then
                let BWRX=$(( ( $RX - $RXPREV ) / $INTERVAL ))
                let BWTX=$(( ( $TX - $TXPREV ) / $INTERVAL ))
                let SATURATION=$(( 100 * ( $BWRX + $BWTX ) / $BW ))  # percent throughput
                bar $SATURATION
                printf " Received: %'14d B/s Sent: %'14d B/s$CONT" $BWRX $BWTX
        fi
        RXPREV=$RX
        TXPREV=$TX
        sleep $INTERVAL
done
