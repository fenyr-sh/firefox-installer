#!/bin/bash

# https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt

if [ $(id -u) != "0" ]; then
    echo -e "\e[1;31mPlease run this script as root!\e[0m"
    exit 1
fi

cache=/home/$SUDO_USER/.cache/mozilla
config=/home/$SUDO_USER/.mozilla
prefix=/opt
arch='linux64'
lang='en-US'
filename='firefox.tar.bz2'
url="https://download.mozilla.org/?product=firefox-latest&os=$arch&lang=$lang"

# Check the machine architecture.
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
    # If the $filename file does not exist, then it is downloaded.
    if [[ ! (-e $filename) ]]; then
        wget --no-verbose --show-progress -O $filename $url # --content-disposition
    else
        echo -e "\e[1;34mThe file already exists!\e[0m"
    fi
}

function extract() {
    # Remove firefox installation folder if exists.
    if [[ -d "$prefix/firefox" ]]; then
        echo -e "\e[1;33mRemoving $prefix/firefox...\e[0m"
        rm -r $prefix/firefox
        echo -e "\e[1;32m$prefix/firefox removed!\e[0m"
    fi

    # Extract $filename in $prefix
    echo -e "\e[1;33mExtracting $filename...\e[0m"
    tar jxvf $filename -C $prefix &> /dev/null

    if [[ $? -ne 0 ]]; then
        echo -e "\e[1;32mSomething went wrong when extracting the file!\e[0m"
    else
        echo -e "\e[1;32m$filename extracted!\e[0m"
    fi
}

function install() {
    download

    if [[ $? -eq 0 ]]; then
        extract

        if [[ $? -eq 0 ]]; then
            desktop

            if [[ $? -ne 0 ]]; then
                echo -e "\e[1;32mSomething went wrong when trying to create the desktop file!\e[0m"
            else
                echo -e "\e[1;32mDesktop file created successfully!\e[0m"
            fi
        fi
    fi
}

function clean_cache() {
    # Clean cache and configuration
    if [[ -d $cache ]]; then
        echo -e "\e[1;33mCleaning $cache...\e[0m"
        rm -r $cache
    fi
    
    if [[ -d $config ]]; then
        echo -e "\e[1;33mCleaning $config...\e[0m"
        rm -r $config
    fi
    
    echo -e "\e[1;32mCleaned successfully!\e[0m"
}

function clean() {
    rm $filename
}

install
# clean_cache
clean
echo -e "\e[1;32mFirefox installed!\e[0m"