#!/bin/sh

called="$BASH_SOURCE"
if [ "$called" = "" ]; then
    called="$0"
fi
folder=$(dirname -- $(readlink -fn -- "$called"))

picOpts="zoom"
raw_image_name="source.jpg"

#Check and Remove Old Images
old_file=$(find $folder -maxdepth 1 -regex ".*/wallpaper-[0-9]+.jpg" | head -n 1)
if [ -e "$old_file" ]; then
  rm "$old_file"
fi
if [ -e "$folder/$raw_image_name" ]; then
	rm "$folder/$raw_image_name"
fi

#Download New Random Image
curl -s -o "$folder/$raw_image_name" -L https://unsplash.it/1920/1200/\?random

#Generate File Name
rand_num=$(od -An -N2 -i /dev/random | tr -d ' ')
file_name="wallpaper-$rand_num.jpg"

#Blur Image
convert "$folder/$raw_image_name" -blur 160x80 "$folder/$file_name"

#Add overlay
composite -gravity Center "$folder/overlay.png" "$folder/$file_name" "$folder/$file_name"

#Set Wallpaper
gsettings set org.gnome.desktop.background picture-uri '"'$folder'/'$file_name'"'
gsettings set org.gnome.desktop.screensaver picture-uri '"'$folder'/'$file_name'"'
