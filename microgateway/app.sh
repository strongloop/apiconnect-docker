#!/bin/bash -e

startApp() {
  waitForApimReady
  if [ $(check) -eq 0 ]; then
    return;
  fi

  cd /usr/src/app/node_modules/microgateway
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

updateConfig() {
  cd /usr/src/app/node_modules/microgateway
  if [ ! -f id_rsa ]; then
    cp /keys/microgw id_rsa
  fi
  if [ ! -f id_rsa.pub ]; then
    cp /keys/microgw.pub id_rsa.pub
  fi
  node /usr/src/set-config/index.js
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

waitForApimReady() {
  SECONDS=0
  if [[ -n "$APIC_HOST" ]]
  then
    echo "Waiting for $APIC_HOST to be ready ..."
    wget -q --no-check-certificate https://$APIC_HOST/v1/portal/config?originURL=https://__impossible_url__ -O - && WGETRC=$? || WGETRC=$?
    while [[ "$WGETRC" -ne 0 ]]
    do
      sleep 5
      echo "Waiting for $APIC_HOST to be ready ($(elapsed)) ..."
      wget -q --no-check-certificate https://$APIC_HOST/v1/portal/config?originURL=https://__impossible_url__ -O - && WGETRC=$? || WGETRC=$?
    done
  fi
}

elapsed() {
  local DUR=$SECONDS
  local MIN=$((DUR / 60))
  local SEC=$((DUR % 60))
  echo ${MIN}m${SEC}s
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
  config)
    updateConfig
    ;;
  check)
    checkApp
    ;;
  *)
  echo "start | stop | restart | wait | check | config"
  exit 1
esac

exit 0
