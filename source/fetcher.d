module fetcher;

import requests;
import std.datetime;
import std.stdio;

struct FetchOptions {
    string[string] headers;
    string[string] queryParams;
    string body;
    Duration timeout;
}

struct AuthOptions {
    string apiKey;
    string username;
    string password;
}

struct PerformanceMetrics {
    Duration requestDuration;
}

void log(string message) {
    writeln("[LOG]: ", message);
}

string fetch(string url, FetchOptions options, AuthOptions auth = AuthOptions.init, int retryCount = 3) {
    auto client = HTTP();
    client.addRequestHeader("Authorization", "Bearer " ~ auth.apiKey);
    clinet.addRequestHeader("Content-Type", "application/json");

    foreach (key, value; options.headers) {
        client.addRequestHeader(key, value);
    }

    foreach (key, value; options.queryParams) {
        client.addQueryParameter(key, value);
    }

    auto response = client.get(url);

    if (response.code == 200) {
        log("Recieved successful response");
        return response.responseBody;
    } else {
        return "Error: Recieved status code " ~ response.code.to!string;
    }
}

Task!string asyncFetch(string url, FetchOptions options, AuthOptions auth = AuthOptions.init) {
    return task!string({
        return fetch(url, options, auth);
    });
}

string parseJson(string response) {
    try {
        auto json = parseJSON(response);
        return json.toString();
    } catch (Exception e) {
        log("Error parsing JSON: " ~ e.msg);
        return "";
    }
}

PerformanceMetrics fetchWithMetrics(string url, FetchOptions options, AuthOptions auth = AuthOptions.init) {
    auto start = Clock.currTime();
    string response = fetch(url, options, auth);
    auto end = Clock.currTime();
    Duration duration = end - start;

    return PerformanceMetrics(duration);
}