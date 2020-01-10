#!/usr/bin/env bash
clear

## script name
SCRIPT_NAME=aptupdate

## environment variables
WORKING_DIR="$(pwd)"
INSTALL_DIR="/opt"

## create conifg directory
if [ ! -d "/etc/aptupdate" ]; then
    mkdir -p "/etc/$SCRIPT_NAME"
fi

## install pre-requisites
apt update
apt install git -y

if [ ! -d "${INSTALL_DIR}/${SCRIPT_NAME}" ]; then
    echo "Installing APTUpdate..."
    cd "${INSTALL_DIR}"
    git clone https://github.com/jasonjpeters/${SCRIPT_NAME}.git
else
    echo "Updateing APTUpdate..."
fi

## fetch/pull code
cd "${INSTALL_DIR}/${SCRIPT_NAME}"
git fetch --all
git reset --hard origin/master
git pull origin master

## set dcript(s) to executable
chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}/${SCRIPT_NAME}.sh"
chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}/install.sh"

## symlink
if [ ! -e "/usr/local/bin/${SCRIPT_NAME}" ]; then
    ln -s ${INSTALL_DIR}/${SCRIPT_NAME}/${SCRIPT_NAME}.sh /usr/local/bin/${SCRIPT_NAME}
fi

## return to working directory
cd "$WORKING_DIR" || exit