#!/bin/bash
# test it: ./parseurl.sh http://username:password@172.18.218.60:8080/teste/
#          ./parseurl.sh http://username:password@172.18.218.60/teste/
#          ./parseurl.sh http://username:password@www.google.com/teste/
#          ./parseurl.sh http://username:password@www.google.com:8080/teste/

function testip() {
    IP=$1
    TEST=`echo "${IP}." | grep -E "([0-9]{1,3}\.){4}"`

    if [ "$TEST" ];then
       echo "$IP" | awk -F. '{
          if ( (($1>=0) && ($1<=255)) &&
               (($2>=0) && ($2<=255)) &&
               (($3>=0) && ($3<=255)) &&
               (($4>=0) && ($4<=255)) ) {
             print("true");
          } else {
             print("false");
          }
       }'
    else
        echo "false"
    fi
}

# substitute hostname with ip address in url
function rebuildurl() {

    #### EXTRACT DATA

    # extract the protocol
    proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"

    # remove the protocol
    url="$(echo ${1/$proto/})"

    # extract the user + password (if any)
    userpassword="$(echo $url | grep @ | cut -d@ -f1)"

    # extract only the user (if any)
    password="$(echo $userpassword | grep : | cut -d: -f2)"

    # extract only the user (if any)
    if [ -n "$password" ]; then
      user="$(echo $userpassword | grep : | cut -d: -f1)"
    else
        user=$userpassword
    fi

    # extract the host with port
    hostport="$(echo ${url/$userpassword@/} | cut -d/ -f1)"

    # extract only the host
    host="$(echo ${hostport} | cut -d: -f1)"

    # by request - try to extract the port
    port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"

    # extract the path (if any)
    path="$(echo $url | grep / | cut -d/ -f2-)"

    # get ip from host
    isip="`testip $host`"
    if [ "$isip" = "true" ];then
        ip=$host
    else
        ip="$(host $host | awk '/has address/ { print $4 ; exit }')"
    fi

    #### REBUILD URL

    if [ -n "$user" ] && [ -n "$password" ]
    then
        xusernamepassword="$user:$password@"
    else
        if [ -n "$user" ] || [ -n "$password" ]
        then
            xusernamepassword="$user$password@"
        fi
    fi

    if [ -n "$port" ]
    then
        xipport="$ip:$port"
    else
        xipport="$ip"
    fi

    if [ -n "$path" ]
    then
        xpath="/$path"
    fi

    echo "$proto$xusernamepassword$xipport$xpath"

}

