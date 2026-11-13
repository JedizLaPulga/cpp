# JSON D/C++ Interop Library

Small JSON wrapper implemented in D (Phobos) with a C++-friendly API.

## Current API

The public C++ API is exposed through `JsonHandle` in [`build/include/json.hpp`](build/include/json.hpp):

- `void parse(const char* jsonStr)`
- `const char* stringify()`
- `int64_t getLength()`

`JsonHandle` uses RAII in C++ by calling `jsonInit/jsonDestroy` in constructor/destructor.

## Build

From project root:

```bash
./scripts/build.sh
```

Artifacts:
- `build/libjson.so` - shared library
- `build/generated/json_ffi.hpp` - generated low-level header from ldc2

## Run tests

```bash
./tests/build_and_run.sh
```

## Project structure

``` 
json/
├── build/
│   ├── generated/
│   │   └── json_ffi.hpp      # Generated low-level FFI header
│   ├── include/
│   │   └── json.hpp          # Public C++ API wrapper
│   └── libjson.so
├── docs/                     # Architecture and refactoring notes
├── scripts/
│   └── build.sh              # Build script (ldc2)
├── source/
│   └── json.d                # D implementation
├── tests/
│   ├── build_and_run.sh      # Test build/runner
│   └── main.cpp              # C++ integration tests
└── dub.json
```
