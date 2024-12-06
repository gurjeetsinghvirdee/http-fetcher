module fetcher;

import requests;

string fetch(string url) {
    auto response = get(url);

    if (response.statusCode == 200) {
        return response.text();
    } else {
        return "Failed to fetch data. Status code: " ~ response.statusCode.to!string;
    }
}