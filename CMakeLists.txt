# CMake version requirements
cmake_minimum_required(VERSION 3.21...3.28)

# A CMake toolchain file must be selected before project() enables any
# language. Students may still override this from the command line when they
# have an equivalent RV32I toolchain.
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE
        "${CMAKE_CURRENT_LIST_DIR}/cmake/rv32i.cmake"
        CACHE FILEPATH "RISC-V RV32I toolchain file")
endif()

# project information
project(BaseRuntime VERSION 0.1.0
        DESCRIPTION "Bare-metal RV32I runtime for NCKU Computer Organization Lab 2"
        LANGUAGES C ASM)

# set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED True)

# Include only the public runtime and Lab 2 assignments. The official
# functional grader supplies its own pinned ISA simulator; students do not
# clone or build an ISS in this repository.
add_subdirectory(src)
add_subdirectory(asm-prog-assignment)
