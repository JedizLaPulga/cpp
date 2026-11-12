# JSON Manipulation Library

Beautiful Phobos-powered JSON manipulation for Linux users with stdout-piping in mind.

## Features

This library uses D's **Phobos** standard library for elegant JSON handling with **beautiful formatted output**. All operations output formatted JSON directly to stdout, perfect for Unix piping workflows.

### Available Functions

#### `parseAndDisplay(const char* jsonStr)`
Parse and pretty-print JSON to stdout.

**Example:**
```c
parseAndDisplay("{\"name\": \"Alice\", \"age\": 30}");
```
**Output:**
```json
{
  "name": "Alice",
  "age": 30
}
```

#### `countElements(const char* jsonStr) -> long`
Count elements in a JSON array with output.

**Example:**
```c
long count = countElements("[1, 2, 3, 4, 5]");
```
**Output:**
```
Array has 5 elements
```

#### `getValueByPath(const char* jsonStr, const char* keyPath) -> const char*`
Extract values using dot-separated key paths.

**Example:**
```c
getValueByPath("{\"user\": {\"profile\": {\"name\": \"Bob\"}}}", "user.profile.name");
```
**Output:**
```json
"Bob"
```

#### `filterByField(const char* jsonStr, const char* fieldName, const char* fieldValue) -> const char*`
Filter array of objects by key-value pair with formatted output.

**Example:**
```c
const char* data = R"([
  {"name": "Alice", "role": "admin"},
  {"name": "Bob", "role": "user"},
  {"name": "Charlie", "role": "admin"}
])";

filterByField(data, "role", "admin");
```
**Output:**
```json
[
  {
    "name": "Alice",
    "role": "admin"
  },
  {
    "name": "Charlie",
    "role": "admin"
  }
]
```

#### `mapField(const char* jsonStr, const char* fieldName) -> const char*`
Extract specific field from all array elements with formatted output.

**Example:**
```c
mapField(R"([{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}])", "name");
```
**Output:**
```json
[
  "Alice",
  "Bob"
]
```

#### `mergeObjects(const char* json1, const char* json2) -> const char*`
Merge two JSON objects with formatted output.

**Example:**
```c
mergeObjects("{\"a\": 1}", "{\"b\": 2}");
```
**Output:**
```json
{
  "a": 1,
  "b": 2
}
```

## Build

```bash
cd /home/hp/Documents/github/cpp/source/json
./build.sh
```

Generates:
- `dist/libjson.so` - Shared library for Linux
- `dist/json.hpp` - C++ header with function declarations

## Philosophy

- **No file I/O** - Output to stdout for Unix piping chains
- **Beautiful formatting** - Pretty-printed JSON with proper indentation
- **Phobos power** - Leverages D's excellent standard library
- **C++ compatible** - Easily integrated into C/C++ projects
- **Linux-ready** - `.so` shared library for immediate use

## Usage with Piping

```bash
# Save parsed JSON to file via piping
./your_program | my_json_lib parseAndDisplay '{"data": [...]}' > output.json

# Chain multiple operations
cat input.json | extract_data | my_json_lib filterByField "status" "active" > filtered.json
```

## Structure

```
json/
├── source/
│   └── arr.d              # D module with Phobos JSON logic
├── dist/
│   ├── libjson.so         # Compiled shared library
│   ├── libjson.o          # Object file
│   └── json.hpp           # C++ header
├── dub.json               # D package configuration
└── build.sh               # Build script
```

## Phobos Features Used

- `std.json` - Parsing and manipulation
- `std.array` - String building and appending
- `std.format` - Formatted output
- `std.stdio` - Standard output operations
