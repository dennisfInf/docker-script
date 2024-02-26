#!/bin/zsh
#
#
#
if [[ $1 =~ ^(-n) && $3 =~ ^(-t) ]]
then
    if [[ $2 =~ ^[0-9]+$ && $4 =~ ^[0-9]+$ ]]
    then
        n="$2"
        t="$4"
        id="$5"
        echo "starting bookkeeping implementation with parameters n: $n t: $t"
    else echo "either -n or -t is not a number"
        exit 1
    fi
else echo "Usage: $0 -n <number of parties> -t <threshold>"
    exit 1
fi

app_port=$((50050 + $id))

port=$((18500 + id))
port_base=$((14000 + id))
port2=$((19500 + id))
port_base2=$((14256 + id))

docker run -p $port2:$port2 -p $port_base2:$port_base2 dennisfaut/shamir_6 $id oram-$n-1 -pn 19500 -h $6 -N $n &

sleep 20

docker run -p $port:$port -p $port_base:$port_base dennisfaut/shamir_6 $id add_shares-$n-$t-1 -pn 18500 -h $6 -N $n &

sleep 5

if [[ $id == 2 ]]
then
    docker run -p $app_port:$app_port dennisfaut/test-bookkeeping $n 1 $t $app_port 14000 0.0.0.0 &
else
    docker run -p $app_port:$app_port dennisfaut/test-bookkeeping $n 0 $t $app_port 14000 0.0.0.0 &
fi

wait
