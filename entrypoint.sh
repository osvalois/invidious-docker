#!/bin/sh

# Start multiple Invidious processes
for i in $(seq 1 6)
do
    ./invidious &
done

# Start http3-ytproxy
/opt/http3-ytproxy/http3-ytproxy &

# Start NGINX
nginx -g 'daemon off;'