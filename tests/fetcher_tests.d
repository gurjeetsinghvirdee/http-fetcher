module fetcher_tests;

import fetcher;
import std.stdio;
import std.testing.unit;
import std.datetime;

unittest {
    FetchOptions options;
    options.headers = ["Content-Type": "application/json"];
    options.queryParams = ["key": "value"];
    options.body =  "";
    options.timeout = dur!("seconds"(10));
    
    AuthOptions auth;
    auth.apiKey = "your-api-key";

    string sampleResponse = fetch("https://api.example.com/data", options, auth);
    assert(sampleResponse.length > 0, "Response should not be empty");

    PerformanceMetrics metrics = fetchWithMetrics("https://api.example.com/data", options, auth);
    writeln("Request duration: ", metrics.requestDuration.toString());
}

void main() {
    import std.algorithm : canFind;
    import std.array : array;
    bool failed = false;

    static foreach (test; __traits(getUnitTests, __traits(parent, main))) {
        bool result;
        try {
            result = test();
        } catch (Exception e) {
            result = false;
            writeln("[FAILED] ", __traits(identifier, test), ": ", e.msg);
            failed = true;
        }
        if (result) {
            writeln("[PASSED] ", __traits(identifier, test));
        }
    }
    if (!failed) {
        writeln("All tests passed!");
    }
}
