# APTUpdate

Command to fully update a Ubunutu Desktop/Server via APT.

## Requirements

* curl - ```sudo apt-get install curl -y```
* git - ```sudo apt-get install git -y```

## Install

```
curl -s https://raw.githubusercontent.com/jasonjpeters/aptupdate/master/install.sh | sudo bash
```

## Configuration

Configurations are sourced from ```aptupdate.conf``` located in ```/opt/aptupdate``` by default. These can be overriden by editing the file ```/etc/aptupdate/aptupdate.conf```. Generate this file with the command below.

```
sudo aptupdate genconfig
```

## Usage

To update your system run the following command.

```
sudo aptupdate
```