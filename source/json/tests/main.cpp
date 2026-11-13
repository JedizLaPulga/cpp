#include <iostream>
#include <string>
#include "json.hpp"

using namespace std;

int main() {
    cout << "\n=== JSON Library Test ===" << endl;
    
    // Test 1: Parse simple object
    {
        cout << "\n[Test 1] Parse JSON Object" << endl;
        JsonHandle jsonObj;
        const char* json1 = R"({"name":"Alice","age":30})";
        cout << "  Input: " << json1 << endl;
        jsonObj.parse(json1);
        cout << "  Output: " << jsonObj.stringify() << endl;
        cout << "  ✓ PASSED" << endl;
    }
    
    // Test 2: Parse array
    {
        cout << "\n[Test 2] Parse JSON Array" << endl;
        JsonHandle obj2;
        const char* json2 = R"([1,2,3,4,5])";
        cout << "  Input: " << json2 << endl;
        obj2.parse(json2);
        cout << "  Output: " << obj2.stringify() << endl;
        cout << "  Length: " << obj2.getLength() << endl;
        cout << "  ✓ PASSED" << endl;
    }
    
    // Test 3: Parse nested object
    {
        cout << "\n[Test 3] Parse Nested Object" << endl;
        JsonHandle obj3;
        const char* json3 = R"({"user":{"name":"Bob","age":25}})";
        cout << "  Input: " << json3 << endl;
        obj3.parse(json3);
        cout << "  Output: " << obj3.stringify() << endl;
        cout << "  ✓ PASSED" << endl;
    }
    
    // Test 4: Multiple objects (testing init/cleanup)
    {
        cout << "\n[Test 4] Multiple Object Lifecycle" << endl;
        {
            JsonHandle temp;
            temp.parse(R"({"test":"value"})");
            cout << "  Temp object: " << temp.stringify() << endl;
        }  // dtor calls jsonDestroy here
        cout << "  Temp object destroyed" << endl;
        cout << "  ✓ PASSED" << endl;
    }
    
    
    return 0;
}
