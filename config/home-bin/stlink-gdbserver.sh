#!/bin/sh

STM_CUBE_IDE_VERSION="1.3.0"
PLUGIN_VERSION="1.3.0.202002181050"

STM_INSTALL_PATH="/opt/st/stm32cubeide_${STM_CUBE_IDE_VERSION}"
PLUGIN_NAME="com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.linux64"

PLUGIN_PATH="${STM_INSTALL_PATH}/plugins/${PLUGIN_NAME}_${PLUGIN_VERSION}"
BIN_PATH="${PLUGIN_PATH}/tools/bin"

CUBE_PROGRAMMER_PLUGIN_NAME="com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.linux64"
CUBE_PROGRAMMER_BIN_PATH="${STM_INSTALL_PATH}/plugins/${CUBE_PROGRAMMER_PLUGIN_NAME}_${PLUGIN_VERSION}/tools/bin"

OPTIONS="-p 61234 -l 1"		#	gdb port and swo-port
OPTIONS=${OPTIONS}" -d -z 61235"		#	swd enable
OPTIONS=${OPTIONS}" -a 96000000 -b 48"	#	cpu clock and swo clock divider
OPTIONS=${OPTIONS}" -cp ${CUBE_PROGRAMMER_BIN_PATH}"
OPTIONS=${OPTIONS}" -s -m 0 -k"			#	-s: verification of the flash download -k: init. reset
#OPTIONS=${OPTIONS}" -e"					#	starts the server in persistent mode

#TOOL_PATH = "/opt/st/stm32cubeide_1.3.0/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.linux64_1.3.0.202002181050/tools/bin"

echo $OPTIONS
#exit

cd ${BIN_PATH}
#cat config.txt
./ST-LINK_gdbserver ${OPTIONS}
