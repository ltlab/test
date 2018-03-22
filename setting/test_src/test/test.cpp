
#include	<stdio.h>

class BASE
{
private:
protected:
public:
	BASE() {};
	virtual ~BASE() {};

	virtual void pureVFunc( void ) = 0;
	virtual void VFunc( void );

	void Func( void );
};

#if 0
void BASE::pureVFunc( void )
{
	printf( "%s\n", __PRETTY_FUNCTION__ );
}
#endif

void BASE::VFunc( void )
{
	printf( "%s\n", __PRETTY_FUNCTION__ );
}

void BASE::Func( void )
{
	printf( "%s\n", __PRETTY_FUNCTION__ );
}

class TEST : public BASE
{
private:
protected:
public:
	TEST() {};
	virtual ~TEST() {};

	void pureVFunc( void );
	void VFunc( void );
	void Func( void );
};

void TEST::pureVFunc( void )
{
	BASE::pureVFunc( );
	printf( "%s\n", __PRETTY_FUNCTION__ );
}

void TEST::VFunc( void )
{
	BASE::VFunc( );
	printf( "%s\n", __PRETTY_FUNCTION__ );
}

void TEST::Func( void )
{
	BASE::Func( );
	printf( "%s\n", __PRETTY_FUNCTION__ );
}

int main( void )
{
	TEST	test;

	test.pureVFunc();
	test.VFunc();
	test.Func();

	printf( "\n Call Methods as Base Class-------------\n");
	dynamic_cast< BASE * >( & test )->pureVFunc( );
	dynamic_cast< BASE * >( & test )->VFunc( );
	dynamic_cast< BASE * >( & test )->Func( );

	return 0;
}
