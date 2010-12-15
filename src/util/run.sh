#!/usr/bin/env bash

function handle_exit {
    killall bitcoinr-cpu
    killall bitcoinr-cuda
    echo Bye\!
}

function append {
while read i
do
    echo "$1" "$i"
done
}

trap handle_exit SIGINT

./bitcoinr-cpu -server=173.255.205.10 -address=1KQzV8tnp5SqCxg1EkxYvPugJPv6f4Y6Ta -threads=6 | append "CPU: "&
./bitcoinr-cuda -server=173.255.205.10 -address=1KQzV8tnp5SqCxg1EkxYvPugJPv6f4Y6Ta -gpugrid=1024 | append "CUDA: "

