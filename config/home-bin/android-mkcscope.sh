#!/bin/bash

echo "Listing Android files ..."

find "$PWD/art"                                                             \
"$PWD/bionic"                                                               \
"$PWD/bootable"                                                             \
"$PWD/build"                                                                \
"$PWD/cts"                                                                  \
"$PWD/dalvik"                                                               \
"$PWD/development"                                                          \
"$PWD/device"                                                               \
"$PWD/external"                                                             \
"$PWD/frameworks"                                                           \
"$PWD/hardware"                                                             \
"$PWD/libcore"                                                              \
"$PWD/libnativehelper"                                                      \
"$PWD/packages"                                                             \
"$PWD/pdk"                                                                  \
"$PWD/system"                                                               \
"$PWD/tools"                                                                \
"$PWD/vendor"                                                               \
\(	\
-name '*.java' -o                                               \
-name '*.aidl' -o                                               \
-name '*.hpp' -o                                                \
-name '*.cpp' -o                                               \
-name '*.xml' -o                                               \
-name '*.mk' -o                                                \
-name '*.[chxsS]' \
\) -type f -exec echo \"{}\" \; > cscope.files
#\) -type f -print > cscope.files

#-name '*.java' -print -o                                               \
#-name '*.aidl' -print -o                                               \
#-name '*.hpp' -print -o                                                \
#-name '*.cpp'  -print -o                                               \
#-name '*.xml'  -print -o                                               \
#-name '*.mk'  -print -o                                                \
#-name '*.[chxsS]' -type f -print > cscope.files

echo "Listing Kernel files ..."
find  kernel                                                           \
-path "kernel/arch/*" -prune -o                                        \
-path "kernel/tmp*" -prune -o                                          \
-path "kernel/Documentation*" -prune -o                                \
-path "kernel/scripts*" -prune -o                                      \
-name "*.[chxsS]" -type f -print >> cscope.files

find "$PWD/kernel/arch/arm/include/"                                        \
"$PWD/kernel/arch/arm/kernel/"                                              \
"$PWD/kernel/arch/arm/common/"                                              \
"$PWD/kernel/arch/arm/boot/"                                                \
"$PWD/kernel/arch/arm/lib/"                                                 \
"$PWD/kernel/arch/arm/mm/"                                                  \
"$PWD/kernel/arch/arm/mach-msm/" -name "*.[chxsS]" -type f -print >> cscope.files

echo "Creating cscope DB ..."
/usr/bin/cscope -b -q -k
echo "Done"

