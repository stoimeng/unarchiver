archive_path=/volume1/archives/archive1.zip
target_path=/volume1/unarchived/1/2/3

generate_archive_temp_path() {
   echo "/volume1/archives/archive1_"$(date +"%s")".zip"
}

report_error() {
   echo "Error!"
}

trap '[ $? -eq 0 ] && exit 0 || report_error' EXIT

if [ -f $archive_path ]; then
   temp_path=$(generate_archive_temp_path)
   mv $archive_path $temp_path \
   && rm -rf $target_path \
   && mkdir -p $target_path \
   && unzip $temp_path -d $target_path \
   && rm $temp_path
fi
