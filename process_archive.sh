lock_path=process_archive.lock
db_path=process_archive.db
sources_expression=/volume1/VMTEST/archives/*.zip
target_path=/volumeUSB1/usbshare/unarchived/1

if { set -C; 2>/dev/null >$lock_path; }; then
   trap "rm -f $lock_path" EXIT
else
   echo "Lock file exists, exiting"
   exit
fi

sources=($(ls -tr $sources_expression 2> /dev/null))
if [ $? -ne 0 ]; then
   echo "No sources found, exiting"
   exit
fi

src=${sources[-1]}
if /var/packages/DiagnosisTool/target/tool/lsof -f -- $src >/dev/null 2>&1; then
   echo "Source in use detected (sync in progress?), exiting"
   exit
fi

src_info=$(md5sum $src)
md5_sum=$(echo $src_info | cut -f 1 -d' ')
if grep $md5_sum $db_path >/dev/null 2>&1; then
   echo "No new source found, exiting"
   exit
fi

rm -rf $target_path \
&& mkdir -p $target_path \
&& 7z x $src -o$target_path -y >/dev/null \
&& echo $src_info >> $db_path
