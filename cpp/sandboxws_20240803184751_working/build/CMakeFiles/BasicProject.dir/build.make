# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /l/8/code/github_demo/C++/sandboxws

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /l/8/code/github_demo/C++/sandboxws/build

# Include any dependencies generated for this target.
include CMakeFiles/BasicProject.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/BasicProject.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/BasicProject.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/BasicProject.dir/flags.make

CMakeFiles/BasicProject.dir/helloworld.cpp.o: CMakeFiles/BasicProject.dir/flags.make
CMakeFiles/BasicProject.dir/helloworld.cpp.o: ../helloworld.cpp
CMakeFiles/BasicProject.dir/helloworld.cpp.o: CMakeFiles/BasicProject.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/l/8/code/github_demo/C++/sandboxws/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/BasicProject.dir/helloworld.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/BasicProject.dir/helloworld.cpp.o -MF CMakeFiles/BasicProject.dir/helloworld.cpp.o.d -o CMakeFiles/BasicProject.dir/helloworld.cpp.o -c /l/8/code/github_demo/C++/sandboxws/helloworld.cpp

CMakeFiles/BasicProject.dir/helloworld.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/BasicProject.dir/helloworld.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /l/8/code/github_demo/C++/sandboxws/helloworld.cpp > CMakeFiles/BasicProject.dir/helloworld.cpp.i

CMakeFiles/BasicProject.dir/helloworld.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/BasicProject.dir/helloworld.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /l/8/code/github_demo/C++/sandboxws/helloworld.cpp -o CMakeFiles/BasicProject.dir/helloworld.cpp.s

# Object files for target BasicProject
BasicProject_OBJECTS = \
"CMakeFiles/BasicProject.dir/helloworld.cpp.o"

# External object files for target BasicProject
BasicProject_EXTERNAL_OBJECTS =

BasicProject: CMakeFiles/BasicProject.dir/helloworld.cpp.o
BasicProject: CMakeFiles/BasicProject.dir/build.make
BasicProject: CMakeFiles/BasicProject.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/l/8/code/github_demo/C++/sandboxws/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable BasicProject"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/BasicProject.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/BasicProject.dir/build: BasicProject
.PHONY : CMakeFiles/BasicProject.dir/build

CMakeFiles/BasicProject.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/BasicProject.dir/cmake_clean.cmake
.PHONY : CMakeFiles/BasicProject.dir/clean

CMakeFiles/BasicProject.dir/depend:
	cd /l/8/code/github_demo/C++/sandboxws/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /l/8/code/github_demo/C++/sandboxws /l/8/code/github_demo/C++/sandboxws /l/8/code/github_demo/C++/sandboxws/build /l/8/code/github_demo/C++/sandboxws/build /l/8/code/github_demo/C++/sandboxws/build/CMakeFiles/BasicProject.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/BasicProject.dir/depend

