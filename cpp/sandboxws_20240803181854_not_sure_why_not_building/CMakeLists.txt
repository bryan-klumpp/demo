cmake_minimum_required(VERSION 3.5.0)
project(BasicProject VERSION 0.1.0 LANGUAGES C CXX)

add_executable(BasicProject helloworld.cpp)

include(CTest)
enable_testing()

