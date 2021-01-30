# Fundamentals

A small library that abstracts away the fundamentals of any Swift application such as:

- Asynchronous workloads using `DispatcheQueue`
- HTTP networking for JSON-based APIs using `URLSession`
- Dependency Injection
- Logging for debugging
- Persistence using `NSUserDefaults`
- Encoding / Decoding using `Codable`

# Installation

The following commands work for macOS.

```bash
$ git clone https://github.com/jabaridash/fundamentals.git
$ cd fundamentals
$ swift package update
$ swift package generate-xcodeproj
$ xed .
```
