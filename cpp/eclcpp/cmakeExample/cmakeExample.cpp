#include <iostream>
#include "config.h"

int main(int argc, char **argv) {
	std::cout << "Hello World from cmakeexample" << std::endl;
	std::cout << "Version " << cmakeExample_VERSION_MAJOR << "." << cmakeExample_VERSION_MINOR << std::endl;
	return 0;
}
