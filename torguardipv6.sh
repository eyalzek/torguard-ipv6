#!/bin/bash
function start {
    sysctl -w net.ipv6.conf.wlan0.disable_ipv6=1
    openvpn "/etc/openvpn/TorGuard.$1.conf" &
    sleep 10
    echo "External IP is:"
    curl http://icanhazip.com/
}

function stop {
    killall openvpn
    sysctl -w net.ipv6.conf.wlan0.disable_ipv6=0
}

function list {
    folder_path="/etc/openvpn/"
    for x in $(find "$folder_path" -name "TorGuard*"); do
        foo=${x/"$folder_path"TorGuard./}
        echo ${foo/\.conf/}
    done
}

function usage {
    echo "'$0 list'           - will display a list of available servers"
    echo "'$0 start [SERVER]' - will connect the VPN to the selected server"
    echo "'$0 stop'           - will stop the VPN"
    exit 0
}

if [ $# -lt 1 ]; then
    usage
else
    case $1 in
        start)
            if [ $# -lt 2 ]; then
                usage
            else
                start "$2"
            fi
            ;;

        stop)
            stop
            ;;

        list)
            list
            ;;

        *)
            usage
            ;;
    esac
fi
