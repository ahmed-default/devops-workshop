#!/bin/bash


set -e


#============================== VARIABLES ================================#

tmp_dir="/tmp/sitefiles/"
url="https://templatemo.com/tm-zip-files-2020/templatemo_520_highway.zip"
dest=/home/ubuntu/project/exercise12/roles/web/files/

#=========================================================================#


if [ -d "$tmp_dir" ]; then
    echo "dir already exists ,cleaning it..."
    sudo rm -rf "$tmp_dir"
    echo "dir cleaned"
    mkdir -p "$tmp_dir"
else
    mkdir -p "$tmp_dir"
    echo "dir created successfully"
fi

#=========================================================================#

cd "$tmp_dir"
wget "$url"
zip=$(basename "$url")
unzip -o "$zip"
sudo rm -f "$zip"
file=$(ls)

#=========================================================================#

sudo rm -rf "$dest"/*

sudo cp -r "$file"/* "$dest"
