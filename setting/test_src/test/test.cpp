
#include	<stdio.h>

struct STRUCT
{
	int first_in_struct;
private:
protected:
public:
	STRUCT() {};
	//virtual ~STRUCT() {};
	~STRUCT() {};
};

class NO_V
{
public:
	int first_in_nov;
private:
protected:
public:
	NO_V() { first_in_nov = 100; };
	//virtual ~STRUCT() {};
	~NO_V() {};

	void print()
	{
		printf( "NO_V: this(%p), first_in_nov: %d @ %p\n", this, first_in_nov++, &first_in_nov );
		return;
	}
};

class NO_V_1 : public NO_V
{
public:
	int first_in_nov1;
private:
protected:
public:
	NO_V_1() { first_in_nov1 = 200; };
	virtual ~NO_V_1() {};
	void print()
	{
		printf( "NO_V_1: this(%p), first_in_nov: %d @ %p\n", this, first_in_nov++, &first_in_nov );
		NO_V::print();
		return;
	}
};

class BASE
{
public:
	int first_in_base;
private:
protected:
public:
	BASE() {};
	virtual ~BASE() {};

	virtual void pureVFunc( void ) = 0;
	virtual void VFunc( void );

	void Func( void );
};

#if 1
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
public:
	int first_in_test;
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
	STRUCT	struct_test;
	NO_V_1	no_v;

	test.pureVFunc();
	test.VFunc();
	test.Func();

	printf( "\n Call Methods as Base Class-------------\n");
	dynamic_cast< BASE * >( & test )->pureVFunc( );
	dynamic_cast< BASE * >( & test )->VFunc( );
	dynamic_cast< BASE * >( & test )->Func( );

	printf( "&base: %p first: %p\n", (void *)dynamic_cast< BASE * >( & test ), (void *)&( ( dynamic_cast< BASE * >( & test ) )->first_in_base ) );
	printf( "&test: %p first: %p\n", (void *)( & test ), (void *)( &( test.first_in_test ) ) );
	printf( "&struct_test: %p first: %p\n", (void *)( & struct_test ), (void *)( &( struct_test.first_in_struct ) ) );

	dynamic_cast< NO_V * >( & no_v )->print();
	printf( "&NO_V: %p first: %p\n", (void *)dynamic_cast< NO_V * >( & no_v ), (void *)&( ( dynamic_cast< NO_V * >( & no_v ) )->first_in_nov ) );
	no_v.print();
	printf( "&NO_V_1: %p first_in_nov1: %p first_in_nov: %p\n", (void *)( & no_v ), (void *)( &( no_v.first_in_nov1) ), (void *)( &( no_v.first_in_nov) ) );
	return 0;
}
