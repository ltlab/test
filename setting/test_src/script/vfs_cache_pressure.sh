#!/usr/bin/sudo /bin/bash
TEST_FILE_SIZE=1024M
TEST_DIR=/usr/share
TEST_VALUES="100 90 80 70 60 50 40"
TEMP_DIR=${1:-$HOME}

echo 3 > /proc/sys/vm/drop_caches
dd if=/dev/zero of=$TEMP_DIR/testfile0 count=1 bs=$TEST_FILE_SIZE

i=1
for v in $TEST_VALUES;
do
   sysctl -w vm.vfs_cache_pressure=$v
   find $TEST_DIR> /dev/null
   cp $TEMP_DIR/testfile0 $TEMP_DIR/testfile$i
   echo "** vm.vfs_cache_pressure=$v **"
        time find $DIR/ > /dev/null
   ((i++))
done

for ((v=0; v<$i; v++));
do
   rm -f $TEMP_DIR/testfile$v
done

