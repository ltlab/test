#include <iostream>
 
using namespace std;
void func1() { throw 0; }
void func2() { func1(); }
void func3() { func2(); }
void func4() { func3(); }

int main()
{
    int a, b;
 
    cout << "Enter two bumbers: ";
    cin >> a >> b;
 
    try {
        if (b == 0) throw b;
        cout << a << " / " << b << " = " << a/b << endl;
    } catch ( int e ) {
		//cout << "what: " << e.what() << endl;
        cout << "[ Exception ] devide by " << b << endl;
    }

	try {
        func4();
    } catch (int e) {
        cout << "Exception: " << e << "!" << endl;
    }
    return 0;
}