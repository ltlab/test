
/*
 *	Comment	ctermfg=darkcyan
 */

#include <stdio.h>		//	#include: PreProc:	blue,	stdio.h: cIncluded:	red

#if 1	//	PreCondit:	cyan
	#define	TEST	1	//	cDefine => Macro => PreProc
	#define	T_TEST(xxx)	(xxx)+1
#endif

typedef	unsigned char	byte;
struct	t_struct		//	typedef, struct:	cStructure => Structure:	lightgreen
{
	byte	test;
	int		num;
}

int a( void )
{
	printf("test\n");
	return 0;
}

int main()	//	int:	cType => Type:	green
{
	unsigned int	a, i;
	unsigned int	*pA, *pB, *pC;	//	cCommentL => Comment

	/*	%p, \n:	cSpecial=>SpecialChar:	red
	 *	sizeof:	cOperator => Operator:	red
	 */
	printf("a = (%p), sizeof(%d) \n", &a, sizeof(a) );
	printf("pA = (%p), %p \n", pA, &pA );
	printf("pB = (%p), %p \n", pB, &pB );
	printf("pC = (%p), %p \n", pC, &pC );
	
	pA = &a;
	pB = pA;
	pC = pB;
	for( i = 0 ; i < 5 ; i++ )	//	for, while, do:	cRepeat => Repeat:	yellow
	{
		a = i;
		printf("==================================================\n");
		printf("a = %d(%p) \n", a, &a );
		printf("pA = %d(%p), %p \n", *pA, pA, &pA );
		printf("pB = %d(%p), %p \n", *pB, pB, &pB );
		printf("pC = %d(%p), %p \n", *pC, pC, &pC );
	}
	return 0;

	switch( a )				//	switch, if, else:	cConditional => Conditional:	yellow
	{
		case	1:			//	case:	cLabel => Label:	brown
			return false;	//	false, true:	Boolean(c_C99), cConstant
		default	:			//	default:	cUserLabel => Label
			break;			//	break, return:	cStatement:	lightyellow
	}

}

