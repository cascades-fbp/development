#!/bin/bash -e

###########################################################################
# Functions
#

# display a message in red with a cross by it
# example
# echo echo_fail "No"
function echo_fail {
  # echo first argument in red
  printf "\e[31m✘ ${1}"
  # reset colours back to normal
  printf "\033[0m\n"
}

# display a message in green with a tick by it
# example
# echo echo_fail "Yes"
function echo_pass {
  # echo first argument in green
  printf "\e[32m✔ ${1}"
  # reset colours back to normal
  printf "\033[0m\n"
}

###########################################################################
# Main
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

mkdir -p components

buildComponents() {
    components=$1
    for c in "${components[@]}"
    do
        echo -n " -> ${c}... "
        go get -d $2
        go build -o components/$c $2/$c
        echo_pass
    done
}

build_core() {
    echo "Building core components:"
    components=('core/console' 'core/delay' 'core/drop' 'core/exec' \
        'core/joiner' 'core/passthru' 'core/readfile' 'core/splitter' \
        'core/submatch' 'core/switch' 'core/template' 'core/ticker' \
        'debug/crasher' 'debug/oneshot' 'fs/walk' 'fs/watchdog')
    buildComponents $components "github.com/cascades-fbp/cascades/components"
}

build_sockets() {
    echo "Building sockets component:"
    components=('tcp-server')
    buildComponents $components "github.com/cascades-fbp/cascades-sockets"
}

build_websockets() {
    echo "Building websocket components:"
    components=('client' 'server')
    buildComponents $components "github.com/cascades-fbp/cascades-websocket"
}

build_bonjour() {
    echo "Building bonjour components:"
    components=('discover' 'register')
    buildComponents $components "github.com/cascades-fbp/cascades-bonjour"
}

build_influxdb() {
    echo "Building InfluxDB components:"
    components=('write')
    buildComponents $components "github.com/cascades-fbp/cascades-influxdb"
}

build_http() {
    echo "Building http components:"
    components=('client' 'router' 'server')
    buildComponents $components "github.com/cascades-fbp/cascades-http"
}

build_mqtt() {
    echo "Building MQTT components:"
    components=('pub' 'sub')
    buildComponents $components "github.com/cascades-fbp/cascades-mqtt"
}

# Build cascades CLI
go get github.com/cascades-fbp/cascades/cmd/cascades

# Build components
build_core
build_sockets
build_websockets
build_bonjour
build_influxdb
#buildHTTP
build_mqtt

exit 0;