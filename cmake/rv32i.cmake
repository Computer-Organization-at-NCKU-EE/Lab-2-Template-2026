# Locate the riscv32-unknown-elf toolchain shipped in the official course
# Docker image. This file is loaded before project(), so the compiler choice
# is effective during CMake's language checks.
set(CROSS_COMPILE "riscv32-unknown-elf-" CACHE STRING
    "Prefix of the RV32 bare-metal GNU toolchain")

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR rv32i)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

find_program(RISCV_GCC NAMES "${CROSS_COMPILE}gcc" REQUIRED)
find_program(RISCV_AS NAMES "${CROSS_COMPILE}as" REQUIRED)
find_program(RISCV_AR NAMES "${CROSS_COMPILE}ar" REQUIRED)
find_program(RISCV_LD NAMES "${CROSS_COMPILE}ld" REQUIRED)
find_program(RISCV_OBJDUMP NAMES "${CROSS_COMPILE}objdump" REQUIRED)
find_program(RISCV_OBJCOPY NAMES "${CROSS_COMPILE}objcopy" REQUIRED)

set(CMAKE_C_COMPILER "${RISCV_GCC}" CACHE FILEPATH "" FORCE)
set(CMAKE_ASM_COMPILER "${RISCV_AS}" CACHE FILEPATH "" FORCE)
set(CMAKE_AR "${RISCV_AR}" CACHE FILEPATH "" FORCE)
set(CMAKE_LINKER "${RISCV_LD}" CACHE FILEPATH "" FORCE)
set(CMAKE_OBJDUMP "${RISCV_OBJDUMP}" CACHE FILEPATH "" FORCE)
set(CMAKE_OBJCOPY "${RISCV_OBJCOPY}" CACHE FILEPATH "" FORCE)

# Flags shared by the public targets. Assembly is sent directly to GNU `as`;
# `.S` files are deliberately not passed through the C preprocessor.
set(COMMON_COMPILE_FLAG
    "$<$<COMPILE_LANGUAGE:C>:-march=rv32i;-mabi=ilp32;-ffreestanding;-fno-builtin;-Wall;-Werror>"
    "$<$<COMPILE_LANGUAGE:ASM>:-march=rv32i;-mabi=ilp32>"
    CACHE INTERNAL "Common flags for Lab 2 RV32I targets")

set(CMAKE_C_FLAGS_INIT "-march=rv32i -mabi=ilp32")
set(CMAKE_ASM_FLAGS_INIT "-march=rv32i -mabi=ilp32")
# CMake's generic configuration presets contain C-driver options such as
# `-O3`, `-g`, and `-DNDEBUG`. GNU `as` must never receive those options.
foreach(config DEBUG RELEASE RELWITHDEBINFO MINSIZEREL)
    set(CMAKE_ASM_FLAGS_${config} "" CACHE STRING
        "No C-driver configuration flags for the direct GNU assembler" FORCE)
endforeach()
set(CMAKE_EXE_LINKER_FLAGS_INIT
    "-march=rv32i -mabi=ilp32 -nostartfiles -nostdlib -static")
