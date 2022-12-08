#!/usr/bin/env bash

if ! command -v systemctl >/dev/null 2>&1; then
    echo "> Sorry but this script is only for Linux with systemd, eg: Ubuntu 16.04+/Centos 7+ ..."
    exit 1
fi

if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

install () {
  echo "Installing, wait.."
  wget -qO- https://api.github.com/repos/$1/releases/latest |
    grep browser_download_url | grep linux-"$2".zip | cut -d '"' -f 4 |
    wget -i- -qO- | busybox unzip -q -
  mv rclone-*/rclone /usr/bin/$3 && rm -rf rclone-*/
  chmod 755 /usr/bin/$3
  echo ""
  /usr/bin/$3 version; echo -e "\n$3 installed successfully!"
}

OSARCH=$(uname -m)
case $OSARCH in 
    x86_64|amd64)
        BINTAG='amd64'
        ;;
    i?86|x86)
        BINTAG='386'
        ;;
    aarch64|arm64)
        BINTAG='arm64'
        ;;  
    armv7*)
        BINTAG='arm-v7'
        ;;
    arm*)
    BINTAG='arm'
    ;;
    *)
        echo "Unsupported OSARCH: $OSARCH"
        exit 2
        ;;
esac

read -p "(g)clone / (f)clone / (q)uit? " opt
case $opt in
  g|G)
    install "dogbutcat/gclone" $BINTAG "gclone"
    ;;
  f|F)
    install "NyaMisty/fclone" $BINTAG "fclone"
    ;;
  q|Q)
    echo "Exiting.."; exit 1
    ;;
  *) 
    echo "Invalid option: $opt"
    ;;
esac