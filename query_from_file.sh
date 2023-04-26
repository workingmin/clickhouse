#!/usr/bin/env bash

# Use the query from the specified sql file in the HTTP interface.

usage() {
    cat << EOF

Usage: $0 [OPTIONS] [ARGS]
    --host arg (=localhost) Server hostname
    --port arg (=8123)      Server port
    --user arg              user
    --password arg          password
    --file arg              file        
EOF
    exit 1
}

ARGS=$(getopt -a -o "" --long host:,port:,user:,password:,file:,help -- "$@")
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

eval set -- "${ARGS}"
while :; do
    case $1 in
    --host)
        host=$2
        shift
        ;;
    --port)
        port=$2
        shift
        ;;
    --user)
        user=$2
        shift
        ;;
    --password)
        password=$2
        shift
        ;;
    --file)
        file=$2
        shift
        ;;
    --help)
        usage
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Internal error!"
        exit 1
        ;;
    esac
    shift
done

if [ -z "$file" ]; then
    usage
    exit 1
fi

if [ -z "$host" ]; then
    host="localhost"
fi

if [ -z "$port" ]; then
    port=8123
fi

url="http://$host:$port/"
if [ -z "$user" ]; then
    cat $file | curl $url --data-binary @-
else
    if [ -n "$password" ]; then
        user=$user":"$password
    fi
    cat $file | curl --user $user --referer $url --data-binary @-
fi

if [ -n "$password" ]; then
    user=$user":"$password
fi
