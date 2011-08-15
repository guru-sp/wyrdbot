#!/bin/bash

### BEGIN INIT INFO
# Provides:          wyrd
# Required-Start:    $network $local_fs
# Required-Stop:     $network $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: wyrd
### END INIT INFO

NAME=wyrd
APP_DIR=/opt/$NAME
RETVAL=0

start() {
    echo "Starting: $NAME."
    cd $APP_DIR
    su wyrd -c "bundle exec ruby bin/bot.rb start"
}

stop() {
    su wyrd -c "bundle exec ruby bin/bot.rb stop"
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        RETVAL=1
esac
exit $RETVAL
