#!/bin/bash -e

startApp() {
  if [ $(check) -eq 0 ]; then
    return;
  fi

  cd /usr/src/app
  node . &
  echo $! > /tmp/app.pid
}

stopApp() {
  if [ -f /tmp/app.pid ]; then
    kill `cat /tmp/app.pid`
    rm /tmp/app.pid
  fi
}

restartApp() {
  touch /tmp/app.restart
  stopApp
  startApp
  rm /tmp/app.restart
}

check() {
  if [ -f /tmp/app.restart ]; then
    echo 0;
    return;
  fi

  if [ ! -f /tmp/app.pid ]; then
    echo 1;
    return;
  fi

  PID=$(cat /tmp/app.pid)
  if [ ! -d /proc/$PID ]; then
    echo 1;
  else
    echo 0;
  fi
}

waitApp() {
  while [ $(check) -eq 0 ]; do
    sleep 1;
  done
}

checkApp() {
  exit $(check)
}

case "$1" in
  start)
    startApp
    ;;
  stop)
    stopApp
    ;;
  restart)
    restartApp
    ;;
  wait)
    waitApp
    ;;
  check)
    checkApp
    ;;
  *)
  echo "start | stop | restart | wait | check"
  exit 1
esac

exit 0
