        .section .text
        .align  2
        .global array_sort
        .type   array_sort, @function

# void array_sort(int32_t *array, uint32_t size)
#
# a0: array, the address of the first signed 32-bit element
# a1: size, the number of elements (0 through 128)
#
# TODO: Sort the array in place in ascending signed order.
# You may add private helper routines and data below. Follow the RV32I ILP32
# calling convention and restore every callee-saved register that you use.
array_sort:
        ret

        .size   array_sort, .-array_sort
