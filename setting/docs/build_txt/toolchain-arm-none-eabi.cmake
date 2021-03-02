##
## Author:  Johannes Bruder
## License: See LICENSE.TXT file included in the project
##
##
## CMake arm-none-eabi toolchain file
##

# Append current directory to CMAKE_MODULE_PATH for making device specific cmake modules visible
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# Target definition
set(CMAKE_SYSTEM_NAME  Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

#---------------------------------------------------------------------------------------
# Set toolchain paths
#---------------------------------------------------------------------------------------
set(TOOLCHAIN arm-none-eabi)
if(NOT DEFINED TOOLCHAIN_PREFIX)
    if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)
        set(TOOLCHAIN_PREFIX "/usr")
    elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Darwin)
        set(TOOLCHAIN_PREFIX "/usr/local")
    elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Windows)
        message(STATUS "Please specify the TOOLCHAIN_PREFIX !\n For example: -DTOOLCHAIN_PREFIX=\"C:/Program Files/GNU Tools ARM Embedded\" ")
    else()
        set(TOOLCHAIN_PREFIX "/usr")
        message(STATUS "No TOOLCHAIN_PREFIX specified, using default: " ${TOOLCHAIN_PREFIX})
    endif()
endif()
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_PREFIX}/bin)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_PREFIX}/${TOOLCHAIN}/include)
set(TOOLCHAIN_LIB_DIR ${TOOLCHAIN_PREFIX}/${TOOLCHAIN}/lib)

# Set system depended extensions
if(WIN32)
    set(TOOLCHAIN_EXT ".exe" )
else()
    set(TOOLCHAIN_EXT "" )
endif()

# Perform compiler test with static library
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#---------------------------------------------------------------------------------------
# Set compilers
#---------------------------------------------------------------------------------------
set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-g++${TOOLCHAIN_EXT} CACHE INTERNAL "C++ Compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "ASM Compiler")

set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PREFIX}/${${TOOLCHAIN}} ${CMAKE_PREFIX_PATH})
#---------------------------------------------------------------------------------------
# Set compiler/linker flags
#---------------------------------------------------------------------------------------

# Object build options
# -O0                   No optimizations, reduce compilation time and make debugging produce the expected results.
# -mthumb               Generat thumb instructions.
# -fno-builtin          Do not use built-in functions provided by GCC.
# -Wall                 Print only standard warnings, for all use Wextra
# -ffunction-sections   Place each function item into its own section in the output file.
# -fdata-sections       Place each data item into its own section in the output file.
# -fomit-frame-pointer  Omit the frame pointer in functions that don’t need one.
# -mabi=aapcs           Defines enums to be a variable sized type.

# cpu
SET(CPU "-mcpu=cortex-m4")
# fpu
SET(FPU "-mfpu=fpv4-sp-d16")
# float-abi
SET(FLOAT-ABI "-mfloat-abi=hard")
# mcu
SET(MCU "${CPU} -mthumb ${FPU} ${FLOAT-ABI}")

execute_process(
  COMMAND bash -c "${CMAKE_C_COMPILER} ${MCU} -print-sysroot"
  OUTPUT_VARIABLE SYSROOT
)
execute_process(
  COMMAND bash -c "${CMAKE_C_COMPILER} ${MCU} -print-multi-directory"
  OUTPUT_VARIABLE MULTI_DIR
)
execute_process(
  COMMAND bash -c "${CMAKE_C_COMPILER} ${MCU} -print-libgcc-file-name"
  OUTPUT_VARIABLE BUILTINS
)
string(REGEX REPLACE "\n" "" SYSROOT ${SYSROOT})
string(REGEX REPLACE "\n" "" MULTI_DIR ${MULTI_DIR})
string(REGEX REPLACE "\n" "" BUILTINS ${BUILTINS})

# CFLAG option
#SET(OPT "-O0 -g3 -gdwarf-2")
SET(OPT "-O0")

#set(OBJECT_GEN_FLAGS "-O0 -mthumb -fno-builtin -Wall -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs")
#set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS} -std=gnu99 " CACHE INTERNAL "C Compiler options")
#set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} -std=c++11 " CACHE INTERNAL "C++ Compiler options")
#set(CMAKE_ASM_FLAGS "${OBJECT_GEN_FLAGS} -x assembler-with-cpp " CACHE INTERNAL "ASM Compiler options")

set(OBJECT_GEN_FLAGS "${MCU} ${OPT} -Wall -fdata-sections -ffunction-sections")
set(OBJECT_GEN_FLAGS "${OBJECT_GEN_FLAGS} -fno-builtin -fomit-frame-pointer -mabi=aapcs")

SET(SYSROOT_OPT "--sysroot=${SYSROOT}")
set(CMAKE_ASM_FLAGS "${OBJECT_GEN_FLAGS} -x assembler-with-cpp " CACHE INTERNAL "ASM Compiler options")
set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS} ${SYSROOT_OPT} -std=c99 " CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} ${SYSROOT_OPT} -std=gnu++11 " CACHE INTERNAL "C++ Compiler options")

#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DGTEST_HAS_POSIX_RE=0" CACHE INTERNAL "CXX_0")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DGTEST_HAS_PTHREAD=0" CACHE INTERNAL "CXX_1")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DGTEST_IS_THREADSAFE=0")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DGTEST_OS_NONE" CACHE INTERNAL "CXX_3")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCHECK_FUNCTION_EXISTS=1" CACHE INTERNAL "CXX_3")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCREATE_SHARED_LIBRARY=0" CACHE INTERNAL "CXX_3")

# -Wl,--gc-sections     Perform the dead code elimination.
# --specs=nano.specs    Link with newlib-nano.
# --specs=nosys.specs   No syscalls, provide empty implementations for the POSIX system calls.
#set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections --specs=nano.specs --specs=nosys.specs -mthumb -mabi=aapcs -Wl,-Map=${CMAKE_PROJECT_NAME}.map" CACHE INTERNAL "Linker options")
#SET(LIBS "-lc -lm -lnosys ${BUILTINS}")
SET(LIBS "-lc -lm -lnosys")
SET(LIBDIR "-L${SYSROOT}/lib/${MULTI_DIR}")
SET(SPECS "-specs=nano.specs")
set(CMAKE_EXE_LINKER_FLAGS "${MCU} ${SPECS} ${LIBDIR} ${LIBS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -mabi=aapcs -Wl,-Map=${CMAKE_PROJECT_NAME}.map,--cref -Wl,--gc-sections " CACHE INTERNAL "Linker options")

#---------------------------------------------------------------------------------------
# Set debug/release build configuration Options
#---------------------------------------------------------------------------------------

# Options for DEBUG build
# -Og   Enables optimizations that do not interfere with debugging.
# -g    Produce debugging information in the operating system’s native format.
set(CMAKE_C_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_ASM_FLAGS_DEBUG "-g" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "Linker options for debug build type")

# Options for RELEASE build
# -Os   Optimize for size. -Os enables all -O2 optimizations.
# -flto Runs the standard link-time optimizer.
set(CMAKE_C_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-flto" CACHE INTERNAL "Linker options for release build type")


set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
