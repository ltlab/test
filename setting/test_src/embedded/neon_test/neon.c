/*
 * =====================================================================================
 *
 *       Filename:  neon.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2009년 12월 09일 20시 03분 57초
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jae-Yeong Huh
 *        Company:  Dongbu HiTek Co.,Ltd.
 *
 * =====================================================================================
 */
#include	<stdio.h>

#define	__NEON_MUL__

#define	MAX_SIZE				( 256 )

#ifdef __NEON__
	#define	VMAC( x, y, z )		vmac_neon( (x), (y), (z) )
#else	/*	__NEON__	*/
	#define	VMAC( x, y, z )		vmac_c( (x), (y), (z) )
#endif	/*	__NEON__	*/
	
void NeonTest_add(int * x, int * y, int * z)
{
	int i;
	for( i = 0 ; i < MAX_SIZE ; i++ )
	{
		z[i] = x[i] + y[i];
		//printf(" i= %d: x[=%d] + y[=%d] = z[=%d]\n", i, x[ i ], y[ i ], z[ i ] );
	}
}

void NeonTest_mul(float * __restrict a, float * __restrict b, float * __restrict c )
{
	int i;
	for( i = 0 ; i < MAX_SIZE ; i++ )
	{
		c[i] = a[i] * b[i];
		//printf(" i= %d: x[=%d] + y[=%d] = z[=%d]\n", i, x[ i ], y[ i ], z[ i ] );
	}
}
#ifdef	__NEON__
#include	<arm_neon.h>
void intrinsics(uint32_t *x, uint32_t *y, uint32_t *z)
{
	int i;
	uint32x4_t x4,y4; // These 128 bit registers will contain 4 values from the x array and 4 values from the y array
	uint32x4_t z4;    // This 128 bit register will contain the 4 results from the add intrinsic
	uint32_t *px = x; // pointer to the x array data
	uint32_t *py = y; // pointer to the y array data
	uint32_t *pz = z; // pointer to the z array data

	for( i = 0 ; i < ( MAX_SIZE / 4 ) ; i++ )
	{
		x4 = vld1q_u32(px);  // intrinsic to load x4 with 4 values from x
		y4 = vld1q_u32(py);  // intrinsic to load y4
		z4 = vaddq_u32(x4,y4);   // intrinsic to add z4=x4+y4
		vst1q_u32(pz, z4);   // store the 4 results to z
		//printf(" i= %d: x[=%d] + y[=%d] = z[=%d]\n", i, x[ i ], y[ i ], z[ i ] );
		px += 4; // increment pointers
		py += 4;
		pz += 4;
	}
}
#else
typedef	int		uint32_t;
#endif	/*	__NEON__	*/

int main( void )
{
	int i;

#ifdef	__NEON_MUL__
	float		a[ MAX_SIZE ], b[ MAX_SIZE ], c[ MAX_SIZE ];

	for( i = 0 ; i < MAX_SIZE ; i++ )
	{
		a[ i ] = i * .3;
		b[ i ] = i * .5;
	}
#else	/*	__NEON_MUL__	*/
	uint32_t	x[ MAX_SIZE ], y[ MAX_SIZE ], z[ MAX_SIZE ];

	for( i = 0 ; i < MAX_SIZE ; i++ )
	{
		x[ i ] = i * 3;
		y[ i ] = i * 5;
	}
#endif	/*	__NEON_MUL__	*/

	for( i = 0 ; i < 150000 ; i ++ )
	{
#ifdef	__NEON_MUL__
		NeonTest_mul( a, b, c );
#else	/*	__NEON_MUL__	*/

#ifdef	__NEON__
		intrinsics( x, y, z );
#else	/*	__NEON__	*/
		NeonTest_add( x, y, z );
#endif	/*	__NEON__	*/

#endif	/*	__NEON_MUL__	*/

	}
	for( i = 0 ; i < MAX_SIZE ; i++ )
	{
		//printf(" i= %d: x[=%d] + y[=%d] = z[=%d]\n", i, x[ i ], y[ i ], z[ i ] );
		//printf(" i= %d: a[=%f] * b[=%f] = c[=%f]\n", i, a[ i ], b[ i ], c[ i ] );
	}

	return 0;
}
