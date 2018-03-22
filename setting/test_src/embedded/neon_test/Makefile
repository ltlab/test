#ARM_CC = arm-none-linux-gnueabi-gcc
ARM_CC = arm-hisiv400-linux-gcc

#CFLAGS = -c -g -O3 -Wall -Wstrict-prototypes -march=armv7-a -mtune=cortex-a8 
CFLAGS = -c -g -O3 -Wall -Wstrict-prototypes -mcpu=cortex-a7 -ffunction-sections -mno-unaligned-access -fno-aggressive-loop-optimizations
NEON_CFLAGS = -D__NEON__ -mfpu=neon-vfpv4 -ftree-vectorize -mfloat-abi=softfp
NEON_CFLAGS += -ftree-vectorize -funsafe-math-optimizations

VFP_CFLAGS = -mfpu=vfp -ftree-vectorize -mfloat-abi=softfp

all: neon no_neon

neon: neon.c
	$(ARM_CC) -o neon.s $(CFLAGS) -S $(NEON_CFLAGS) neon.c
	$(ARM_CC) -o neon.o $(CFLAGS) -Wa,-ahlms=neon.lst $(NEON_CFLAGS) neon.c
	$(ARM_CC) neon.o -o neon

no_neon: neon.c
	$(ARM_CC) -o no_neon.s $(CFLAGS) -S $(VFP_CFLAGS) neon.c
	$(ARM_CC) -o no_neon.o $(CFLAGS) -Wa,-ahlms=no_neon.lst $(VFP_CFLAGS) neon.c
#	$(ARM_CC) -o no_neon.s $(CFLAGS) -S neon.c
#	$(ARM_CC) -o no_neon.o $(CFLAGS) -Wa,-ahlms=no_neon.lst neon.c
	$(ARM_CC) no_neon.o -o no_neon

clean:
	rm -f no_neon*
	rm -f neon *.o *.s neon.lst
