.section .text.start

.globl main
main:
  /* Zeroize w31 */
  bn.xor w31, w31, w31

  li x4, 0
  li x5, 1
  li x6, 2
  la x7, operand1
  bn.lid x4, 0(x7++)
  bn.lid x5, 0(x7++)
  bn.mov w16, w1
  bn.mov w17, w1

  jal x1, test_bnmulv_8S
  jal x1, test_bnmulvl_8S

  /* Zeroize ACCL */
  bn.wsrw 0xb, w31

  jal x1, test_bnmulv_16H
  jal x1, test_bnmulvl_16H

  ecall

.data
.balign 32
.globl operand1
operand1:
  .dword 0x6baa9455d82c07cd
  .dword 0x7a02420482e2e662
  .dword 0x81332876e87a1613
  .dword 0xc17c627948268673

.globl operand2
operand2:
  .dword 0x4f65d4d9e6f4590b
  .dword 0xaf19922abad640fb
  .dword 0x6f25e2a219c78df4
  .dword 0x7a1d5006e9bb17bc

.globl result
result:
  .zero 5*1024
