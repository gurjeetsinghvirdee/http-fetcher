import fetcher;
import std.stdio;

void main() {
    auto response = fetch("https://api.example.com/data", FetchOptions.init);
    writeln("Response: ", response);
}