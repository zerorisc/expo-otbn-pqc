/* Copyright zeroRISC Inc. */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

/**
 * Test for the poly_uniform subroutine of ML-DSA.
 */

.section .text.start

main:
  /* Prepare all-zero register. */
  bn.xor w31, w31, w31

  /* Call poly_uniform with an all-zero input. */
  la  x10, rho
  la  x11, result
  li  x12, 0
  jal x1, poly_uniform

  ecall

.data

rho:
.zero 32

result:
.zero 1024
