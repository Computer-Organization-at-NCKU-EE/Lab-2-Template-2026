        .section .text
        .align  2
        .global sudoku_solver
        .type   sudoku_solver, @function

# void sudoku_solver(int32_t *board)
#
# a0: board, the address of a row-major 4x4 board of signed 32-bit integers
#     Values 1 through 4 are fixed clues; 0 is an empty cell.
#
# TODO: Replace every empty cell with a valid value while preserving all
# clues. You may add private helper routines and data below. Follow the RV32I
# ILP32 calling convention and restore every callee-saved register that you
# use.
sudoku_solver:
        ret

        .size   sudoku_solver, .-sudoku_solver
