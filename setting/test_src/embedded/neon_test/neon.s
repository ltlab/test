	.cpu cortex-a7
	.eabi_attribute 27, 3
	.fpu neon
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
	add	r3, r2, #16
	add	ip, r1, #16
	cmp	r2, ip
	cmpcc	r1, r3
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, lr}
	.cfi_def_cfa_offset 28
	.cfi_offset 4, -28
	.cfi_offset 5, -24
	.cfi_offset 6, -20
	.cfi_offset 7, -16
	.cfi_offset 8, -12
	.cfi_offset 9, -8
	.cfi_offset 14, -4
	add	lr, r0, #16
	movcs	ip, #1
	movcc	ip, #0
	cmp	r2, lr
	cmpcc	r0, r3
	movcs	r3, #1
	movcc	r3, #0
	ands	r3, ip, r3
	beq	.L5
	mov	ip, r0
	mov	r8, r1
	mov	lr, r2
	add	r9, r0, #1024
.LVL1:
.L4:
	.loc 1 35 0 discriminator 2
	ldr	r4, [ip]
	add	ip, ip, #16
	ldr	r5, [ip, #-12]
	add	r8, r8, #16
	ldr	r0, [r8, #-16]
	add	lr, lr, #16
	ldr	r1, [r8, #-12]
	ldr	r6, [ip, #-8]
	ldr	r2, [r8, #-8]
	ldr	r7, [ip, #-4]
	ldr	r3, [r8, #-4]
	vmov	d16, r4, r5  @ v4si
	vmov	d17, r6, r7
	vmov	d18, r0, r1  @ v4si
	vmov	d19, r2, r3
	cmp	ip, r9
	vadd.i32	q8, q8, q9
	vmov	r0, r1, d16  @ v4si
	vmov	r2, r3, d17
	str	r0, [lr, #-16]
	mov	r5, r1
	str	r1, [lr, #-12]
	mov	r4, r2
	str	r2, [lr, #-8]
	str	r3, [lr, #-4]
	bne	.L4
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, pc}
.LVL2:
.L5:
	.loc 1 35 0 is_stmt 0
	ldr	r5, [r0, r3]
	ldr	r4, [r1, r3]
	add	r4, r5, r4
	str	r4, [r2, r3]
	add	r3, r3, #4
	.loc 1 33 0 is_stmt 1
	cmp	r3, #1024
	bne	.L5
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, pc}
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
.LVL3:
	sbfx	r3, r0, #2, #1
	ands	r3, r3, #3
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	.cfi_def_cfa_offset 36
	.cfi_offset 4, -36
	.cfi_offset 5, -32
	.cfi_offset 6, -28
	.cfi_offset 7, -24
	.cfi_offset 8, -20
	.cfi_offset 9, -16
	.cfi_offset 10, -12
	.cfi_offset 11, -8
	.cfi_offset 14, -4
	sub	sp, sp, #20
	.cfi_def_cfa_offset 56
	beq	.L21
	.loc 1 45 0
	flds	s14, [r1]
	flds	s15, [r0]
	cmp	r3, #1
	fmuls	s15, s14, s15
	fsts	s15, [r2]
.LVL4:
	bls	.L22
	flds	s14, [r1, #4]
	flds	s15, [r0, #4]
	cmp	r3, #2
	fmuls	s15, s14, s15
	fsts	s15, [r2, #4]
.LVL5:
	bls	.L23
	flds	s14, [r0, #8]
	mov	ip, #253
	flds	s15, [r1, #8]
	str	ip, [sp, #12]
	.loc 1 43 0
	mov	ip, #3
	.loc 1 45 0
	fmuls	s15, s14, s15
	.loc 1 43 0
	str	ip, [sp, #8]
	.loc 1 45 0
	fsts	s15, [r2, #8]
.LVL6:
.L14:
	rsb	ip, r3, #256
	.loc 1 43 0
	mov	lr, #0
	mov	r8, r3, asl #2
	mov	fp, ip, lsr #2
	str	ip, [sp, #4]
	mov	r3, fp, asl #2
	add	ip, r1, r8
	str	r3, [sp]
	add	r3, r2, r8
	add	r8, r0, r8
.L20:
	.loc 1 45 0 discriminator 2
	ldr	r4, [ip]
	add	lr, lr, #1
	ldr	r5, [ip, #4]
	add	r3, r3, #16
	ldr	r6, [ip, #8]
	add	ip, ip, #16
	ldr	r7, [ip, #-4]
	vld1.64	{d16-d17}, [r8:64]!
	vmov	d18, r4, r5  @ v4sf
	vmov	d19, r6, r7
	cmp	fp, lr
	vmul.f32	q9, q9, q8
	vmov	r4, r5, d18  @ v4sf
	vmov	r6, r7, d19
	str	r4, [r3, #-16]
	str	r5, [r3, #-12]
	str	r6, [r3, #-8]
	str	r7, [r3, #-4]
	bhi	.L20
	ldr	ip, [sp]
	ldr	r3, [sp, #4]
	cmp	r3, ip
	ldr	r3, [sp, #12]
	rsb	r4, ip, r3
	ldr	r3, [sp, #8]
	add	lr, r3, ip
	beq	.L13
.LVL7:
	.loc 1 45 0 is_stmt 0
	mov	ip, lr, asl #2
	.loc 1 43 0 is_stmt 1
	add	r3, lr, #1
.LVL8:
	.loc 1 45 0
	add	r6, r0, ip
	add	r5, r1, ip
	flds	s14, [r6]
	flds	s15, [r5]
	add	ip, r2, ip
	fmuls	s15, s14, s15
	.loc 1 43 0
	cmp	r4, #1
	.loc 1 45 0
	fsts	s15, [ip]
	.loc 1 43 0
	beq	.L13
	.loc 1 45 0
	mov	r3, r3, asl #2
.LVL9:
	.loc 1 43 0
	add	lr, lr, #2
.LVL10:
	.loc 1 45 0
	add	r5, r1, r3
	add	ip, r0, r3
	flds	s14, [r5]
	flds	s15, [ip]
	add	r3, r2, r3
	fmuls	s15, s14, s15
	.loc 1 43 0
	cmp	r4, #2
	.loc 1 45 0
	fsts	s15, [r3]
.LVL11:
	.loc 1 43 0
	beq	.L13
	.loc 1 45 0
	mov	r3, lr, asl #2
	add	r1, r1, r3
.LVL12:
	add	r0, r0, r3
.LVL13:
	flds	s14, [r1]
	flds	s15, [r0]
	add	r3, r2, r3
	fmuls	s15, s14, s15
	fsts	s15, [r3]
.LVL14:
.L13:
	.loc 1 48 0
	add	sp, sp, #20
	.cfi_remember_state
	.cfi_def_cfa_offset 36
	@ sp needed
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, r10, fp, pc}
.LVL15:
.L21:
	.cfi_restore_state
	.loc 1 43 0
	str	r3, [sp, #8]
	mov	ip, #256
	str	ip, [sp, #12]
	b	.L14
.LVL16:
.L23:
	.loc 1 45 0
	mov	ip, #254
	str	ip, [sp, #12]
	.loc 1 43 0
	mov	ip, #2
	str	ip, [sp, #8]
	b	.L14
.LVL17:
.L22:
	.loc 1 45 0
	mov	ip, #255
	str	ip, [sp, #12]
	.loc 1 43 0
	mov	ip, #1
	str	ip, [sp, #8]
	b	.L14
	.cfi_endproc
.LFE12:
	.size	NeonTest_mul, .-NeonTest_mul
	.section	.text.intrinsics,"ax",%progbits
	.align	2
	.global	intrinsics
	.type	intrinsics, %function
intrinsics:
.LFB1883:
	.loc 1 52 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
.LVL18:
	add	r3, r0, #1024
.LVL19:
.L31:
.LBB12:
.LBB13:
	.file 2 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/lib/gcc/arm-hisiv400-linux-gnueabi/4.8.3/include/arm_neon.h"
	.loc 2 8121 0
	vld1.32	{d18-d19}, [r0]!
.LVL20:
.LBE13:
.LBE12:
.LBB14:
.LBB15:
	vld1.32	{d16-d17}, [r1]!
.LVL21:
.LBE15:
.LBE14:
	.loc 1 60 0
	cmp	r0, r3
.LBB16:
.LBB17:
	.loc 2 499 0
	vadd.i32	q8, q9, q8
.LVL22:
.LBE17:
.LBE16:
.LBB18:
.LBB19:
	.loc 2 8517 0
	vst1.32	{d16-d17}, [r2]!
.LVL23:
.LBE19:
.LBE18:
	.loc 1 60 0
	bne	.L31
	.loc 1 71 0
	bx	lr
	.cfi_endproc
.LFE1883:
	.size	intrinsics, .-intrinsics
	.section	.text.startup.main,"ax",%progbits
	.align	2
	.global	main
	.type	main, %function
main:
.LFB1884:
	.loc 1 77 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	.loc 1 120 0
	mov	r0, #0
	bx	lr
	.cfi_endproc
.LFE1884:
	.size	main, .-main
	.text
.Letext0:
	.file 3 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/lib/gcc/arm-hisiv400-linux-gnueabi/4.8.3/include/stddef.h"
	.file 4 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/usr/include/bits/types.h"
	.file 5 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/usr/include/libio.h"
	.file 6 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/usr/include/stdint.h"
	.file 7 "/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/usr/include/stdio.h"
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.4byte	0x5e9
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF71
	.byte	0x1
	.4byte	.LASF72
	.4byte	.LASF73
	.4byte	.Ldebug_ranges0+0
	.4byte	0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.4byte	.LASF8
	.byte	0x3
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
	.byte	0x4
	.byte	0x37
	.4byte	0x61
	.uleb128 0x2
	.4byte	.LASF10
	.byte	0x4
	.byte	0x8c
	.4byte	0x85
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.4byte	.LASF11
	.uleb128 0x2
	.4byte	.LASF12
	.byte	0x4
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
	.byte	0x5
	.byte	0xfd
	.4byte	0x232
	.uleb128 0x8
	.4byte	.LASF15
	.byte	0x5
	.byte	0xfe
	.4byte	0x5a
	.byte	0
	.uleb128 0x9
	.4byte	.LASF16
	.byte	0x5
	.2byte	0x103
	.4byte	0xa0
	.byte	0x4
	.uleb128 0x9
	.4byte	.LASF17
	.byte	0x5
	.2byte	0x104
	.4byte	0xa0
	.byte	0x8
	.uleb128 0x9
	.4byte	.LASF18
	.byte	0x5
	.2byte	0x105
	.4byte	0xa0
	.byte	0xc
	.uleb128 0x9
	.4byte	.LASF19
	.byte	0x5
	.2byte	0x106
	.4byte	0xa0
	.byte	0x10
	.uleb128 0x9
	.4byte	.LASF20
	.byte	0x5
	.2byte	0x107
	.4byte	0xa0
	.byte	0x14
	.uleb128 0x9
	.4byte	.LASF21
	.byte	0x5
	.2byte	0x108
	.4byte	0xa0
	.byte	0x18
	.uleb128 0x9
	.4byte	.LASF22
	.byte	0x5
	.2byte	0x109
	.4byte	0xa0
	.byte	0x1c
	.uleb128 0x9
	.4byte	.LASF23
	.byte	0x5
	.2byte	0x10a
	.4byte	0xa0
	.byte	0x20
	.uleb128 0x9
	.4byte	.LASF24
	.byte	0x5
	.2byte	0x10c
	.4byte	0xa0
	.byte	0x24
	.uleb128 0x9
	.4byte	.LASF25
	.byte	0x5
	.2byte	0x10d
	.4byte	0xa0
	.byte	0x28
	.uleb128 0x9
	.4byte	.LASF26
	.byte	0x5
	.2byte	0x10e
	.4byte	0xa0
	.byte	0x2c
	.uleb128 0x9
	.4byte	.LASF27
	.byte	0x5
	.2byte	0x110
	.4byte	0x26a
	.byte	0x30
	.uleb128 0x9
	.4byte	.LASF28
	.byte	0x5
	.2byte	0x112
	.4byte	0x270
	.byte	0x34
	.uleb128 0x9
	.4byte	.LASF29
	.byte	0x5
	.2byte	0x114
	.4byte	0x5a
	.byte	0x38
	.uleb128 0x9
	.4byte	.LASF30
	.byte	0x5
	.2byte	0x118
	.4byte	0x5a
	.byte	0x3c
	.uleb128 0x9
	.4byte	.LASF31
	.byte	0x5
	.2byte	0x11a
	.4byte	0x7a
	.byte	0x40
	.uleb128 0x9
	.4byte	.LASF32
	.byte	0x5
	.2byte	0x11e
	.4byte	0x3e
	.byte	0x44
	.uleb128 0x9
	.4byte	.LASF33
	.byte	0x5
	.2byte	0x11f
	.4byte	0x4c
	.byte	0x46
	.uleb128 0x9
	.4byte	.LASF34
	.byte	0x5
	.2byte	0x120
	.4byte	0x276
	.byte	0x47
	.uleb128 0x9
	.4byte	.LASF35
	.byte	0x5
	.2byte	0x124
	.4byte	0x286
	.byte	0x48
	.uleb128 0x9
	.4byte	.LASF36
	.byte	0x5
	.2byte	0x12d
	.4byte	0x8c
	.byte	0x50
	.uleb128 0x9
	.4byte	.LASF37
	.byte	0x5
	.2byte	0x136
	.4byte	0x9e
	.byte	0x58
	.uleb128 0x9
	.4byte	.LASF38
	.byte	0x5
	.2byte	0x137
	.4byte	0x9e
	.byte	0x5c
	.uleb128 0x9
	.4byte	.LASF39
	.byte	0x5
	.2byte	0x138
	.4byte	0x9e
	.byte	0x60
	.uleb128 0x9
	.4byte	.LASF40
	.byte	0x5
	.2byte	0x139
	.4byte	0x9e
	.byte	0x64
	.uleb128 0x9
	.4byte	.LASF41
	.byte	0x5
	.2byte	0x13a
	.4byte	0x25
	.byte	0x68
	.uleb128 0x9
	.4byte	.LASF42
	.byte	0x5
	.2byte	0x13c
	.4byte	0x5a
	.byte	0x6c
	.uleb128 0x9
	.4byte	.LASF43
	.byte	0x5
	.2byte	0x13e
	.4byte	0x28c
	.byte	0x70
	.byte	0
	.uleb128 0xa
	.4byte	.LASF74
	.byte	0x5
	.byte	0xa2
	.uleb128 0x7
	.4byte	.LASF45
	.byte	0xc
	.byte	0x5
	.byte	0xa8
	.4byte	0x26a
	.uleb128 0x8
	.4byte	.LASF46
	.byte	0x5
	.byte	0xa9
	.4byte	0x26a
	.byte	0
	.uleb128 0x8
	.4byte	.LASF47
	.byte	0x5
	.byte	0xaa
	.4byte	0x270
	.byte	0x4
	.uleb128 0x8
	.4byte	.LASF48
	.byte	0x5
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
	.uleb128 0x2
	.4byte	.LASF49
	.byte	0x6
	.byte	0x33
	.4byte	0x30
	.uleb128 0x3
	.byte	0x1
	.byte	0x5
	.4byte	.LASF50
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.4byte	.LASF51
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.4byte	.LASF52
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.4byte	.LASF53
	.uleb128 0x3
	.byte	0x4
	.byte	0x4
	.4byte	.LASF54
	.uleb128 0x3
	.byte	0x2
	.byte	0x4
	.4byte	.LASF55
	.uleb128 0x3
	.byte	0x1
	.byte	0x5
	.4byte	.LASF56
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.4byte	.LASF57
	.uleb128 0x3
	.byte	0x1
	.byte	0x7
	.4byte	.LASF58
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.4byte	.LASF59
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF60
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.4byte	.LASF61
	.uleb128 0x2
	.4byte	.LASF62
	.byte	0x2
	.byte	0x37
	.4byte	0x306
	.uleb128 0xd
	.4byte	0x2b5
	.4byte	0x312
	.uleb128 0xe
	.byte	0x3
	.byte	0
	.uleb128 0x2
	.4byte	.LASF63
	.byte	0x2
	.byte	0x3e
	.4byte	0x31d
	.uleb128 0xd
	.4byte	0x2ed
	.4byte	0x329
	.uleb128 0xe
	.byte	0x3
	.byte	0
	.uleb128 0x3
	.byte	0x4
	.byte	0x4
	.4byte	.LASF64
	.uleb128 0xf
	.4byte	.LASF65
	.byte	0x2
	.2byte	0x1fb7
	.4byte	0x312
	.byte	0x3
	.4byte	0x34e
	.uleb128 0x10
	.ascii	"__a\000"
	.byte	0x2
	.2byte	0x1fb7
	.4byte	0x34e
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x354
	.uleb128 0x11
	.4byte	0x29c
	.uleb128 0xf
	.4byte	.LASF66
	.byte	0x2
	.2byte	0x1f1
	.4byte	0x312
	.byte	0x3
	.4byte	0x383
	.uleb128 0x10
	.ascii	"__a\000"
	.byte	0x2
	.2byte	0x1f1
	.4byte	0x312
	.uleb128 0x10
	.ascii	"__b\000"
	.byte	0x2
	.2byte	0x1f1
	.4byte	0x312
	.byte	0
	.uleb128 0x12
	.4byte	.LASF75
	.byte	0x2
	.2byte	0x2143
	.byte	0x3
	.4byte	0x3a9
	.uleb128 0x10
	.ascii	"__a\000"
	.byte	0x2
	.2byte	0x2143
	.4byte	0x3a9
	.uleb128 0x10
	.ascii	"__b\000"
	.byte	0x2
	.2byte	0x2143
	.4byte	0x312
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x29c
	.uleb128 0x13
	.4byte	.LASF76
	.byte	0x1
	.byte	0x28
	.byte	0x1
	.4byte	0x3e0
	.uleb128 0x14
	.ascii	"a\000"
	.byte	0x1
	.byte	0x28
	.4byte	0x3e0
	.uleb128 0x14
	.ascii	"b\000"
	.byte	0x1
	.byte	0x28
	.4byte	0x3e0
	.uleb128 0x14
	.ascii	"c\000"
	.byte	0x1
	.byte	0x28
	.4byte	0x3e0
	.uleb128 0x15
	.ascii	"i\000"
	.byte	0x1
	.byte	0x2a
	.4byte	0x5a
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x329
	.uleb128 0x16
	.4byte	.LASF67
	.byte	0x1
	.byte	0x1e
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x430
	.uleb128 0x17
	.ascii	"x\000"
	.byte	0x1
	.byte	0x1e
	.4byte	0x430
	.4byte	.LLST0
	.uleb128 0x17
	.ascii	"y\000"
	.byte	0x1
	.byte	0x1e
	.4byte	0x430
	.4byte	.LLST1
	.uleb128 0x17
	.ascii	"z\000"
	.byte	0x1
	.byte	0x1e
	.4byte	0x430
	.4byte	.LLST2
	.uleb128 0x18
	.ascii	"i\000"
	.byte	0x1
	.byte	0x20
	.4byte	0x5a
	.4byte	.LLST3
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x5a
	.uleb128 0x19
	.4byte	0x3af
	.4byte	.LFB12
	.4byte	.LFE12-.LFB12
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x46c
	.uleb128 0x1a
	.4byte	0x3bb
	.4byte	.LLST4
	.uleb128 0x1a
	.4byte	0x3c4
	.4byte	.LLST5
	.uleb128 0x1b
	.4byte	0x3cd
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1c
	.4byte	0x3d6
	.4byte	.LLST6
	.byte	0
	.uleb128 0x16
	.4byte	.LASF68
	.byte	0x1
	.byte	0x33
	.4byte	.LFB1883
	.4byte	.LFE1883-.LFB1883
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x588
	.uleb128 0x17
	.ascii	"x\000"
	.byte	0x1
	.byte	0x33
	.4byte	0x3a9
	.4byte	.LLST7
	.uleb128 0x17
	.ascii	"y\000"
	.byte	0x1
	.byte	0x33
	.4byte	0x3a9
	.4byte	.LLST8
	.uleb128 0x17
	.ascii	"z\000"
	.byte	0x1
	.byte	0x33
	.4byte	0x3a9
	.4byte	.LLST9
	.uleb128 0x18
	.ascii	"i\000"
	.byte	0x1
	.byte	0x35
	.4byte	0x5a
	.4byte	.LLST10
	.uleb128 0x15
	.ascii	"x4\000"
	.byte	0x1
	.byte	0x36
	.4byte	0x312
	.uleb128 0x15
	.ascii	"y4\000"
	.byte	0x1
	.byte	0x36
	.4byte	0x312
	.uleb128 0x15
	.ascii	"z4\000"
	.byte	0x1
	.byte	0x37
	.4byte	0x312
	.uleb128 0x18
	.ascii	"px\000"
	.byte	0x1
	.byte	0x38
	.4byte	0x3a9
	.4byte	.LLST11
	.uleb128 0x18
	.ascii	"py\000"
	.byte	0x1
	.byte	0x39
	.4byte	0x3a9
	.4byte	.LLST12
	.uleb128 0x1d
	.ascii	"pz\000"
	.byte	0x1
	.byte	0x3a
	.4byte	0x3a9
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1e
	.4byte	0x330
	.4byte	.LBB12
	.4byte	.LBE12-.LBB12
	.byte	0x1
	.byte	0x3e
	.4byte	0x518
	.uleb128 0x1a
	.4byte	0x341
	.4byte	.LLST13
	.byte	0
	.uleb128 0x1e
	.4byte	0x330
	.4byte	.LBB14
	.4byte	.LBE14-.LBB14
	.byte	0x1
	.byte	0x3f
	.4byte	0x535
	.uleb128 0x1a
	.4byte	0x341
	.4byte	.LLST14
	.byte	0
	.uleb128 0x1e
	.4byte	0x359
	.4byte	.LBB16
	.4byte	.LBE16-.LBB16
	.byte	0x1
	.byte	0x40
	.4byte	0x560
	.uleb128 0x1a
	.4byte	0x376
	.4byte	.LLST15
	.uleb128 0x1b
	.4byte	0x36a
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x34
	.byte	0x93
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x35
	.byte	0x93
	.uleb128 0x8
	.byte	0
	.uleb128 0x1f
	.4byte	0x383
	.4byte	.LBB18
	.4byte	.LBE18-.LBB18
	.byte	0x1
	.byte	0x41
	.uleb128 0x1b
	.4byte	0x39c
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x30
	.byte	0x93
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x31
	.byte	0x93
	.uleb128 0x8
	.uleb128 0x1a
	.4byte	0x390
	.4byte	.LLST16
	.byte	0
	.byte	0
	.uleb128 0x20
	.4byte	.LASF77
	.byte	0x1
	.byte	0x4c
	.4byte	0x5a
	.4byte	.LFB1884
	.4byte	.LFE1884-.LFB1884
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5c6
	.uleb128 0x15
	.ascii	"i\000"
	.byte	0x1
	.byte	0x4e
	.4byte	0x5a
	.uleb128 0x15
	.ascii	"a\000"
	.byte	0x1
	.byte	0x51
	.4byte	0x5c6
	.uleb128 0x15
	.ascii	"b\000"
	.byte	0x1
	.byte	0x51
	.4byte	0x5c6
	.uleb128 0x15
	.ascii	"c\000"
	.byte	0x1
	.byte	0x51
	.4byte	0x5c6
	.byte	0
	.uleb128 0xb
	.4byte	0x329
	.4byte	0x5d6
	.uleb128 0xc
	.4byte	0x97
	.byte	0xff
	.byte	0
	.uleb128 0x21
	.4byte	.LASF69
	.byte	0x7
	.byte	0xa8
	.4byte	0x270
	.uleb128 0x21
	.4byte	.LASF70
	.byte	0x7
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
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x2107
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x21
	.byte	0
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
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
	.uleb128 0x14
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
	.uleb128 0x15
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
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x18
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
	.uleb128 0x19
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
	.uleb128 0x1a
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x1d
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
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x20
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
	.uleb128 0x21
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
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL1
	.4byte	.LVL2
	.2byte	0x4
	.byte	0x79
	.sleb128 -1024
	.byte	0x9f
	.4byte	.LVL2
	.4byte	.LFE11
	.2byte	0x1
	.byte	0x50
	.4byte	0
	.4byte	0
.LLST1:
	.4byte	.LVL0
	.4byte	.LVL1
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL1
	.4byte	.LVL2
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	.LVL2
	.4byte	.LFE11
	.2byte	0x1
	.byte	0x51
	.4byte	0
	.4byte	0
.LLST2:
	.4byte	.LVL0
	.4byte	.LVL1
	.2byte	0x1
	.byte	0x52
	.4byte	.LVL1
	.4byte	.LVL2
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.4byte	.LVL2
	.4byte	.LFE11
	.2byte	0x1
	.byte	0x52
	.4byte	0
	.4byte	0
.LLST3:
	.4byte	.LVL0
	.4byte	.LVL1
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST4:
	.4byte	.LVL3
	.4byte	.LVL13
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL13
	.4byte	.LVL15
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	.LVL15
	.4byte	.LFE12
	.2byte	0x1
	.byte	0x50
	.4byte	0
	.4byte	0
.LLST5:
	.4byte	.LVL3
	.4byte	.LVL12
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL12
	.4byte	.LVL15
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	.LVL15
	.4byte	.LFE12
	.2byte	0x1
	.byte	0x51
	.4byte	0
	.4byte	0
.LLST6:
	.4byte	.LVL3
	.4byte	.LVL4
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	.LVL4
	.4byte	.LVL5
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.4byte	.LVL5
	.4byte	.LVL6
	.2byte	0x2
	.byte	0x32
	.byte	0x9f
	.4byte	.LVL7
	.4byte	.LVL8
	.2byte	0x1
	.byte	0x5e
	.4byte	.LVL8
	.4byte	.LVL9
	.2byte	0x1
	.byte	0x53
	.4byte	.LVL9
	.4byte	.LVL10
	.2byte	0x3
	.byte	0x7e
	.sleb128 1
	.byte	0x9f
	.4byte	.LVL10
	.4byte	.LVL11
	.2byte	0x3
	.byte	0x7e
	.sleb128 -1
	.byte	0x9f
	.4byte	.LVL11
	.4byte	.LVL14
	.2byte	0x1
	.byte	0x5e
	.4byte	.LVL15
	.4byte	.LVL16
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	.LVL16
	.4byte	.LVL17
	.2byte	0x2
	.byte	0x32
	.byte	0x9f
	.4byte	.LVL17
	.4byte	.LFE12
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST7:
	.4byte	.LVL18
	.4byte	.LVL19
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL19
	.4byte	.LFE1883
	.2byte	0x4
	.byte	0x73
	.sleb128 -1024
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST8:
	.4byte	.LVL18
	.4byte	.LVL19
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL19
	.4byte	.LFE1883
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST9:
	.4byte	.LVL18
	.4byte	.LVL19
	.2byte	0x1
	.byte	0x52
	.4byte	.LVL19
	.4byte	.LFE1883
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST10:
	.4byte	.LVL18
	.4byte	.LVL19
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST11:
	.4byte	.LVL18
	.4byte	.LVL20
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL20
	.4byte	.LVL23
	.2byte	0x3
	.byte	0x70
	.sleb128 -16
	.byte	0x9f
	.4byte	.LVL23
	.4byte	.LFE1883
	.2byte	0x1
	.byte	0x50
	.4byte	0
	.4byte	0
.LLST12:
	.4byte	.LVL18
	.4byte	.LVL21
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL21
	.4byte	.LVL23
	.2byte	0x3
	.byte	0x71
	.sleb128 -16
	.byte	0x9f
	.4byte	.LVL23
	.4byte	.LFE1883
	.2byte	0x1
	.byte	0x51
	.4byte	0
	.4byte	0
.LLST13:
	.4byte	.LVL19
	.4byte	.LVL20
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL20
	.4byte	.LFE1883
	.2byte	0x3
	.byte	0x70
	.sleb128 -16
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST14:
	.4byte	.LVL20
	.4byte	.LVL21
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL21
	.4byte	.LFE1883
	.2byte	0x3
	.byte	0x71
	.sleb128 -16
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST15:
	.4byte	.LVL21
	.4byte	.LVL22
	.2byte	0x8
	.byte	0x90
	.uleb128 0x30
	.byte	0x93
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x31
	.byte	0x93
	.uleb128 0x8
	.4byte	0
	.4byte	0
.LLST16:
	.4byte	.LVL22
	.4byte	.LVL23
	.2byte	0x1
	.byte	0x52
	.4byte	.LVL23
	.4byte	.LFE1883
	.2byte	0x3
	.byte	0x72
	.sleb128 -16
	.byte	0x9f
	.4byte	0
	.4byte	0
	.section	.debug_aranges,"",%progbits
	.4byte	0x34
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
	.4byte	.LFB1883
	.4byte	.LFE1883-.LFB1883
	.4byte	.LFB1884
	.4byte	.LFE1884-.LFB1884
	.4byte	0
	.4byte	0
	.section	.debug_ranges,"",%progbits
.Ldebug_ranges0:
	.4byte	.LFB11
	.4byte	.LFE11
	.4byte	.LFB12
	.4byte	.LFE12
	.4byte	.LFB1883
	.4byte	.LFE1883
	.4byte	.LFB1884
	.4byte	.LFE1884
	.4byte	0
	.4byte	0
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.section	.debug_str,"MS",%progbits,1
.LASF10:
	.ascii	"__off_t\000"
.LASF75:
	.ascii	"vst1q_u32\000"
.LASF16:
	.ascii	"_IO_read_ptr\000"
.LASF28:
	.ascii	"_chain\000"
.LASF8:
	.ascii	"size_t\000"
.LASF34:
	.ascii	"_shortbuf\000"
.LASF68:
	.ascii	"intrinsics\000"
.LASF55:
	.ascii	"__builtin_neon_hf\000"
.LASF51:
	.ascii	"__builtin_neon_hi\000"
.LASF22:
	.ascii	"_IO_buf_base\000"
.LASF65:
	.ascii	"vld1q_u32\000"
.LASF7:
	.ascii	"long long unsigned int\000"
.LASF59:
	.ascii	"__builtin_neon_uhi\000"
.LASF71:
	.ascii	"GNU C 4.8.3 20131202 (prerelease) -mcpu=cortex-a7 -"
	.ascii	"mno-unaligned-access -mfpu=neon -mfloat-abi=softfp "
	.ascii	"-mtls-dialect=gnu -g -O3 -ffunction-sections -fno-a"
	.ascii	"ggressive-loop-optimizations -ftree-vectorize -funs"
	.ascii	"afe-math-optimizations\000"
.LASF6:
	.ascii	"long long int\000"
.LASF4:
	.ascii	"signed char\000"
.LASF66:
	.ascii	"vaddq_u32\000"
.LASF29:
	.ascii	"_fileno\000"
.LASF17:
	.ascii	"_IO_read_end\000"
.LASF11:
	.ascii	"long int\000"
.LASF15:
	.ascii	"_flags\000"
.LASF23:
	.ascii	"_IO_buf_end\000"
.LASF32:
	.ascii	"_cur_column\000"
.LASF73:
	.ascii	"/home/jyhuh/setting/test_src/embedded/neon_test\000"
.LASF9:
	.ascii	"__quad_t\000"
.LASF67:
	.ascii	"NeonTest_add\000"
.LASF31:
	.ascii	"_old_offset\000"
.LASF36:
	.ascii	"_offset\000"
.LASF58:
	.ascii	"__builtin_neon_uqi\000"
.LASF45:
	.ascii	"_IO_marker\000"
.LASF69:
	.ascii	"stdin\000"
.LASF0:
	.ascii	"unsigned int\000"
.LASF3:
	.ascii	"long unsigned int\000"
.LASF20:
	.ascii	"_IO_write_ptr\000"
.LASF47:
	.ascii	"_sbuf\000"
.LASF2:
	.ascii	"short unsigned int\000"
.LASF24:
	.ascii	"_IO_save_base\000"
.LASF35:
	.ascii	"_lock\000"
.LASF30:
	.ascii	"_flags2\000"
.LASF42:
	.ascii	"_mode\000"
.LASF70:
	.ascii	"stdout\000"
.LASF57:
	.ascii	"__builtin_neon_poly16\000"
.LASF54:
	.ascii	"__builtin_neon_sf\000"
.LASF13:
	.ascii	"sizetype\000"
.LASF52:
	.ascii	"__builtin_neon_si\000"
.LASF53:
	.ascii	"__builtin_neon_di\000"
.LASF21:
	.ascii	"_IO_write_end\000"
.LASF60:
	.ascii	"__builtin_neon_usi\000"
.LASF74:
	.ascii	"_IO_lock_t\000"
.LASF44:
	.ascii	"_IO_FILE\000"
.LASF61:
	.ascii	"__builtin_neon_udi\000"
.LASF64:
	.ascii	"float\000"
.LASF48:
	.ascii	"_pos\000"
.LASF27:
	.ascii	"_markers\000"
.LASF1:
	.ascii	"unsigned char\000"
.LASF63:
	.ascii	"uint32x4_t\000"
.LASF5:
	.ascii	"short int\000"
.LASF76:
	.ascii	"NeonTest_mul\000"
.LASF33:
	.ascii	"_vtable_offset\000"
.LASF50:
	.ascii	"__builtin_neon_qi\000"
.LASF72:
	.ascii	"neon.c\000"
.LASF49:
	.ascii	"uint32_t\000"
.LASF14:
	.ascii	"char\000"
.LASF56:
	.ascii	"__builtin_neon_poly8\000"
.LASF46:
	.ascii	"_next\000"
.LASF12:
	.ascii	"__off64_t\000"
.LASF18:
	.ascii	"_IO_read_base\000"
.LASF26:
	.ascii	"_IO_save_end\000"
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
.LASF43:
	.ascii	"_unused2\000"
.LASF25:
	.ascii	"_IO_backup_base\000"
.LASF62:
	.ascii	"int32x4_t\000"
.LASF77:
	.ascii	"main\000"
.LASF19:
	.ascii	"_IO_write_base\000"
	.ident	"GCC: (Hisilicon_v400) 4.8.3 20131202 (prerelease)"
	.section	.note.GNU-stack,"",%progbits
