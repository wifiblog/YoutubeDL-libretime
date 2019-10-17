#!/bin/bash
# Change importfolder to your own import folder, if required.

importfolder=/srv/airtime/uploads
mkdir -p $importfolder
importfolder=/srv/airtime/uploads/youtube
mkdir -p $importfolder

# Is the import folder empty?
if [ "$(ls -A $importfolder)" ]; then
	mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	for entry in "$importfolder"/*
	do
	  case "$entry" in
		*.mp3 | *.MP3 | *.m4a | *.M4A | *.ogg | *.OGG | *.aac | *.AAC | *.flac | *.FLAC | *.wav | *.WAV ) 
		   $mydir/import_a_track.sh "$entry"
			;;
		*)
			echo "$entry is NOT usable audio"
			;;
		esac
	done
else
    echo "$importfolder is empty. Nothing to do!"
fi

