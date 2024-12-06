module tests.fetcher_tests;

import fetcher;
import std.stdio;
import std.testing.unit;

// Sample unit test for the fetcher
unittest {
    string sampleResponse = fetch("https://api.example.com/data");
    assert(sampleResponse.length > 0, "Response should not be empty");
}

void main() {
    // Run the unit tests
    import std.algorithm : canFind;
    import std.array : array;
    bool failed = false;

    static foreach (test; __traits(getUnitTests, __traits(parent, main)))
    {
        bool result;
        try {
            result = test();
        }
        catch (Throwable e) {
            result = false;
            writeln("[FAILED] ", __traits(identifier, test), ": ", e.msg);
        }
        if (result) {
            writeln("[PASSED] ", __traits(identifier, test));
        }
    }
    if (failed) {
        writeln("All tests passed");
    }
}