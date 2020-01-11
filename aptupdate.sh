#!/usr/bin/env bash
clear

## sript name
SCRIPT_NAME=aptupdate

## environment variables
START_TIME="$(date +%s)"

SCRIPT_PTH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PTH")/
SCRIPT_HSH=$(md5sum "${SCRIPT_PTH}" | awk '{ print $1 }')

CONFIGFILE=$SCRIPT_NAME.conf
CONFIGFILE_DEFAULT=${SCRIPT_DIR}$CONFIGFILE
CONFIGFILE_ETC=/etc/$SCRIPT_NAME/$CONFIGFILE

## formats string output
function printTitle
{
    printf "\n"
    echo "$1"
    printf '%0.s-' $(seq 1 ${#1})
    printf "\n"
}

## root check
if ! [ "$(id -u)" = 0 ]; then
    printTitle "Error: Must be run as root!"
    printf "** sudo %s \n\n" "$SCRIPT_NAME"
    exit
fi

## generate configuration file
if [ "$1" = "genconfig" ]; then
    printTitle "Generating /etc/aptupdate/aptupdate.conf"
    if [ ! -d "/etc/${SCRIPT_NAME}" ]; then
        mkdir -pv "/etc/${SCRIPT_NAME}"
    fi
    echo "${SCRIPT_PTH}"
    cp -v "${SCRIPT_DIR}${CONFIGFILE}" "${CONFIGFILE_ETC}"
    exit
fi

## load configurations
for CONFIGFILE_PATH in "$CONFIGFILE_DEFAULT" "$CONFIGFILE_ETC"
do
    if [ -f "$CONFIGFILE_PATH" ]; then
        source "$CONFIGFILE_PATH"
        echo "** Loaded ${CONFIGFILE_PATH}"
    else 
        echo "** NO CONFIGURATION LOADED"
    fi
done

## update aptupdate
if [ -f "${SCRIPT_DIR}install.sh" ]; then
    "${SCRIPT_DIR}install.sh"
fi

SCRIPT_UPDATE_HSH=$(md5sum "${SCRIPT_PTH}" | awk '{ print $1 }')
if [ "${SCRIPT_HSH}" != "${SCRIPT_UPDATE_HSH}" ]; then
    echo "** Updated APTUpdate, run sudo aptupdate again for system update"
    exit
fi

## upgrade system
printTitle "Cleaning local cache"
apt-get clean && echo "** Local package information cleaned"

printTitle "Updating package information"
apt-get update

printTitle "Upgrading packages"
apt-get dist-upgrade -y

if [ "$RELEASE_UPGRADE" = 1 ] && [ "$SILENT" = "1" ]; then
    printTitle "Release upgrade"
    printf "** Upgrading system release version if available \n"
    printf "** Using non-interactive mode \n"
    do-release-upgrade -f DistUpgradeViewNonInteractive
elif [ "$RELEASE_UPGRADE" = "1" ] && [ "$SILENT" = "0" ]; then
    printTitle "Release upgrade"
    printf "** Upgrading system release version if available \n"
    printf '** Using interactive mode \n'
    do-release-upgrade
else
    printTitle "Release upgrade"
    printf "** Upgrading system release version skipped \n"
fi

printTitle "Package cleanup"
apt-get autoremove -y

printf "\n"
echo "Update completed in $((($(date +%s)-START_TIME)/60)) min"
