/* Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

.text

/**
 * Constant Time Dilithium base multiplication (pointwise)
 *
 * Returns: poly_pointwise(input1, input2)
 *
 * This implements the base multiplication for Dilithium, where n=256,q=8380417.
 *
 * Flags: -
 *
 * @param[in]  x10: dptr_input1, dmem pointer to first word of input1 polynomial
 * @param[in]  x11: dptr_input2, dmem pointer to first word of input2 polynomial
 * @param[in]  w31: all-zero
 * @param[out] x12: dmem pointer to result
 *
 * clobbered registers: x4-x6, w2-w4
 */
.globl poly_pointwise_dilithium
poly_pointwise_dilithium:
    /* Set up constants for input/state */
    li x4, 2
    li x5, 3
    li x6, 4

    LOOPI 32, 4
        bn.lid x4, 0(x10++)
        bn.lid x5, 0(x11++)

        bn.mulvm.8S w2, w2, w3, 0

        bn.sid x4, 0(x12++)

    ret

/**
 * Constant Time Dilithium base multiplication (pointwise) with accumulation
 *
 * Returns: poly_pointwise_acc(input1, input2)
 *
 * This implements the base multiplication for Dilithium, where n=256,q=8380417.
 * Accumulates onto the output polynomial.
 *
 * Flags: -
 *
 * @param[in]  x10: dptr_input1, dmem pointer to first word of input1 polynomial
 * @param[in]  x11: dptr_input2, dmem pointer to first word of input2 polynomial
 * @param[in]  w31: all-zero
 * @param[in/out] x12: dmem pointer to result
 *
 * clobbered registers: x4-x6, w2-w4
 */
.globl poly_pointwise_acc_dilithium
poly_pointwise_acc_dilithium:
    /* Set up constants for input/state */
    li x4, 2
    li x5, 3
    li x6, 4

    LOOPI 32, 6
        bn.lid x4, 0(x10++)
        bn.lid x5, 0(x11++)

        bn.mulvm.8S w2, w2, w3

        /* Accumulate onto output polynomial */
        bn.lid x5, 0(x12)
        bn.addvm.8S w2, w2, w3

        bn.sid x4, 0(x12++)

    ret

/**
 * poly_sparse_schoolbook
 *
 * Implements schoolbook polynomial multiplication with the special restriction
 * that one of the operands has coefficients in {-1, 0, 1}. Expects this
 * special sparse polynomial to be represented in the same way as the output
 * from poly_challenge.
 *
 * Does not work in-place -- the output and input buffers must not overlap.
 *
 * Flags: Clobbers FG0, has no meaning beyond the scope of this subroutine.
 *
 * @param[in]  a0: pointer to input polynomial b
 * @param[in] w28: cnz, 1 bits where c is nonzero (in reverse order)
 * @param[in] w29: csn, 1 bits where c is negative (in reverse order)
 * @param[in] w31: all-zero
 * @param[out] a1: pointer to output polynomial
 *
 * clobbered registers: x5-x7, x10-x11, x28-x31, w0-w5
 */
.globl poly_sparse_schoolbook
poly_sparse_schoolbook:
  /* Initialize the output to 0. */
  li x5, 31
  LOOPI 32, 1
    bn.sid x5, 0(x11++)
  addi x11, x11, -1024

  /* Copy the sparse polynomial representatives. */
  bn.mov w3, w28
  bn.mov w4, w29

  /* Set up WDR pointers. */
  li x6, 1
  li x7, 2

  /* Set up a counter. */
  li x30, 0

  /*
    Loop invariants (i=0..255, at start of loop):
      x6 = 1
      x7 = 2
      *x10 = b * x^(i-j)
      *x11 = b * (c mod (x^i + 1))
      x30 = j (loops since last nonzero value)
      w3 = cnz << i
      w4 = csn << i
   */
  LOOPI 256, 63
    /* Shift cnz and move the MSb into FG0.C. */
    bn.add w3, w3, w3, FG0

    /* Extract the FG0.C flag (whether c[i] is nonzero). */
    csrrs x5, FG0, x0
    andi x5, x5, 1

    /* Shift csn and move the MSb into FG0.C. */
    bn.add w4, w4, w4, FG0
    beq x5, x0, _poly_sparse_schoolbook_loop_end

    /* Extract the FG0.C flag (sign of c[i]). */
    csrrs x5, FG0, x0
    andi x5, x5, 1

    /* Copy input/output pointers for add/sub. */
    addi x28, x10, 0
    addi x29, x11, 0

    /* Shift the input polynomial to multiply by x^j to get b * x^i. */

    /* TODO: can probably optimize a bit here by starting shift partway through
       word instead of always at the end. */

    /* Compute (j / 8) and skip the major shift if it is 0. */
    srli x31, x30, 3
    beq x31, x0, _poly_sparse_schoolbook_skip_major_shift

    /* Major shift: move 256b chunks (j/8) places, negating circulated ones. */
    LOOP x31, 7
      bn.lid x6, 992(x28)
      bn.subvm.8S w1, w31, w1
      LOOPI 32, 3
        bn.lid x7, 0(x28)
        bn.sid x6, 0(x28++)
        bn.mov w1, w2
      addi x28, x10, 0

    /* Update shift counter to reflect major shift (j %= 8). */
    andi x30, x30, 7

_poly_sparse_schoolbook_skip_major_shift:

    /* Choose add/sub either with or without a minor shift based on j. */
    bne x30, x0, _poly_sparse_schoolbook_with_minor_shift

    /* Choose either addition or subtraction based on sign. */
    bne x5, x0, _poly_sparse_schoolbook_sub_no_minor_shift

    /* c[i] == 1: add the multiple of b for this index. */
    LOOPI 32, 4
      bn.lid x6, 0(x28++)
      bn.lid x7, 0(x29)
      bn.addvm.8S w1, w2, w1
      bn.sid x6, 0(x29++)

    jal x0, _poly_sparse_schoolbook_loop_end

_poly_sparse_schoolbook_sub_no_minor_shift:
    /* c[i] == -1: subtract the multiple of b for this index. */
    LOOPI 32, 4
      bn.lid x6, 0(x28++)
      bn.lid x7, 0(x29)
      bn.subvm.8S w1, w2, w1
      bn.sid x6, 0(x29++)

    jal x0, _poly_sparse_schoolbook_loop_end

_poly_sparse_schoolbook_with_minor_shift:

    /* Read the last wide word and negate it in order to shift in the most
       significant coefficients (minor shift). */
    bn.lid x6, 992(x28)
    bn.subvm.8S w1, w31, w1

    /* Create masks based on the shift. */
    bn.not w30, w31
    LOOP x30, 1
      bn.rshi w30, w31, w30 >> 32
    bn.not w0, w30

    /* Choose either addition or subtraction based on sign. */
    bne x5, x0, _poly_sparse_schoolbook_sub_with_minor_shift

    /* c[i] == 1: add the multiple of b for this index. */
    LOOPI 32, 9
      bn.and w2, w1, w0
      bn.lid x6, 0(x28++)
      bn.and w5, w1, w30
      bn.or w5, w5, w2
      LOOP x30, 1
        bn.rshi w5, w5, w5 >> 224
      bn.lid x7, 0(x29)
      bn.addvm.8S w2, w2, w5
      bn.sid x7, 0(x29++)

    jal x0, _poly_sparse_schoolbook_loop_end

_poly_sparse_schoolbook_sub_with_minor_shift:
    /* c[i] == -1: subtract the multiple of b for this index. */
    LOOPI 32, 9
      bn.and w2, w1, w0
      bn.lid x6, 0(x28++)
      bn.and w5, w1, w30
      bn.or w5, w5, w2
      LOOP x30, 1
        bn.rshi w5, w5, w5 >> 224
      bn.lid x7, 0(x29)
      bn.subvm.8S w2, w2, w5
      bn.sid x7, 0(x29++)

_poly_sparse_schoolbook_loop_end:
    /* Increment the shift counter. */
    addi x30, x30, 1

  ret
