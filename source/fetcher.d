import vibe.http.client : HTTPClient;
import vibe.http.common : HTTPMethod;
import vibe.core.stream : InputStream;
import std.array : appender, Appender;
import std.utf : validate;
import std.stdio : writeln;

struct FetchOptions {
    string[string] headers;      // Optional headers
    string[string] queryParams; // Optional query parameters
}

struct AuthOptions {
    string apiKey; // Optional API key for authorization
}

/// Fetches data from a URL synchronously.
string fetch(string url, FetchOptions options, AuthOptions auth = AuthOptions.init) {
    auto client = new HTTPClient();
    auto responseBody = appender!string();

    // Perform the HTTP request
    client.request(url, (scope req) {
        req.method = HTTPMethod.GET;
        req.headers["Content-Type"] = "application/json";

        // Add authorization if provided
        if (auth.apiKey.length > 0) {
            req.headers["Authorization"] = "Bearer " ~ auth.apiKey;
        }

        // Add additional headers
        foreach (key, value; options.headers) {
            req.headers[key] = value;
        }
    }, (scope res) {
        // Read the response body
        auto bodyReader = res.bodyReader;
        ubyte[] buffer = new ubyte[1024];
        while (!bodyReader.empty) {
            auto bytesRead = bodyReader.read(buffer);
            responseBody.put(cast(string) buffer[0 .. bytesRead]);
        }
    });

    return responseBody.data.validate; // Return as a validated UTF-8 string
}

/// Fetches data from a URL asynchronously.
void asyncFetch(string url, FetchOptions options, AuthOptions auth = AuthOptions.init) {
    import core.thread;
    auto thread = new Thread({
        auto response = fetch(url, options, auth);
        writeln("Response: ", response);
    });
    thread.start();
}

/// Main function to demonstrate usage.
void main() {
    FetchOptions options;
    options.headers["Accept"] = "application/json";

    AuthOptions auth;
    auth.apiKey = "your-api-key";

    asyncFetch("https://api.example.com/endpoint", options, auth);
}
