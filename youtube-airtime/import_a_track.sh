#!/bin/bash 
# Based on ftp-upload-hook.sh by
# The api_key was not being returned correctly, rewrote config file reader.
# Various further checks added
# It now works in non-daemon mode.

post_file() {
dosdest=/home/safetybucket
    mkdir -p dosdest
    max_retry=5
    retry_count=0

    file_path="${1}"
    
    # Give write permissions to the file to prevent problems if the user
    # uploads a read-only file.
   
    chmod +w "${file_path}"

    #We must remove commas because CURL can't upload files with commas in the name

    stripped_file_path=${file_path//','/''}

    if [ "${file_path}" != "${stripped_file_path}" ];
    then
		echo "Changing Filename"
		mv "${file_path}" "${stripped_file_path}"
    fi 
    
    file_path="${stripped_file_path}"
    filename="${file_path##*/}"
	
	# Get variables from the config file.
    airtime_conf_path=/etc/airtime/airtime.conf

	while IFS='' read -r line || [[ -n "$line" ]]; do
		if [[ $line == api_key* ]];
			then 
				IFS=' = '
				array=($line)
				api_key=${array[1]}
				IFS=''
		fi	
		if [[ $line == base_url* ]];
			then 
				IFS=' = '
				array=($line)
				http_path=${array[1]}
				IFS=''
		fi		
		if [[ $line == base_port* ]];
			then 
				IFS=' = '
				array=($line)
				http_port=${array[1]}
				IFS=''
		fi	
		if [[ $api_key != '0' ]];
			then 
				api=$api_key
			fi
		
	done < ${airtime_conf_path}
	
    # post request url would be like: http://bananas.mystationurl.com/rest/media for example.

    url=https://
    url+=$http_path
    url+=:
    #url+=$http_port
    url+=/rest/media

echo $url
echo ${file_path}

    # -f is needed to make curl fail if there's an HTTP error code
    # -L is needed to follow redirects! (just in case)
	if until curl -fL --max-time 30 $url -u $api: -X POST -F "file=@${file_path}"
		do
			retry_count=$[$retry_count+1]
			if [ $retry_count -ge $max_retry ]; then
				break
			fi
			sleep 5
		done
	then 
		mv -f "$file_path" "/home/safetybucket"
	else
	
	echo "Import Failed"
	fi
}

if [ ! -f "${1}" ]; then
    echo "On Entry - File not found!"
    exit 0
fi

post_file "${1}"

