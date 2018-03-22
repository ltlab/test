#include <stdio.h>
#include <stddef.h>
int main(void)
{
	struct foo {
		char c;
		int x;
	} __attribute__((packed));

	struct foo1 {
		char c;
		int x;
	} __attribute__((aligned( 16 )));

	struct  __attribute__((__packed__)) my_struct {
		char c;
		int i;
	};

	struct my_struct a = {'a', 123};
	struct my_struct *b = &a;
	int c = a.i;
	int d = b->i;
	int *e __attribute__((aligned(1))) = &a.i;
	int *f = &a.i;

	printf("sizeof(my_struct a)      = %d\n", (int)sizeof(struct my_struct));
	printf("offsetof(struct my_struct, c) = %d\n", (int)offsetof(struct my_struct, c));
	printf("offsetof(struct my_struct, i) = %d\n", (int)offsetof(struct my_struct, i));
	printf("c = %d\n", c);
	printf("d = %d\n", d);
	printf("addr(e = (aligned(1) &a.i) = %p\n", (void*)e);
	printf("addr(f = &a.i ) = %p\n", (void*)f);
	printf("*e = %d\n", *e);
	printf("*f = %d\n", *f);

	struct foo arr[2] = { { 'a', 10 }, {'b', 20 } };
	int *p0 = &arr[0].x;
	int *p1 = &arr[1].x;

	printf("sizeof(struct foo1      = %d\n", (int)sizeof(struct foo1));
	printf("sizeof(struct foo)      = %d\n", (int)sizeof(struct foo));
	printf("offsetof(struct foo, c) = %d\n", (int)offsetof(struct foo, c));
	printf("offsetof(struct foo, x) = %d\n", (int)offsetof(struct foo, x));
	printf("arr[0].x = %d\n", arr[0].x);
	printf("arr[1].x = %d\n", arr[1].x);
	printf("p0 = %p\n", (void*)p0);
	printf("p1 = %p\n", (void*)p1);
	printf("*p0 = %d\n", *p0);
	printf("*p1 = %d\n", *p1);
	return 0;
}
