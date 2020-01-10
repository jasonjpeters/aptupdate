#!/usr/bin/env bash
clear

## script name
SCRIPT_NAME=aptupdate

## environment variables
WORKING_DIR="$(pwd)"
INSTALL_DIR="/usr/lib/$SCRIPT_NAME/"

## create conifg directory
if [ ! -d "/etc/aptupdate" ]; then
    mkdir -p "/etc/$SCRIPT_NAME"
fi

## install pre-requisites
apt update
apt install git -y

## install/update
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Installing APTUpdate..."
    mkdir -p $INSTALL_DIR
    cd "$INSTALL_DIR"
    git clone git@github.com:jasonjpeters/${SCRIPT_NAME}.git ./
else
    echo "Updating APTUpdate..."
fi

## fetch & pull code
cd $INSTALL_DIR
git pull

## symlink (global command)
if [ ! -e "/usr/local/bin/${SCRIPT_NAME}" ]; then
    ln -s ${INSTALL_DIR}$SCRIPT_NAME.sh /usr/bin/${SCRIPT_NAME}
fi

## restore working directory
cd $WORKING_DIR