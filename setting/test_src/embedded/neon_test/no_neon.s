	.cpu cortex-a7
	.eabi_attribute 27, 3
	.fpu vfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"neon.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.section	.text.NeonTest_add,"ax",%progbits
	.align	2
	.global	NeonTest_add
	.type	NeonTest_add, %function
NeonTest_add:
.LFB11:
	.file 1 "neon.c"
	.loc 1 31 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
.LVL0:
	mov	r3, #0
	str	lr, [sp, #-4]!
	.cfi_def_cfa_offset 4
	.cfi_offset 14, -4
.LVL1:
.L3:
	.loc 1 35 0 discriminator 2
	ldr	lr, [r0, r3]
	ldr	ip, [r1, r3]
	add	ip, lr, ip
	str	ip, [r2, r3]
	add	r3, r3, #4
	.loc 1 33 0 discriminator 2
	cmp	r3, #1024
	bne	.L3
	.loc 1 38 0
	ldr	pc, [sp], #4
	.cfi_endproc
.LFE11:
	.size	NeonTest_add, .-NeonTest_add
	.section	.text.NeonTest_mul,"ax",%progbits
	.align	2
	.global	NeonTest_mul
	.type	NeonTest_mul, %function
NeonTest_mul:
.LFB12:
	.loc 1 41 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
.LVL2:
	.loc 1 43 0
	mov	r3, #0
.LVL3:
.L9:
	.loc 1 45 0 discriminator 2
	fldmias	r0!, {s14}
	.loc 1 43 0 discriminator 2
	add	r3, r3, #1
.LVL4:
	.loc 1 45 0 discriminator 2
	fldmias	r1!, {s15}
	.loc 1 43 0 discriminator 2
	cmp	r3, #256
	.loc 1 45 0 discriminator 2
	fmuls	s15, s14, s15
	fstmias	r2!, {s15}
	.loc 1 43 0 discriminator 2
	bne	.L9
	.loc 1 48 0
	bx	lr
	.cfi_endproc
.LFE12:
	.size	NeonTest_mul, .-NeonTest_mul
	.section	.text.startup.main,"ax",%progbits
	.align	2
	.global	main
	.type	main, %function
main:
.LFB13:
	.loc 1 77 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	.loc 1 120 0
	mov	r0, #0
	bx	lr
	.cfi_endproc
.LFE13:
	.size	main, .-main
	.text
.Letext0:
	.file 2 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/lib/gcc/arm-hisiv400-linux-gnueabi/4.8.3/include/stddef.h"
	.file 3 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/usr/include/bits/types.h"
	.file 4 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/usr/include/libio.h"
	.file 5 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/usr/include/stdio.h"
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.4byte	0x3bd
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF52
	.byte	0x1
	.4byte	.LASF53
	.4byte	.LASF54
	.4byte	.Ldebug_ranges0+0
	.4byte	0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.4byte	.LASF8
	.byte	0x2
	.byte	0xd4
	.4byte	0x30
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF0
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF1
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.4byte	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.4byte	.LASF5
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.4byte	.LASF6
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.4byte	.LASF7
	.uleb128 0x2
	.4byte	.LASF9
	.byte	0x3
	.byte	0x37
	.4byte	0x61
	.uleb128 0x2
	.4byte	.LASF10
	.byte	0x3
	.byte	0x8c
	.4byte	0x85
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.4byte	.LASF11
	.uleb128 0x2
	.4byte	.LASF12
	.byte	0x3
	.byte	0x8d
	.4byte	0x6f
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF13
	.uleb128 0x5
	.byte	0x4
	.uleb128 0x6
	.byte	0x4
	.4byte	0xa6
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF14
	.uleb128 0x7
	.4byte	.LASF44
	.byte	0x98
	.byte	0x4
	.byte	0xfd
	.4byte	0x232
	.uleb128 0x8
	.4byte	.LASF15
	.byte	0x4
	.byte	0xfe
	.4byte	0x5a
	.byte	0
	.uleb128 0x9
	.4byte	.LASF16
	.byte	0x4
	.2byte	0x103
	.4byte	0xa0
	.byte	0x4
	.uleb128 0x9
	.4byte	.LASF17
	.byte	0x4
	.2byte	0x104
	.4byte	0xa0
	.byte	0x8
	.uleb128 0x9
	.4byte	.LASF18
	.byte	0x4
	.2byte	0x105
	.4byte	0xa0
	.byte	0xc
	.uleb128 0x9
	.4byte	.LASF19
	.byte	0x4
	.2byte	0x106
	.4byte	0xa0
	.byte	0x10
	.uleb128 0x9
	.4byte	.LASF20
	.byte	0x4
	.2byte	0x107
	.4byte	0xa0
	.byte	0x14
	.uleb128 0x9
	.4byte	.LASF21
	.byte	0x4
	.2byte	0x108
	.4byte	0xa0
	.byte	0x18
	.uleb128 0x9
	.4byte	.LASF22
	.byte	0x4
	.2byte	0x109
	.4byte	0xa0
	.byte	0x1c
	.uleb128 0x9
	.4byte	.LASF23
	.byte	0x4
	.2byte	0x10a
	.4byte	0xa0
	.byte	0x20
	.uleb128 0x9
	.4byte	.LASF24
	.byte	0x4
	.2byte	0x10c
	.4byte	0xa0
	.byte	0x24
	.uleb128 0x9
	.4byte	.LASF25
	.byte	0x4
	.2byte	0x10d
	.4byte	0xa0
	.byte	0x28
	.uleb128 0x9
	.4byte	.LASF26
	.byte	0x4
	.2byte	0x10e
	.4byte	0xa0
	.byte	0x2c
	.uleb128 0x9
	.4byte	.LASF27
	.byte	0x4
	.2byte	0x110
	.4byte	0x26a
	.byte	0x30
	.uleb128 0x9
	.4byte	.LASF28
	.byte	0x4
	.2byte	0x112
	.4byte	0x270
	.byte	0x34
	.uleb128 0x9
	.4byte	.LASF29
	.byte	0x4
	.2byte	0x114
	.4byte	0x5a
	.byte	0x38
	.uleb128 0x9
	.4byte	.LASF30
	.byte	0x4
	.2byte	0x118
	.4byte	0x5a
	.byte	0x3c
	.uleb128 0x9
	.4byte	.LASF31
	.byte	0x4
	.2byte	0x11a
	.4byte	0x7a
	.byte	0x40
	.uleb128 0x9
	.4byte	.LASF32
	.byte	0x4
	.2byte	0x11e
	.4byte	0x3e
	.byte	0x44
	.uleb128 0x9
	.4byte	.LASF33
	.byte	0x4
	.2byte	0x11f
	.4byte	0x4c
	.byte	0x46
	.uleb128 0x9
	.4byte	.LASF34
	.byte	0x4
	.2byte	0x120
	.4byte	0x276
	.byte	0x47
	.uleb128 0x9
	.4byte	.LASF35
	.byte	0x4
	.2byte	0x124
	.4byte	0x286
	.byte	0x48
	.uleb128 0x9
	.4byte	.LASF36
	.byte	0x4
	.2byte	0x12d
	.4byte	0x8c
	.byte	0x50
	.uleb128 0x9
	.4byte	.LASF37
	.byte	0x4
	.2byte	0x136
	.4byte	0x9e
	.byte	0x58
	.uleb128 0x9
	.4byte	.LASF38
	.byte	0x4
	.2byte	0x137
	.4byte	0x9e
	.byte	0x5c
	.uleb128 0x9
	.4byte	.LASF39
	.byte	0x4
	.2byte	0x138
	.4byte	0x9e
	.byte	0x60
	.uleb128 0x9
	.4byte	.LASF40
	.byte	0x4
	.2byte	0x139
	.4byte	0x9e
	.byte	0x64
	.uleb128 0x9
	.4byte	.LASF41
	.byte	0x4
	.2byte	0x13a
	.4byte	0x25
	.byte	0x68
	.uleb128 0x9
	.4byte	.LASF42
	.byte	0x4
	.2byte	0x13c
	.4byte	0x5a
	.byte	0x6c
	.uleb128 0x9
	.4byte	.LASF43
	.byte	0x4
	.2byte	0x13e
	.4byte	0x28c
	.byte	0x70
	.byte	0
	.uleb128 0xa
	.4byte	.LASF55
	.byte	0x4
	.byte	0xa2
	.uleb128 0x7
	.4byte	.LASF45
	.byte	0xc
	.byte	0x4
	.byte	0xa8
	.4byte	0x26a
	.uleb128 0x8
	.4byte	.LASF46
	.byte	0x4
	.byte	0xa9
	.4byte	0x26a
	.byte	0
	.uleb128 0x8
	.4byte	.LASF47
	.byte	0x4
	.byte	0xaa
	.4byte	0x270
	.byte	0x4
	.uleb128 0x8
	.4byte	.LASF48
	.byte	0x4
	.byte	0xae
	.4byte	0x5a
	.byte	0x8
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x239
	.uleb128 0x6
	.byte	0x4
	.4byte	0xad
	.uleb128 0xb
	.4byte	0xa6
	.4byte	0x286
	.uleb128 0xc
	.4byte	0x97
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x232
	.uleb128 0xb
	.4byte	0xa6
	.4byte	0x29c
	.uleb128 0xc
	.4byte	0x97
	.byte	0x27
	.byte	0
	.uleb128 0xd
	.4byte	.LASF56
	.byte	0x1
	.byte	0x28
	.byte	0x1
	.4byte	0x2cd
	.uleb128 0xe
	.ascii	"a\000"
	.byte	0x1
	.byte	0x28
	.4byte	0x2cd
	.uleb128 0xe
	.ascii	"b\000"
	.byte	0x1
	.byte	0x28
	.4byte	0x2cd
	.uleb128 0xe
	.ascii	"c\000"
	.byte	0x1
	.byte	0x28
	.4byte	0x2cd
	.uleb128 0xf
	.ascii	"i\000"
	.byte	0x1
	.byte	0x2a
	.4byte	0x5a
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x2d3
	.uleb128 0x3
	.byte	0x4
	.byte	0x4
	.4byte	.LASF49
	.uleb128 0x10
	.4byte	.LASF57
	.byte	0x1
	.byte	0x1e
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x31e
	.uleb128 0x11
	.ascii	"x\000"
	.byte	0x1
	.byte	0x1e
	.4byte	0x31e
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x11
	.ascii	"y\000"
	.byte	0x1
	.byte	0x1e
	.4byte	0x31e
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x11
	.ascii	"z\000"
	.byte	0x1
	.byte	0x1e
	.4byte	0x31e
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x12
	.ascii	"i\000"
	.byte	0x1
	.byte	0x20
	.4byte	0x5a
	.4byte	.LLST0
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x5a
	.uleb128 0x13
	.4byte	0x29c
	.4byte	.LFB12
	.4byte	.LFE12-.LFB12
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x35c
	.uleb128 0x14
	.4byte	0x2a8
	.4byte	.LLST1
	.uleb128 0x14
	.4byte	0x2b1
	.4byte	.LLST2
	.uleb128 0x14
	.4byte	0x2ba
	.4byte	.LLST3
	.uleb128 0x15
	.4byte	0x2c3
	.4byte	.LLST4
	.byte	0
	.uleb128 0x16
	.4byte	.LASF58
	.byte	0x1
	.byte	0x4c
	.4byte	0x5a
	.4byte	.LFB13
	.4byte	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x39a
	.uleb128 0xf
	.ascii	"i\000"
	.byte	0x1
	.byte	0x4e
	.4byte	0x5a
	.uleb128 0xf
	.ascii	"a\000"
	.byte	0x1
	.byte	0x51
	.4byte	0x39a
	.uleb128 0xf
	.ascii	"b\000"
	.byte	0x1
	.byte	0x51
	.4byte	0x39a
	.uleb128 0xf
	.ascii	"c\000"
	.byte	0x1
	.byte	0x51
	.4byte	0x39a
	.byte	0
	.uleb128 0xb
	.4byte	0x2d3
	.4byte	0x3aa
	.uleb128 0xc
	.4byte	0x97
	.byte	0xff
	.byte	0
	.uleb128 0x17
	.4byte	.LASF50
	.byte	0x5
	.byte	0xa8
	.4byte	0x270
	.uleb128 0x17
	.4byte	.LASF51
	.byte	0x5
	.byte	0xa9
	.4byte	0x270
	.byte	0
	.section	.debug_abbrev,"",%progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",%progbits
.Ldebug_loc0:
.LLST0:
	.4byte	.LVL0
	.4byte	.LVL1
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST1:
	.4byte	.LVL2
	.4byte	.LVL3
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL3
	.4byte	.LFE12
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST2:
	.4byte	.LVL2
	.4byte	.LVL3
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL3
	.4byte	.LFE12
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST3:
	.4byte	.LVL2
	.4byte	.LVL3
	.2byte	0x1
	.byte	0x52
	.4byte	.LVL3
	.4byte	.LFE12
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST4:
	.4byte	.LVL2
	.4byte	.LVL3
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	.LVL3
	.4byte	.LFE12
	.2byte	0x1
	.byte	0x53
	.4byte	0
	.4byte	0
	.section	.debug_aranges,"",%progbits
	.4byte	0x2c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.4byte	.LFB12
	.4byte	.LFE12-.LFB12
	.4byte	.LFB13
	.4byte	.LFE13-.LFB13
	.4byte	0
	.4byte	0
	.section	.debug_ranges,"",%progbits
.Ldebug_ranges0:
	.4byte	.LFB11
	.4byte	.LFE11
	.4byte	.LFB12
	.4byte	.LFE12
	.4byte	.LFB13
	.4byte	.LFE13
	.4byte	0
	.4byte	0
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.section	.debug_str,"MS",%progbits,1
.LASF23:
	.ascii	"_IO_buf_end\000"
.LASF9:
	.ascii	"__quad_t\000"
.LASF31:
	.ascii	"_old_offset\000"
.LASF26:
	.ascii	"_IO_save_end\000"
.LASF5:
	.ascii	"short int\000"
.LASF8:
	.ascii	"size_t\000"
.LASF13:
	.ascii	"sizetype\000"
.LASF36:
	.ascii	"_offset\000"
.LASF20:
	.ascii	"_IO_write_ptr\000"
.LASF15:
	.ascii	"_flags\000"
.LASF22:
	.ascii	"_IO_buf_base\000"
.LASF27:
	.ascii	"_markers\000"
.LASF17:
	.ascii	"_IO_read_end\000"
.LASF57:
	.ascii	"NeonTest_add\000"
.LASF49:
	.ascii	"float\000"
.LASF6:
	.ascii	"long long int\000"
.LASF35:
	.ascii	"_lock\000"
.LASF11:
	.ascii	"long int\000"
.LASF32:
	.ascii	"_cur_column\000"
.LASF48:
	.ascii	"_pos\000"
.LASF47:
	.ascii	"_sbuf\000"
.LASF44:
	.ascii	"_IO_FILE\000"
.LASF56:
	.ascii	"NeonTest_mul\000"
.LASF1:
	.ascii	"unsigned char\000"
.LASF4:
	.ascii	"signed char\000"
.LASF7:
	.ascii	"long long unsigned int\000"
.LASF52:
	.ascii	"GNU C 4.8.3 20131202 (prerelease) -mcpu=cortex-a7 -"
	.ascii	"mno-unaligned-access -mfpu=vfp -mfloat-abi=softfp -"
	.ascii	"mtls-dialect=gnu -g -O3 -ffunction-sections -fno-ag"
	.ascii	"gressive-loop-optimizations -ftree-vectorize\000"
.LASF0:
	.ascii	"unsigned int\000"
.LASF45:
	.ascii	"_IO_marker\000"
.LASF34:
	.ascii	"_shortbuf\000"
.LASF19:
	.ascii	"_IO_write_base\000"
.LASF43:
	.ascii	"_unused2\000"
.LASF16:
	.ascii	"_IO_read_ptr\000"
.LASF2:
	.ascii	"short unsigned int\000"
.LASF14:
	.ascii	"char\000"
.LASF58:
	.ascii	"main\000"
.LASF46:
	.ascii	"_next\000"
.LASF37:
	.ascii	"__pad1\000"
.LASF38:
	.ascii	"__pad2\000"
.LASF39:
	.ascii	"__pad3\000"
.LASF40:
	.ascii	"__pad4\000"
.LASF41:
	.ascii	"__pad5\000"
.LASF25:
	.ascii	"_IO_backup_base\000"
.LASF53:
	.ascii	"neon.c\000"
.LASF3:
	.ascii	"long unsigned int\000"
.LASF21:
	.ascii	"_IO_write_end\000"
.LASF12:
	.ascii	"__off64_t\000"
.LASF10:
	.ascii	"__off_t\000"
.LASF28:
	.ascii	"_chain\000"
.LASF54:
	.ascii	"/home/jyhuh/setting/test_src/embedded/neon_test\000"
.LASF50:
	.ascii	"stdin\000"
.LASF30:
	.ascii	"_flags2\000"
.LASF42:
	.ascii	"_mode\000"
.LASF18:
	.ascii	"_IO_read_base\000"
.LASF33:
	.ascii	"_vtable_offset\000"
.LASF24:
	.ascii	"_IO_save_base\000"
.LASF29:
	.ascii	"_fileno\000"
.LASF51:
	.ascii	"stdout\000"
.LASF55:
	.ascii	"_IO_lock_t\000"
	.ident	"GCC: (Hisilicon_v400) 4.8.3 20131202 (prerelease)"
	.section	.note.GNU-stack,"",%progbits
