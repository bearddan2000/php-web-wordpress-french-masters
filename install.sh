#!/usr/bin/env bash
basefile="install"
logfile="general.log"
timestamp=`date '+%Y-%m-%d %H:%M:%S'`

if [ "$#" -ne 1 ]; then
  msg="[ERROR]: $basefile failed to receive enough args"
  echo "$msg"
  echo "$msg" >> $logfile
  exit 1
fi

function setup-logging(){
  scope="setup-logging"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  echo "$info_base removing old logs" >> $logfile

  rm -f $logfile

  echo "$info_base ended" >> $logfile

  echo "================" >> $logfile
}

function root-check(){
  scope="root-check"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  #Make sure the script is running as root.
  if [ "$UID" -ne "0" ]; then
    echo "[$timestamp ERROR]: $basefile::$scope you must be root to run $0" >> $logfile
    echo "==================" >> $logfile
    echo "You must be root to run $0. Try the following"
    echo "sudo $0"
    exit 1
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile
}
function usage() {
    echo ""
    echo "Usage: "
    echo ""
    echo "-u: start."
    echo "-d: tear down."
    echo "-h: Display this help and exit."
    echo ""
}
function start-up(){

    scope="start-up"
    info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    echo "$info_base copying uploads folder to wordpress/src" >> $logfile

    sudo cp -R ./wordpress/uploads ./wordpress/src

    echo "$info_base build images" >> $logfile

    sudo docker-compose up -d --build

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}
function tear-down(){

    scope="tear-down"
    info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    echo "$info_base services removed" >> $logfile

    sudo docker-compose down

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}

function clean-db(){
  user=`whoami`
  sudo chown -R root:root maria/src
  sudo chmod -R 777 maria/src/*
  sudo find maria/src -empty -type f -print0 -exec rm -v "{}" \;
  sudo rm -f maria/src/mysql/help*
  sudo rm -f maria/src/mysql/time*
  sudo rm -f maria/src/mysql/slow*
  sudo rm -f maria/src/wordpress/comment*
  sudo rm -f maria/src/wordpress/post*
  sudo chown -R systemd-coredump:systemd-coredump maria/src
}

root-check

while getopts ":udh" opts; do
  case $opts in
    c)
      clean-db ;;
    u)
      setup-logging
      start-up ;;
    d)
      tear-down ;;
    h)
      usage
      exit 0 ;;
    /?)
      usage
      exit 1 ;;
  esac
done
