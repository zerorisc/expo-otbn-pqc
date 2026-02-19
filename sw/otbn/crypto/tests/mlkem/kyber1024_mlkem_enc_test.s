/* Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

/*
 * Testwrapper for kyber_mlkem_enc
*/

.section .text.start

#define STACK_SIZE 20000
#define CRYPTO_BYTES 32

#if KYBER_K == 2
  #define CRYPTO_PUBLICKEYBYTES  800
  #define CRYPTO_SECRETKEYBYTES  1632
  #define CRYPTO_CIPHERTEXTBYTES 768
#elif KYBER_K == 3 
  #define CRYPTO_PUBLICKEYBYTES  1184
  #define CRYPTO_SECRETKEYBYTES  2400
  #define CRYPTO_CIPHERTEXTBYTES 1088
#elif KYBER_K == 4
  #define CRYPTO_PUBLICKEYBYTES  1568
  #define CRYPTO_SECRETKEYBYTES  3168
  #define CRYPTO_CIPHERTEXTBYTES 1568
#endif

/* Entry point. */
.globl main
main:
  /* Init all-zero register. */
  bn.xor  w31, w31, w31

  /* MOD <= dmem[modulus] = KYBER_Q */
  li      x5, 2
  la      x6, modulus
  bn.lid  x5++, 0(x6)
  la      x6, modulus_inv
  bn.lid  x5, 0(x6)
  bn.or   w2, w2, w3 << 32 /* MOD = R | Q */
  bn.wsrw 0x0, w2

  /* Load stack pointer */
  la   x2, stack_end
  la   x10, coins
  la   x11, ct
  la   x12, ss
  la   x13, ek
  jal  x1, crypto_kem_enc

  ecall

.data
.balign 32
.global stack
stack:
  .zero STACK_SIZE
stack_end:
.globl ct
ct:
  .zero CRYPTO_CIPHERTEXTBYTES
.globl ss
ss:
  .zero CRYPTO_BYTES

.balign 32
.globl coins
coins:
.word 0x3c6da5d7
.word 0x4da4f9fc
.word 0x1a6916c7
.word 0xb8a1abcd
.word 0x656412a9
.word 0x7a97c643
.word 0x27ac435a
.word 0x1710cf53

.globl ek
ek: 
.word 0xb7ae7027
.word 0x60f98be3
.word 0xa1f84399
.word 0xafa95612
.word 0x717c9cb7
.word 0x94d67b5e
.word 0x9eaf2828
.word 0xb8433f55
.word 0xb8f0e596
.word 0x5c21ec60
.word 0x0c253ac4
.word 0x21752cae
.word 0xfe2bb30e
.word 0xf0e82fc8
.word 0x5571a653
.word 0xcb30192a
.word 0x0bb344e1
.word 0x93e27282
.word 0x912786dd
.word 0xe1202a83
.word 0xaee8b249
.word 0xbb4bc5d0
.word 0x31eb7c91
.word 0x2b45d99e
.word 0x4ecf0b31
.word 0x183e551a
.word 0x3773a739
.word 0x4414c67d
.word 0x58095353
.word 0x9995a54a
.word 0xdf1c97d5
.word 0xa2a8c3bc
.word 0x64b5f9b6
.word 0xb14a6823
.word 0x08c48fc4
.word 0x3718e88b
.word 0x34624606
.word 0xe248461b
.word 0x24902b0e
.word 0xf84d36a2
.word 0x046b61e1
.word 0xc40b20bd
.word 0x4e7b9681
.word 0x48a17ce9
.word 0x721c44c8
.word 0xfec1625e
.word 0x92a697ba
.word 0xc2e1932f
.word 0xbdbed206
.word 0xdce77aaa
.word 0x21ea2a2e
.word 0x195d87bb
.word 0x37ce7e57
.word 0x99767427
.word 0x46035929
.word 0x77982ad4
.word 0xc7a1dd90
.word 0x7072d324
.word 0xa5e96328
.word 0x4e61ce98
.word 0xbfc57620
.word 0x96b02131
.word 0x855babc3
.word 0xfb2e0556
.word 0xf5a83a93
.word 0xcc8ab14e
.word 0xbd4c7907
.word 0x81f450e7
.word 0xc424e696
.word 0x0c1a08b3
.word 0xb96f465a
.word 0x6f813e7d
.word 0x70983267
.word 0x409e65fa
.word 0x1dbc631b
.word 0x992c05d6
.word 0xe7c2b083
.word 0x4b5b5e6a
.word 0x427beae0
.word 0x4113be2c
.word 0x4e22ed53
.word 0x309968e5
.word 0x551c09f4
.word 0x36b8d90e
.word 0xa58676c8
.word 0xc4c60327
.word 0x1df55874
.word 0x57a40b49
.word 0xca9b5a35
.word 0x9d1a60ad
.word 0x3909599d
.word 0x25c71fab
.word 0x5838b96e
.word 0x9b81966f
.word 0x1950bfe5
.word 0x7bf1f24e
.word 0x223da9bf
.word 0xe6195f42
.word 0x7bec6e41
.word 0xd80ac188
.word 0xfb25241a
.word 0x4778fd0d
.word 0x5246ab4f
.word 0xf877bb76
.word 0x0e03e167
.word 0x7fbe8262
.word 0x84dacbd3
.word 0x7782daa7
.word 0x24a4a1d8
.word 0x43eb7e30
.word 0x4c38dc34
.word 0x0bcf0c06
.word 0xb9a05b86
.word 0xa9d1206c
.word 0x63649331
.word 0xa5310a49
.word 0x69e6bcb3
.word 0x99886734
.word 0xeb2924cb
.word 0x08003c3d
.word 0xc9cff862
.word 0xcbf05680
.word 0x9d5a7d9d
.word 0x7199c7b4
.word 0x43c74d31
.word 0x14a0284d
.word 0xf307232b
.word 0xbabd35d6
.word 0x0cd46ba1
.word 0x413bfc2c
.word 0x2b7048f8
.word 0x6a452003
.word 0xa76ac134
.word 0x59925c7b
.word 0x17286945
.word 0x1f89ecd6
.word 0xe3d25c22
.word 0xc5f41fa7
.word 0x0b82da1b
.word 0xab7a09fb
.word 0x7a29b172
.word 0x0284512b
.word 0x0b69bc07
.word 0x01b42099
.word 0xed15a0b1
.word 0xcc533930
.word 0xc476146f
.word 0xd804c54a
.word 0x00816333
.word 0x93b5e8c3
.word 0xc34f704b
.word 0xcc4c6474
.word 0x5b32f163
.word 0xfc6c1128
.word 0xf9761dd7
.word 0x6e228d2b
.word 0xcb99fb15
.word 0xd2909da4
.word 0x6554e403
.word 0x2fa003e6
.word 0x7b72b9c8
.word 0x60a1423f
.word 0x83c19145
.word 0x599f68e4
.word 0x2747d821
.word 0x1d1c9c86
.word 0xe00ca6d3
.word 0x23042ea1
.word 0x531f75e6
.word 0x9265255a
.word 0x4f4a4052
.word 0x120d9583
.word 0xc051168a
.word 0x0b34ca92
.word 0x29153a59
.word 0x7540bd69
.word 0x44ac9f62
.word 0x3e66336e
.word 0xf43e5dc1
.word 0xca61f081
.word 0x559ab8db
.word 0xfbdeadf0
.word 0x97db9381
.word 0xb28e430f
.word 0x568b11d1
.word 0xa56bbf2e
.word 0x857d909d
.word 0x7a2518f8
.word 0x9030f21a
.word 0xda311a18
.word 0x98fa7c63
.word 0xa483e986
.word 0xe7bc7c11
.word 0x7913c015
.word 0xc707ca55
.word 0xd49c782c
.word 0xf216667b
.word 0x7182c591
.word 0xa96471bf
.word 0x224b4175
.word 0x7a50b1c7
.word 0x51117571
.word 0x65465cc6
.word 0x0ac27483
.word 0xb76499b2
.word 0xb6f8bd75
.word 0x852a1363
.word 0x67082508
.word 0x52c85fe5
.word 0x127c9663
.word 0xa6bc0c5e
.word 0x06a3763c
.word 0x62963a4d
.word 0x62c10255
.word 0x09ea6e91
.word 0x8fc86bba
.word 0xb7267925
.word 0x55a435a6
.word 0x5bfaecba
.word 0x6a6f3932
.word 0x4808aa11
.word 0x9ad52402
.word 0xb86fa7f4
.word 0xf7761571
.word 0x4f758b7e
.word 0x3a1a3844
.word 0x3396c132
.word 0x453a8d4d
.word 0x171fb7c9
.word 0xb4c28faa
.word 0xabe50c9d
.word 0xa4b4405f
.word 0xa79d1b09
.word 0x262b9952
.word 0xfd41cc11
.word 0xe3d52176
.word 0x39845f0d
.word 0xf6bcf2e3
.word 0x2bb35507
.word 0xa0b2600b
.word 0xc5938b82
.word 0x90da5a92
.word 0xc239e840
.word 0x5472024e
.word 0x3a32404a
.word 0x4e22079f
.word 0x883e0648
.word 0x3c0db245
.word 0x649a4fac
.word 0xd2239b9a
.word 0x9b1b1de8
.word 0x59ec812d
.word 0x1cb3292f
.word 0xac1a86ac
.word 0xb9d27d7c
.word 0xa541b288
.word 0x3c656eea
.word 0x5cf89418
.word 0xb9143926
.word 0x52a23967
.word 0xa5e71546
.word 0x7093157f
.word 0xe0e81bac
.word 0x6892c935
.word 0x49a6c303
.word 0xf4ba3776
.word 0x7e2a9e7e
.word 0x9b315b4c
.word 0xd4f6b4d8
.word 0x05b7c715
.word 0xc6385a36
.word 0x3878b657
.word 0x8cf3cd39
.word 0xf2acf9cf
.word 0xc8cf9491
.word 0x12e182aa
.word 0x3563139d
.word 0x2a658e79
.word 0x1f78cc3a
.word 0xed094624
.word 0x54798c76
.word 0x515611ae
.word 0x81c2f56a
.word 0xc769b4b1
.word 0x5bb8b369
.word 0x846e839f
.word 0xe413a200
.word 0x6827164b
.word 0x777769b2
.word 0x5c300fa7
.word 0x06e7362d
.word 0x2264a975
.word 0x180a1c76
.word 0x7e8a2a74
.word 0x50bd2c46
.word 0x4b7f6a88
.word 0x4291fc2b
.word 0x3aacbc7d
.word 0x06531458
.word 0x0ab2ac0f
.word 0x319e76c9
.word 0x9c2d43da
.word 0x59a4278f
.word 0xc474951d
.word 0x5933b911
.word 0x6e0703b0
.word 0x751c3a7c
.word 0xcc581631
.word 0x2037ce63
.word 0x12be6847
.word 0xd766175b
.word 0x10458a1f
.word 0xb26b9b24
.word 0x450e6f91
.word 0x2038612e
.word 0x0b923b38
.word 0xb226c0f7
.word 0x5a08eb9c
.word 0xbd92daac
.word 0x89894a58
.word 0x233b9d11
.word 0x17c3b684
.word 0x00a99bd3
.word 0x677972d0
.word 0x0cb4f0d4
.word 0xeb0a112a
.word 0x28131470
.word 0x39cbacdd
.word 0x2972327c
.word 0xc8b2e3ac
.word 0xb90317bb
.word 0x45474d58
.word 0x3c9a469e
.word 0x89cf9707
.word 0x8c209c24
.word 0x331b7246
.word 0xb007315f
.word 0xa06c5a83
.word 0x17072a55
.word 0xe5958b3f
.word 0x96981b09
.word 0x3c688391
.word 0xae77f656
.word 0xa83693c2
.word 0x345ce715
.word 0x9a99cb9f
.word 0xdc8c098a
.word 0xcf14fcc8
.word 0x5b3232ee
.word 0x713b23d3
.word 0x5990ab2c
.word 0xcf4dcb4d
.word 0x13a60077
.word 0x0ae06510
.word 0x9b7ac684
.word 0x82e622d2
.word 0x5da7a094
.word 0x4db6022d
.word 0x64867e8b
.word 0x8931d089
.word 0x73cb6c30
.word 0x38c400ea
.word 0x2a5c0faf
.word 0xc03cf06a
.word 0x34d8926b
.word 0xb8a2947a
.word 0xf332294a
.word 0x6756a087
.word 0x81c2b97d
.word 0x590680ef
.word 0x2c596af5
.word 0xa9cb679c
.word 0x41be5c5e
.word 0xdaa1736a
.word 0x383ce81b
.word 0x492d35d0
.word 0x173ca556
.word 0x62c3aa19
.word 0x51979396
.word 0x782d842b
.word 0x39acb002
.word 0x9cb9fb8d
.word 0xd8dea4b8
.word 0x74b00850
.word 0xeeb04874
.word 0xd66d3c2e
.word 0xfd02c10a
.word 0x1da6512d
.word 0x25fd8b91
.word 0x52599160
.word 0x4097ed0b
.word 0x76d9853c

/* Modulus: KYBER_Q = 3329 */
.globl modulus
modulus:
  .word 0x00000d01
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000

.globl modulus_inv
modulus_inv:
  .word 0x00000cff
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000

.globl modulus_bn
modulus_bn:
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01

.globl modulus_over_2
modulus_over_2:
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681

.globl const_0x0fff
const_0x0fff:
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff

.globl const_1290167
const_1290167:
  .word 0x0013afb7
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000

.globl const_8
const_8:
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  
.globl const_tomont
const_tomont:
  .word 0x05490549 /* 2^32 % KYBER_Q */
  .word 0x05490549
  .word 0x05490549
  .word 0x05490549
  .word 0x05490549
  .word 0x05490549
  .word 0x05490549
  .word 0x05490549
  
.globl twiddles_ntt
twiddles_ntt:
    /* Layer 1--4 */ 
    .half 0x0a0b
    .half 0x0b9a
    .half 0x0714
    .half 0x05d5
    .half 0x058e
    .half 0x011f
    .half 0x00ca
    .half 0x0c56
    .half 0x026e
    .half 0x0629
    .half 0x00b6
    .half 0x03c2
    .half 0x084f
    .half 0x073f
    .half 0x05bc
    /* Padding */
    .half 0x0000
    /* Layer 5 */
    .word 0x023d023d
    .word 0x07d407d4
    .word 0x01080108
    .word 0x017f017f
    .word 0x09c409c4
    .word 0x05b205b2
    .word 0x06bf06bf
    .word 0x0c7f0c7f
    .word 0x0a580a58
    .word 0x03f903f9
    .word 0x02dc02dc
    .word 0x02600260
    .word 0x06fb06fb
    .word 0x019b019b
    .word 0x0c340c34
    .word 0x06de06de
    /* Layer 6 */
    .word 0x04c704c7
    .word 0x0ad90ad9
    .word 0x07f407f4
    .word 0x0be70be7
    .word 0x02040204
    .word 0x0bc10bc1
    .word 0x06af06af
    .word 0x007e007e
    .word 0x028c028c
    .word 0x03f703f7
    .word 0x05d305d3
    .word 0x06f906f9
    .word 0x0cf90cf9
    .word 0x0a670a67
    .word 0x08770877
    .word 0x05bd05bd
    .word 0x09ac09ac
    .word 0x0bf20bf2
    .word 0x006b006b
    .word 0x0c0a0c0a
    .word 0x0b730b73
    .word 0x071d071d
    .word 0x01c001c0
    .word 0x02a502a5
    .word 0x0ca70ca7
    .word 0x033e033e
    .word 0x07740774
    .word 0x094a094a
    .word 0x03c103c1
    .word 0x0a2c0a2c
    .word 0x08d808d8
    .word 0x08060806
    /* Layer 7 */
    .word 0x08b208b2
    .word 0x081e081e
    .word 0x01a601a6
    .word 0x0bde0bde
    .word 0x0c0b0c0b
    .word 0x09f809f8
    .word 0x06cb06cb
    .word 0x01a201a2
    .word 0x01ae01ae
    .word 0x03670367
    .word 0x024b024b
    .word 0x0b350b35
    .word 0x030a030a
    .word 0x05cb05cb
    .word 0x02840284
    .word 0x01490149
    .word 0x022b022b
    .word 0x060e060e
    .word 0x00b100b1
    .word 0x06260626
    .word 0x04870487
    .word 0x0aa70aa7
    .word 0x09990999
    .word 0x0c650c65
    .word 0x034b034b
    .word 0x00690069
    .word 0x0c160c16
    .word 0x06750675
    .word 0x0c6e0c6e
    .word 0x045f045f
    .word 0x015d015d
    .word 0x0cb60cb6
    .word 0x03310331
    .word 0x052a052a
    .word 0x08420842
    .word 0x09970997
    .word 0x08600860
    .word 0x071b071b
    .word 0x0c950c95
    .word 0x03be03be
    .word 0x04490449
    .word 0x07fc07fc
    .word 0x0c790c79
    .word 0x00dc00dc
    .word 0x07070707
    .word 0x09ab09ab
    .word 0x0bcd0bcd
    .word 0x074d074d
    .word 0x025b025b
    .word 0x07480748
    .word 0x04c204c2
    .word 0x085e085e
    .word 0x08030803
    .word 0x099b099b
    .word 0x03e403e4
    .word 0x05f205f2
    .word 0x02620262
    .word 0x01800180
    .word 0x07ca07ca
    .word 0x06860686
    .word 0x031a031a
    .word 0x01de01de
    .word 0x03df03df
    .word 0x065c065c

.globl twiddles_intt
twiddles_intt:
  /* Layer 7 */
  .word 0x06a506a5
  .word 0x09220922
  .word 0x0b230b23
  .word 0x09e709e7
  .word 0x067b067b
  .word 0x05370537
  .word 0x0b810b81
  .word 0x0a9f0a9f
  .word 0x070f070f
  .word 0x091d091d
  .word 0x03660366
  .word 0x04fe04fe
  .word 0x04a304a3
  .word 0x083f083f
  .word 0x05b905b9
  .word 0x0aa60aa6
  .word 0x05b405b4
  .word 0x01340134
  .word 0x03560356
  .word 0x05fa05fa
  .word 0x0c250c25
  .word 0x00880088
  .word 0x05050505
  .word 0x08b808b8
  .word 0x09430943
  .word 0x006c006c
  .word 0x05e605e6
  .word 0x04a104a1
  .word 0x036a036a
  .word 0x04bf04bf
  .word 0x07d707d7
  .word 0x09d009d0
  .word 0x004b004b
  .word 0x0ba40ba4
  .word 0x08a208a2
  .word 0x00930093
  .word 0x068c068c
  .word 0x00eb00eb
  .word 0x0c980c98
  .word 0x09b609b6
  .word 0x009c009c
  .word 0x03680368
  .word 0x025a025a
  .word 0x087a087a
  .word 0x06db06db
  .word 0x0c500c50
  .word 0x06f306f3
  .word 0x0ad60ad6
  .word 0x0bb80bb8
  .word 0x0a7d0a7d
  .word 0x07360736
  .word 0x09f709f7
  .word 0x01cc01cc
  .word 0x0ab60ab6
  .word 0x099a099a
  .word 0x0b530b53
  .word 0x0b5f0b5f
  .word 0x06360636
  .word 0x03090309
  .word 0x00f600f6
  .word 0x01230123
  .word 0x0b5b0b5b
  .word 0x04e304e3
  .word 0x044f044f
  /* Layer 6 */
  .word 0x04fb04fb
  .word 0x04290429
  .word 0x02d502d5
  .word 0x09400940
  .word 0x03b703b7
  .word 0x058d058d
  .word 0x09c309c3
  .word 0x005a005a
  .word 0x0a5c0a5c
  .word 0x0b410b41
  .word 0x05e405e4
  .word 0x018e018e
  .word 0x00f700f7
  .word 0x0c960c96
  .word 0x010f010f
  .word 0x03550355
  .word 0x07440744
  .word 0x048a048a
  .word 0x029a029a
  .word 0x00080008
  .word 0x06080608
  .word 0x072e072e
  .word 0x090a090a
  .word 0x0a750a75
  .word 0x0c830c83
  .word 0x06520652
  .word 0x01400140
  .word 0x0afd0afd
  .word 0x011a011a
  .word 0x050d050d
  .word 0x02280228
  .word 0x083a083a
  /* Layer 5 */
  .word 0x06230623
  .word 0x00cd00cd
  .word 0x0b660b66
  .word 0x06060606
  .word 0x0aa10aa1
  .word 0x0a250a25
  .word 0x09080908
  .word 0x02a902a9
  .word 0x00820082
  .word 0x06420642
  .word 0x074f074f
  .word 0x033d033d
  .word 0x0b820b82
  .word 0x0bf90bf9
  .word 0x052d052d
  .word 0x0ac40ac4
  /* Layer 4--2 */
  .half 0x0745
  .half 0x05c2
  .half 0x04b2
  .half 0x093f
  .half 0x0c4b
  .half 0x06d8
  .half 0x0a93
  .half 0x00ab
  .half 0x0c37
  .half 0x0be2
  .half 0x0773
  .half 0x072c
  .half 0x05ed
  .half 0x0167
  /* Layer 1 */
  .half 0x078c /* ((758*2^16) mod KYBER_Q)*(1/128) mod KYBER_Q */
  /* [(2^32 mod KYBER_Q)*(1/128)] mod KYBER_Q */
  .half 0x05a1

.globl twiddles_basemul
twiddles_basemul:
    .word 0x081e08b2
    .word 0x04e3044f
    .word 0x036701ae
    .word 0x099a0b53
    .word 0x060e022b
    .word 0x06f30ad6
    .word 0x0069034b
    .word 0x0c9809b6

    .word 0x0bde01a6
    .word 0x01230b5b
    .word 0x0b35024b
    .word 0x01cc0ab6
    .word 0x062600b1
    .word 0x06db0c50
    .word 0x06750c16
    .word 0x068c00eb

    .word 0x09f80c0b
    .word 0x030900f6
    .word 0x05cb030a
    .word 0x073609f7
    .word 0x0aa70487
    .word 0x025a087a
    .word 0x045f0c6e
    .word 0x08a20093

    .word 0x01a206cb
    .word 0x0b5f0636
    .word 0x01490284
    .word 0x0bb80a7d
    .word 0x0c650999
    .word 0x009c0368
    .word 0x0cb6015d
    .word 0x004b0ba4

    .word 0x052a0331
    .word 0x07d709d0
    .word 0x07fc0449
    .word 0x050508b8
    .word 0x0748025b
    .word 0x05b90aa6
    .word 0x01800262
    .word 0x0b810a9f

    .word 0x09970842
    .word 0x036a04bf
    .word 0x00dc0c79
    .word 0x0c250088
    .word 0x085e04c2
    .word 0x04a3083f
    .word 0x068607ca
    .word 0x067b0537

    .word 0x071b0860
    .word 0x05e604a1
    .word 0x09ab0707
    .word 0x035605fa
    .word 0x099b0803
    .word 0x036604fe
    .word 0x01de031a
    .word 0x0b2309e7

    .word 0x03be0c95
    .word 0x0943006c
    .word 0x074d0bcd
    .word 0x05b40134
    .word 0x05f203e4
    .word 0x070f091d
    .word 0x065c03df
    .word 0x06a50922
