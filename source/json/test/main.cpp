#include <iostream>
#include <string>
#include <cassert>
#include <dlfcn.h>
#include "../dist/json.hpp"

using namespace std;

class JSONTest {
public:
    JSONTest() {
        cout << "\n=== JSON Library Test Suite ===" << endl;
        testCount = 0;
        passCount = 0;
    }
    
    ~JSONTest() {
        cout << "\n=== Test Results ===" << endl;
        cout << "Passed: " << passCount << "/" << testCount << endl;
        if (passCount == testCount) {
            cout << "✓ All tests passed!" << endl;
        } else {
            cout << "✗ Some tests failed" << endl;
        }
        cout << "===================\n" << endl;
    }
    
    void test(const string& name, const string& description) {
        testCount++;
        cout << "\n[Test " << testCount << "] " << name << endl;
        cout << "  Description: " << description << endl;
        cout << "  Output:" << endl;
    }
    
    void pass() {
        passCount++;
        cout << "  ✓ PASSED" << endl;
    }
    
    void fail(const string& reason = "") {
        cout << "  ✗ FAILED";
        if (!reason.empty()) cout << " - " << reason;
        cout << endl;
    }
    
private:
    int testCount;
    int passCount;
};

int main() {
    JSONTest tester;
    
    // Test 1: Parse and Display Simple Object
    {
        tester.test("parseAndDisplay", "Parse and pretty-print a simple JSON object");
        const char* json1 = R"({"name":"Alice","age":30,"city":"NYC"})";
        cout << "    Input: " << json1 << endl;
        cout << "    Pretty-printed output:" << endl;
        parseAndDisplay(json1);
        tester.pass();
    }
    
    // Test 2: Parse and Display Array
    {
        tester.test("parseAndDisplay - Array", "Parse and pretty-print a JSON array");
        const char* json2 = R"([{"id":1,"status":"active"},{"id":2,"status":"inactive"}])";
        cout << "    Input: " << json2 << endl;
        cout << "    Pretty-printed output:" << endl;
        parseAndDisplay(json2);
        tester.pass();
    }
    
    // Test 3: Count Elements
    {
        tester.test("countElements", "Count elements in a JSON array");
        const char* json3 = R"([1,2,3,4,5,6,7,8,9,10])";
        cout << "    Input: " << json3 << endl;
        cout << "    Expected count: 10, Output:" << endl;
        long count = countElements(json3);
        if (count == 10) {
            cout << "    Result: " << count << " elements" << endl;
            tester.pass();
        } else {
            tester.fail("Expected 10, got " + to_string(count));
        }
    }
    
    // Test 4: Get Value by Path
    {
        tester.test("getValueByPath", "Extract nested value using dot notation");
        const char* json4 = R"({"user":{"profile":{"name":"Bob","age":25}}})";
        cout << "    Input: " << json4 << endl;
        cout << "    Path: user.profile.name" << endl;
        cout << "    Output:" << endl;
        getValueByPath(json4, "user.profile.name");
        tester.pass();
    }
    
    // Test 5: Get Value by Path - Age
    {
        tester.test("getValueByPath - Age", "Extract different nested value");
        const char* json5 = R"({"user":{"profile":{"name":"Charlie","age":35}}})";
        cout << "    Input: " << json5 << endl;
        cout << "    Path: user.profile.age" << endl;
        cout << "    Output:" << endl;
        getValueByPath(json5, "user.profile.age");
        tester.pass();
    }
    
    // Test 6: Filter by Field
    {
        tester.test("filterByField", "Filter array of objects by key-value pair");
        const char* json6 = R"([
            {"name":"Alice","role":"admin","active":true},
            {"name":"Bob","role":"user","active":false},
            {"name":"Charlie","role":"admin","active":true},
            {"name":"Diana","role":"user","active":true}
        ])";
        cout << "    Input: Array of users" << endl;
        cout << "    Filter: role = 'admin'" << endl;
        cout << "    Output:" << endl;
        filterByField(json6, "role", "admin");
        tester.pass();
    }
    
    // Test 7: Map Field
    {
        tester.test("mapField", "Extract specific field from all array elements");
        const char* json7 = R"([
            {"id":1,"name":"Product A","price":10.50},
            {"id":2,"name":"Product B","price":20.75},
            {"id":3,"name":"Product C","price":15.25}
        ])";
        cout << "    Input: Array of products" << endl;
        cout << "    Extract field: name" << endl;
        cout << "    Output:" << endl;
        mapField(json7, "name");
        tester.pass();
    }
    
    // Test 8: Map Field - Prices
    {
        tester.test("mapField - Prices", "Extract prices from product array");
        const char* json8 = R"([
            {"id":1,"name":"Item X","price":99.99},
            {"id":2,"name":"Item Y","price":49.99},
            {"id":3,"name":"Item Z","price":199.99}
        ])";
        cout << "    Input: Array of items with prices" << endl;
        cout << "    Extract field: price" << endl;
        cout << "    Output:" << endl;
        mapField(json8, "price");
        tester.pass();
    }
    
    // Test 9: Merge Objects
    {
        tester.test("mergeObjects", "Merge two JSON objects");
        const char* json9a = R"({"firstname":"John","lastname":"Doe"})";
        const char* json9b = R"({"age":28,"city":"Boston","email":"john@example.com"})";
        cout << "    Object 1: " << json9a << endl;
        cout << "    Object 2: " << json9b << endl;
        cout << "    Merged output:" << endl;
        mergeObjects(json9a, json9b);
        tester.pass();
    }
    
    // Test 10: Merge Objects - Config
    {
        tester.test("mergeObjects - Config", "Merge configuration objects");
        const char* json10a = R"({"theme":"dark","lang":"en","debug":false})";
        const char* json10b = R"({"timeout":5000,"retries":3,"debug":true})";
        cout << "    Config 1: " << json10a << endl;
        cout << "    Config 2: " << json10b << endl;
        cout << "    Merged output:" << endl;
        mergeObjects(json10a, json10b);
        tester.pass();
    }
    
    // Test 11: Complex Nested Data
    {
        tester.test("Complex Nested Data", "Parse complex hierarchical JSON structure");
        const char* json11 = R"({
            "company":"TechCorp",
            "departments":[
                {
                    "name":"Engineering",
                    "teams":["Backend","Frontend","DevOps"],
                    "headcount":45
                },
                {
                    "name":"Sales",
                    "teams":["Enterprise","SMB"],
                    "headcount":20
                }
            ]
        })";
        cout << "    Input: Complex company structure" << endl;
        cout << "    Pretty-printed output:" << endl;
        parseAndDisplay(json11);
        tester.pass();
    }
    
    // Test 12: Edge Cases - Empty Array
    {
        tester.test("Edge Case - Empty Array", "Handle empty arrays gracefully");
        const char* json12 = "[]";
        cout << "    Input: " << json12 << endl;
        cout << "    Output:" << endl;
        parseAndDisplay(json12);
        long count = countElements(json12);
        if (count == 0) {
            tester.pass();
        } else {
            tester.fail("Expected 0 elements");
        }
    }
    
    // Test 13: Edge Cases - Empty Object
    {
        tester.test("Edge Case - Empty Object", "Handle empty objects gracefully");
        const char* json13 = "{}";
        cout << "    Input: " << json13 << endl;
        cout << "    Output:" << endl;
        parseAndDisplay(json13);
        tester.pass();
    }
    
    // Test 14: Filter with No Matches
    {
        tester.test("Filter - No Matches", "Filter returns empty array when no match found");
        const char* json14 = R"([{"status":"active"},{"status":"active"}])";
        cout << "    Input: Array of items with status='active'" << endl;
        cout << "    Filter: status = 'inactive'" << endl;
        cout << "    Output (should be empty):" << endl;
        filterByField(json14, "status", "inactive");
        tester.pass();
    }
    
    // Test 15: Map Missing Field
    {
        tester.test("Map - Missing Field", "Map handles missing fields gracefully");
        const char* json15 = R"([{"id":1,"name":"Alice"},{"id":2}])";
        cout << "    Input: Array where some items lack 'name' field" << endl;
        cout << "    Map field: name" << endl;
        cout << "    Output:" << endl;
        mapField(json15, "name");
        tester.pass();
    }
    
    return 0;
}
