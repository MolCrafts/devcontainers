#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "cmake on PATH"  cmake --version
check "ninja on PATH"  ninja --version
check "c++ compiler"   c++ --version
check "clangd"         clangd --version
check "clang-format"   clang-format --version
check "clang-tidy"     clang-tidy --version
check "ccache"         ccache --version
check "doxygen"        doxygen --version
check "graphviz (dot)" dot -V

# The entire reason this feature bypasses apt: molnex's build-system.requires
# says cmake>=4, and Ubuntu 24.04 ships 3.28.
check "cmake major >= 4" bash -c '[ "$(cmake --version | head -1 | awk "{print \$3}" | cut -d. -f1)" -ge 4 ]'

check "ninja is the default generator" bash -c '[ "${CMAKE_GENERATOR}" = "Ninja" ]'
# clangd needs compile_commands.json; exporting it by default saves every repo
# from repeating the flag.
check "compile commands exported"      bash -c '[ "${CMAKE_EXPORT_COMPILE_COMMANDS}" = "ON" ]'

# End-to-end: Atomiverse compiles at C++20, so prove the toolchain does too.
check "configures and builds C++20" bash -c '
  d=$(mktemp -d) && cd "$d" &&
  printf "cmake_minimum_required(VERSION 3.18)\nproject(probe LANGUAGES CXX)\nset(CMAKE_CXX_STANDARD 20)\nset(CMAKE_CXX_STANDARD_REQUIRED ON)\nadd_executable(probe main.cpp)\n" > CMakeLists.txt &&
  printf "#include <concepts>\ntemplate <std::integral T> T id(T v) { return v; }\nint main() { return id(0); }\n" > main.cpp &&
  cmake -S . -B build >/dev/null &&
  cmake --build build >/dev/null &&
  ./build/probe'

reportResults
