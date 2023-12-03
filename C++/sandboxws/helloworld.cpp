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

void ampersandAsteriskFun() { //https://stackoverflow.com/questions/6877052/use-of-the-operator-in-c-function-signatures
        string s = "Hello, wordl";
        string autos = "Hello, wordl";
        string* p = &s; // Here you get an address of s
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


int main()
{
    vector<string> msg {"Hello", "C++", "World", "from", "VS Code", "and the C++ extensionx!"};

    for (const string& word : msg)
    {
        dumbmacro
        cout << '\a';
        
    }
    cout << endl;
    ampersandAsteriskFun();
}
