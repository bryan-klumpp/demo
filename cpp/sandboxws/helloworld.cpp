#include <iostream>
#include <vector>
#include <string>
#include <cassert>
#include "helloworld.h"

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

enum MyType { enum1 = 1<<1, enum2 =  1<<2, enum3 = 1<<3, LASTBASE = enum3, ALL = enum1 | enum2 | enum3 };
constexpr static bool enumtest(const MyType& ALL, const MyType& lastBase) {
    return ((ALL + 2) & (ALL + 1)) == 0 && ALL > lastBase;
}
static_assert( enumtest(MyType::ALL, MyType::LASTBASE) );
static_assert( ((MyType::ALL + 2) & (MyType::ALL + 1)) == 0 && MyType::ALL > MyType::LASTBASE );
static_assert_ALL;

void enumfun() {
// see the static_asserts, this is just for developing additional functionality
}

void playWithFunctionByConstPointer(const string* s) {
    cout << "stringSandbox: " << s << endl;
}
void playWithFunctionByConstReference(const string& s) {
    cout << "stringSandbox: " << s << endl;
}
string copyConstStringToNonConst(const string& s) {
    return s;
}
void functionThatTriesToChangeStringReference(string& s) {
    s = "something else";
}

class ClassThatIAmPassingToALambda{
    public:
    int i = 0;
    ClassThatIAmPassingToALambda(int p_i) : i(p_i) {}
};
void lambdafun() {
    ClassThatIAmPassingToALambda objectThatIAmPassingToALambda = { 5 }; 
    cout << "initial address:           " << &objectThatIAmPassingToALambda << endl;
    auto totallyLazyLambda = [&objectThatIAmPassingToALambda]() -> ClassThatIAmPassingToALambda&& { 
        objectThatIAmPassingToALambda.i = 6;
        cout << "address within the lambda: " << objectThatIAmPassingToALambda.i << " - " << &objectThatIAmPassingToALambda << endl; return std::move(objectThatIAmPassingToALambda); };
    auto&& totallyLazyLambdaReturned = totallyLazyLambda();
    cout << "did the initial address change?: " << objectThatIAmPassingToALambda.i << " - " << &objectThatIAmPassingToALambda << endl;
    cout << "totallyLazyLambdaReturned: " << objectThatIAmPassingToALambda.i << " - " << &totallyLazyLambdaReturned << endl;
    cout << "So as you can see above I was able to set an rvalue reference to the exact same address of the object that I passed to the lambda." << endl
         << "Now let's see what happens when I try to reassign the totallyLazyLambdaReturned to a completely different object." << endl;
    totallyLazyLambdaReturned = { 7 };
    cout << "objectThatIAmPassingToALambda: " << objectThatIAmPassingToALambda.i << " - " << &objectThatIAmPassingToALambda << endl
         << "I don't really understand why an rvalue reference is behaving like I expected an lvalue to behave, and is able to manipulate the original lvalue, but anyway I've done all this with a single memory address." << endl;
    // https://blog.vero.site/post/rvalue-references talks about how this is possible, how lvalues can be "smuggled" into rvalue references and how the differences between lvalues and rvalues are mainly in initialization, not in usage.
}

void functionThatTriesToChangeStringPointer(string* s) { //Probably not a great idea normally, but just playing with the language to maybe watch how things break
    string temps = "something else pointed to";
    s = &temps;
}
const void functionThatTriesHarderToChangeStringPointer(string** s) { //Probably not a great idea normally, but just playing with the language to maybe watch how things break
    string temps = "something else 2 pointed to";
    cout << temps << endl;
    cout << **s << endl;
    cout << *s << endl;
    cout << s << endl;
    *s = &temps;
}
void changethestring ( string ** thestring) //https://stackoverflow.com/questions/26590199/changing-a-string-pointer-in-c  (I realize this link is for C but trying in C++.  Probably bad idea but just playing with the language to watch how things break)
{
    string tempstring = "string two is longer";
    *thestring = &tempstring;
}
void pf1(string pref, string&& prefuniv) {
    cout << "pref: " << pref << endl;
    cout << "prefuniv: " << prefuniv << endl;
    cout << "&pref: " << &pref << endl;
    cout << "&prefuniv: " << &prefuniv << endl;
    pref = "temps";
    
}

void ampersandAsteriskFun() { //https://stackoverflow.com/questions/6877052/use-of-the-operator-in-c-function-signatures
    const string asdf = "asdf";
    pf1("pref1","prefuniv");
    //playWithFunction(*asdf);
    //playWithFunction(&asdf);
    string newasdf = "asdf";
    string tt = "Helloooooooo, wordl";
    string autos = "Hello, wordl";
    string copyofasdf = copyConstStringToNonConst(asdf);
    string* p = &copyofasdf; // Here you get an address of asdf
    playWithFunctionByConstPointer(p);
    playWithFunctionByConstReference(asdf);
    string* pp = &newasdf; // Here you get an address of asdf
    string* pnullptr = nullptr;
    cout << "eg1" << (p == nullptr) << endl;
    //cout << "eg1.5" << (*p == *pnullptr) << endl; //segfault
    cout << "eg2" << (asdf == newasdf) << endl;
    cout << "eg3" << (p == pp) << endl;
    cout << "eg3.5" << (*p == *pp) << endl;
    cout << "eg4" << (newasdf == tt) << endl;
    const string& r = copyofasdf; // Here, r is a reference to asdf  
    auto saddress = (string*)&asdf;
    string* rereferenced = saddress;
    auto divergentcopy = asdf;  
    auto autop = &copyofasdf;
    string& makereferencefrompointer = *&*&*&*&*&*&*&*&*&*&*&*&*p; // compiler abuse: this is to make a copy using a pointer
    string& makereferencefromautop = *&*&*&*&*&*&*&*&*&*&*&*&*autop; // compiler abuse: this is to make a copy using a pointer
    string makecopyfrompointer = *p; // this is to make a copy using a pointer

    copyofasdf = "Hello, world"; // corrected
    assert( copyofasdf == *p ); // this should be familiar to you, dereferencing a pointer
    assert( copyofasdf == r ); // this will always be true, they are twins, or the same thing rather

    string copy1 = *p; // this is to make a copy using a pointer
    string copy = r; // this is what you saw, hope now you understand it better.

    cout << "asdf: " << copyofasdf << endl;
    debugline(copyofasdf)
    debugline(autos)
    cout << "&asdf: " << &copyofasdf << endl;
    //debugline(#&asdf)
    cout << "*&asdf: " << *&copyofasdf << endl;
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
    functionThatTriesToChangeStringReference(copyofasdf);
    cout << copyofasdf << endl;
    string eees = "eeeeeeeeee";
    string* eee = &eees;
    functionThatTriesToChangeStringPointer(eee);
    cout << *eee << endl;
    functionThatTriesHarderToChangeStringPointer(&eee);
    cout << *eee << endl;  //front-truncated and seems to vary??
    string teststringl = "string one";
    string * teststring = &teststringl;
    changethestring(&teststring);
    cout << "teststring: " << *teststring << endl; // this seems like a bad idea after changing the pointer, no worky, probably unsafe pointer stuff

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

void rvaluefun() {
int x;
int&& y = std::move(x);
int&& z = 5;
z = 4;
y = 6;  // also sets x to 6
cout << y << x << z;
}

int main()
{
    lambdafun();
}
void allfun() {
    enumfun();
    rvaluefun();
    lambdafun();
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
    int (*func)(int, int) = multiply;
    auto functionPointer = multiply;
    cout << (*functionPointer)(2,9) << endl;
    decltype (functionPointer) declType1;
    debugline(declType1)
    //cout << "try to invoke declType1: "<<declType1(2,4)<<endl;  //infinite loop /segmentation fault?!
    cout<<"fp1invoke: "<<(*functionPointer)(2,9) << endl;
    cout<<"multiplyasterisk: "<<(*multiply)(2,9) << endl;
    vector<string> msg {"Hello", "C++", "World", "from", "VS Code Eclipse", "and the C++ extensionx!"};
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
