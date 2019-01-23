#!/bin/bash

# https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt

# if [ $(id -u) != "0" ]; then
#     echo "Please run this script as root"
#     exit 1
# fi

prefix=/opt
arch='linux64'
lang='en-US'
filename='firefox.tar.bz2'
url="https://download.mozilla.org/?product=firefox-latest&os=$arch&lang=$lang"

# Find machine architecture.
case $(arch) in
    x86_64)
        arch='linux64'
        ;;
    i686)
        arch='linux'
        ;;
esac

function desktop() {
    {
        echo "#***************************#"
        echo "#    Created by fenyr-sh    #"
        echo "#***************************#"
        echo "[Desktop Entry]"
        echo "Name=Firefox"
        echo "Comment=Firefox Browser"
        echo "GenericName=Mozilla Firefox"
        echo "Exec=$prefix/firefox/firefox"
        echo "Icon=$prefix/firefox/browser/chrome/icons/default/default128.png"
        echo "Type=Application"
        echo "Categories=Network;WebBrowser;"
        echo "Keywords=firefox"
    } > /usr/share/applications/firefox.desktop
}

function download() {
    wget -O $filename $url
}

function unpack() {
    echo -e "\e[1;33mUnpacking $filename...\e[0m"
    tar jxvf $filename -C $prefix &> /dev/null
    echo -e "\e[1;32m$filename unpacked!\e[0m"
}

function install() {
    download

    if [[ $? -eq 0 ]]; then
        unpack

        if [[ $? -eq 0 ]]; then

            desktop

            echo -e "\e[1;32mFirefox installed!\e[0m"
        fi
    fi
}

install