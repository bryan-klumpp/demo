#include <iostream>
#include <vector>
#include <string>
#include <cassert>

#define dumbmacro cout << word << " ";
#define debugline(varName) debugLine(#varName, varName);

using namespace std;

template <typename T> string getTypeName (T& obj) {
    return typeid(obj).name();
}

template <typename T> void debugLine(string name, T& obj) {
    cout << name << ": " << obj << " -- type: " << getTypeName(obj) << endl;
}

template <typename T> T bitwiseNOT(T i) {
    static_assert(std::is_unsigned<T>::value && std::is_integral<T>::value, "T must be unsigned integral type (integer, long, etc.)");
    return ~i;
}
void ampersandAsteriskFun() { //https://stackoverflow.com/questions/6877052/use-of-the-operator-in-c-function-signatures
        string s = "Hello, wordl";
        string ss = "Hello, wordl";
        string tt = "Helloooooooo, wordl";
        string autos = "Hello, wordl";
        string* p = &s; // Here you get an address of s
        string* pp = &ss; // Here you get an address of s
        string* pnullptr = nullptr;
        cout << "eg1" << (p == nullptr) << endl;
        //cout << "eg1.5" << (*p == *pnullptr) << endl; //segfault
        cout << "eg2" << (s == ss) << endl;
        cout << "eg3" << (p == pp) << endl;
        cout << "eg3.5" << (*p == *pp) << endl;
        cout << "eg4" << (ss == tt) << endl;
        string& r = s; // Here, r is a reference to s  
        auto saddress = (string*)&s;
        string* rereferenced = saddress;
        auto divergentcopy = s;  
        auto autop = &s;
        string& makereferencefrompointer = *&*&*&*&*&*&*&*&*&*&*&*&*p; // compiler abuse: this is to make a copy using a pointer
        string& makereferencefromautop = *&*&*&*&*&*&*&*&*&*&*&*&*autop; // compiler abuse: this is to make a copy using a pointer
        string makecopyfrompointer = *p; // this is to make a copy using a pointer

        s = "Hello, world"; // corrected
        assert( s == *p ); // this should be familiar to you, dereferencing a pointer
        assert( s == r ); // this will always be true, they are twins, or the same thing rather

        string copy1 = *p; // this is to make a copy using a pointer
        string copy = r; // this is what you saw, hope now you understand it better.

        cout << "s: " << s << endl;
        debugline(s)
        debugline(autos)
        cout << "&s: " << &s << endl;
        //debugline(#&s)
        cout << "*&s: " << *&s << endl;
        cout << "p: " << p << endl;
        debugline(p)
        debugline(autop)
        cout << "*p: " << *p << endl;
        cout << "saddress: " << saddress << endl;
        cout << "rereferenced: " << rereferenced << endl;
        cout << "divergentcopy: " << divergentcopy << endl;
        cout << "makereferencefrompointer: " << makereferencefrompointer << endl;
        debugLine ("makereferencefromautop", makereferencefromautop);
        debugline(makereferencefromautop)
        cout << "makecopyfrompointer: " << makecopyfrompointer << endl;
}

int multiply(int a, int b) { return a * b; }
int foo(int x)
{
    return x;
}
string MultiCopyMethod(string&& s);

string MultiCopyMethod10(string s) {return "sssssssssssssssssss";}
string MultiCopyMethod15(const string& s) {return "sssssssssssssssssss";} //seems like this needs to take const argument to allow accepting "a" type string literals

typedef decltype(&MultiCopyMethod) MultiCopyMethodDeclType;
typedef decltype(&MultiCopyMethod10) MultiCopyMethodDeclType10;
typedef decltype(&MultiCopyMethod15) MultiCopyMethodDeclType15;

string MultiCopyMethod2(string&& s) {return s+"ssssssssssssssssssss 222222222222222222222222 MultiCopyMethod2";}
string MultiCopyMethod12(string s) {return s+"ssssssssssssssssssss 222222222222222222222222 MultiCopyMethod12";}
string MultiCopyMethod16(const string& s) {return s+"ssssssssssssssssssss 222222222222222222222222 MultiCopyMethod16";}


int main()
{
    MultiCopyMethodDeclType mcmt = MultiCopyMethod2;
    mcmt = &MultiCopyMethod2;  //& is optional
    string a = "aa";
    const MultiCopyMethodDeclType mcmtconst = mcmt; //& no worky here
    const MultiCopyMethodDeclType10 mcmtconst10 = MultiCopyMethod12; //& no worky here
    const MultiCopyMethodDeclType15 mcmtconst16 = MultiCopyMethod16; //& no worky here
    //cout << mcmtconst(a) << endl; //will not accept lvalue
    cout << mcmtconst("aa") << endl;
    cout << mcmtconst10(a) << endl;
    cout << mcmtconst10("aa") << endl;
    cout << mcmtconst16(a) << endl;
    cout << mcmtconst16(static_cast<basic_string<char>>("a")) << endl;
    cout << mcmtconst16(static_cast<string>("aa")) << endl;
    cout << mcmtconst16("aa") << endl;
    //cout << MultiCopyMethod("a") << endl;

    int (*fcnPtr)(int){ &foo }; // Initialize fcnPtr with function foo
    cout << (*fcnPtr)(5) << endl; // call function foo(5) through fcnPtr.
    //int (*func)(int, int);
     // func is pointing to the multiplyTwoValues function
    //func = multiply;
    //int prod = func(15, 2);
    //cout << "The value of the product is: " << prod << endl;

    //decltype 
    int (*func)(int, int) = multiply ;
    auto functionPointer = multiply;
    cout << (*functionPointer)(2,9) << endl;
    decltype (functionPointer) declType1;
    debugline(declType1)
    //cout << "try to invoke declType1: "<<declType1(2,4)<<endl;  //infinite loop /segmentation fault?!
    cout<<"fp1invoke: "<<(*functionPointer)(2,9) << endl;
    cout<<"multiplyasterisk: "<<(*multiply)(2,9) << endl;
    vector<string> msg {"Hello", "C++", "World", "from", "VS Code", "and the C++ extensionx!"};
    cout << bitwiseNOT(1ul) << endl;
    cout << bitwiseNOT(1u) << endl;
    cout << bitwiseNOT((unsigned short)1) << endl;
    cout << (int)(bitwiseNOT((unsigned char)1)) << endl;
    for (const string& word : msg)
    {
        dumbmacro
        cout << '\a';
        
    }
    cout << endl;
    ampersandAsteriskFun();
}
