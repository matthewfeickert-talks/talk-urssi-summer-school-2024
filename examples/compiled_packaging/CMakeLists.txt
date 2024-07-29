# Specify CMake version and project language
cmake_minimum_required(VERSION 3.15...3.30)
project(${SKBUILD_PROJECT_NAME} LANGUAGES CXX)

# Setup pybind11
set(PYBIND11_FINDPYTHON ON)
find_package(pybind11 CONFIG REQUIRED)

# Add the pybind11 module to build targets
pybind11_add_module(basic_math MODULE src/basic_math.cpp)
install(TARGETS basic_math DESTINATION ${SKBUILD_PROJECT_NAME})
