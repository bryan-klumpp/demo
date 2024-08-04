cmake_minimum_required(VERSION 3.5.0)
project(BasicProject VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(BasicProject helloworld.cpp)

include(CTest)
enable_testing()

