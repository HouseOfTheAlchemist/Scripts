#!/usr/bin/env bash

# if [[ $(id -u) -ne 0 ]]; then
# 	echo "This script must be run as root" 
# 	exit 1
# fi

cecho() {
  local code="\033["
  case "$1" in
    black  | bk) color="${code}0;30m";;
    red    |  r) color="${code}1;31m";;
    green  |  g) color="${code}1;32m";;
    yellow |  y) color="${code}1;33m";;
    blue   |  b) color="${code}1;34m";;
    purple |  p) color="${code}1;35m";;
    cyan   |  c) color="${code}1;36m";;
    gray   | gr) color="${code}0;37m";;
    *) local text="$1"
  esac
  [[ -z $text ]] && local text="$color$2${code}0m"
  echo -e "$text"
}

if [[ $HOME = /data/data/com.termux/files/home ]]; then
  cecho g "Termux detected | Installing required packages" &&
  pkg update && pkg install -y unzip wget busybox &>/dev/null 
  if [[ ! -d ~/storage ]]; then
    cecho y "Setting up storage access for Termux.."
    termux-setup-storage
    sleep 2
  fi
  clear
fi

download() {
	cecho y "Downloading required binary from GitHub, wait.."
	wget -qO- https://api.github.com/repos/$1/releases/latest |
	grep browser_download_url | grep $2-$3.zip | cut -d '"' -f 4 |
	wget -i- -qO- | busybox unzip -q -
}

fclone_install() {
  if [[ $HOME = /data/data/com.termux/files/home ]]; then
    spath=$(which wget)
    spath="${spath%/*}"
    mv rclone-*/rclone "${spath}/fclone" && rm -rf rclone-*/
    chmod 755 "${spath}/fclone"
    echo ""
    fclone version && cecho g "\nfclone installed successfully!"
  else
    case $OS in
      'linux'|'freebsd'|'openbsd'|'netbsd')
        sudo mv rclone-*/rclone /usr/bin/fclone && rm -rf rclone-*/
		    chmod 755 /usr/bin/fclone 
		    echo ""
		    fclone version && cecho g "\nfclone installed successfully!"
        ;;
      'osx')
        sudo mkdir -m 0555 -p /usr/local/bin
	      mv rclone-*/rclone /usr/local/bin/fclone && rm -rf rclone-*/
		    chmod a=x /usr/local/bin/fclone
		    echo ""
		    fclone version && cecho g "\nfclone installed successfully!"
        ;;
      *)
        cecho gr "[!] OS not supported"
        exit 2
        ;;
    esac
  fi
}

gclone_install() {
  if [[ $HOME = /data/data/com.termux/files/home ]]; then
    spath=$(which wget)
    spath="${spath%/*}"
    mv gclone-*/gclone "$spath" && rm -rf gclone-*/
    chmod 755 "${spath}/gclone"
    echo ""
    gclone version && cecho g "\ngclone installed successfully!"
  else
    case $OS in
      'linux'|'freebsd'|'openbsd'|'netbsd')
        sudo mv gclone-*/gclone /usr/bin/ && rm -rf gclone-*/
		    chmod 755 /usr/bin/gclone
		    echo ""
		    gclone version && cecho g "\ngclone installed successfully!"
        ;;
      'osx')
        sudo mkdir -m 0555 -p /usr/local/bin
		    mv gclone-*/gclone /usr/local/bin/ && rm -rf gclone-*/
		    chmod a=x /usr/local/bin/gclone 
		    echo ""
		    gclone version && cecho g "\ngclone installed successfully!"
        ;;
      *)
        cecho gr "[!] OS not supported"
        exit 2
        ;;
    esac
  fi
}

read OS OSARCH < <(uname -a | awk '{print $1, $(NF-1)}')
case $OS in
  Linux)
    OS='linux'
    ;;
  FreeBSD)
    OS='freebsd'
    ;;
  NetBSD)
    OS='netbsd'
    ;;
  OpenBSD)
    OS='openbsd'
    ;;  
  Darwin)
    OS='osx'
    ;;
  SunOS)
    OS='solaris'
    ;;
  *)
    cecho gr "[!] OS not supported"
    exit 2
    ;;
esac

case $OSARCH in 
	x86_64|amd64)
		BINTAG=amd64
		;;
	i?86|x86)
		BINTAG=386
		;;
	aarch64|arm64)
		BINTAG=arm64
		;;	
	armv7*)
		BINTAG=arm-v7
		;;
	arm*)
		BINTAG=arm
		;;
	*)
		cecho gr "[!] Unsupported OSARCH: $OSARCH"
		exit 2
		;;
esac

read -p "(g)clone / (f)clone / (q)uit? " opt

case $opt in
  g|G)
	  download "dogbutcat/gclone" $OS $BINTAG
	  gclone_install
	  ;;
  f|F)
	  download "NyaMisty/fclone" $OS $BINTAG
	  fclone_install
	  ;;
  q|Q)
	  cecho c "\nExiting.."
	  exit 0 
	  ;;
  *) 
	  cecho r "[x] Invalid option: $opt"
	  exit 1
	  ;;
esac
