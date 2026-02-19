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
.word 0x9f767c45
.word 0x4164d839
.word 0xbde5c099
.word 0x5bc8fbbc
.word 0xcb91ce37
.word 0xb0c11fde
.word 0xf1446bea
.word 0xd76d4330

.globl ek
ek: 
.word 0x5a710c7a
.word 0x74144f18
.word 0x48e07b59
.word 0xc4454315
.word 0xdbe285d4
.word 0x466922a1
.word 0x1bc38b85
.word 0xd1964a90
.word 0xa9114827
.word 0x8dcf0843
.word 0x96df2e00
.word 0xbfb53841
.word 0x72380276
.word 0x55374a37
.word 0xb22b7587
.word 0x44ca47f2
.word 0x6a49122a
.word 0x88a90957
.word 0x16c5b031
.word 0x19f4347b
.word 0x5cf7c091
.word 0xc95b96b7
.word 0x95f14c55
.word 0x5f1b7d93
.word 0x4d5569b8
.word 0xc60903eb
.word 0xa637db7d
.word 0xc6a6a807
.word 0x934485bb
.word 0x36f95d8f
.word 0xce07102e
.word 0x903b383b
.word 0x0da58f21
.word 0x43779c76
.word 0x4a6a82c5
.word 0xc0418324
.word 0xf1546155
.word 0xa3f5b5ea
.word 0x3389c508
.word 0x8c34a6db
.word 0xe91f72c8
.word 0x0fc0c890
.word 0xd8c207e0
.word 0x2c9a8a9b
.word 0x3fa88462
.word 0x5dc7064f
.word 0x9c50589c
.word 0x27586227
.word 0xe48377f8
.word 0xbae5a58b
.word 0x68fb1e7f
.word 0xbbb59691
.word 0x61231a91
.word 0xb9629123
.word 0x356c56e5
.word 0x65c30813
.word 0x4095e20e
.word 0x3a48c4f4
.word 0x25b12880
.word 0x48a3c58d
.word 0xe332d73c
.word 0x4b81a4b4
.word 0x8768d17d
.word 0x588094cc
.word 0xb2b4876b
.word 0xbea5db9b
.word 0xf87cf92b
.word 0x66b04e67
.word 0x8513ef8e
.word 0xe9970a67
.word 0x7838ccc0
.word 0xa96226c3
.word 0xf0580492
.word 0x5a443ee6
.word 0x54425cb5
.word 0x4ec57ad1
.word 0x58d8450b
.word 0x91091580
.word 0x37ad1828
.word 0x1296ae88
.word 0x65c18a33
.word 0xff62d627
.word 0x88b50de2
.word 0x9e986db2
.word 0xd79b4706
.word 0xc8ca33b6
.word 0x1c11da69
.word 0xd18a9639
.word 0x52f273b4
.word 0x2eba3f06
.word 0x34ad93b8
.word 0xc0daa525
.word 0x3cf137b0
.word 0xec3374f6
.word 0x027986da
.word 0x90d23a9a
.word 0x853edcd1
.word 0xac787a7a
.word 0x94cc7a14
.word 0x4c3c3cc2
.word 0xb2b3bff4
.word 0x93fa7dc8
.word 0xd081e7b3
.word 0xe2525587
.word 0x707bfba4
.word 0xbd864583
.word 0xc5aa4a8a
.word 0x731c203d
.word 0x484c269c
.word 0xa8285fc0
.word 0x8c6aa520
.word 0x1dac89ce
.word 0x351c2459
.word 0xcbb86b59
.word 0xafbac06d
.word 0x0a194b27
.word 0xa7541e5d
.word 0xb3889a7d
.word 0x25fecde0
.word 0x493b7bbd
.word 0x1c6c23a9
.word 0x94211bb4
.word 0xc4f7a869
.word 0x18a0a9b3
.word 0x59c4c185
.word 0x7fac9464
.word 0x6e60167a
.word 0xeb229218
.word 0xb89a8053
.word 0x872235e7
.word 0xc77cc2bc
.word 0x85a82d1d
.word 0x43134aa5
.word 0x0a4b8582
.word 0x62f206c3
.word 0xce32eb52
.word 0x470b9ab6
.word 0x82936114
.word 0x25c95454
.word 0x0c73625b
.word 0x0fa0f463
.word 0x5a8339fc
.word 0xe7025337
.word 0x11c30c4c
.word 0x5ab6a9fc
.word 0x69868491
.word 0xafa64a37
.word 0x31688c6c
.word 0x0853cc81
.word 0x5bb1c54b
.word 0x4a8566d5
.word 0x4a123f87
.word 0xaf87869c
.word 0xaca23538
.word 0xe4c8b956
.word 0x25e8ef06
.word 0xbd7b8742
.word 0xdb416f87
.word 0x4f449b61
.word 0x23516ac4
.word 0x63490856
.word 0xa605f82a
.word 0xbe49f5f0
.word 0x94f28c93
.word 0x36200259
.word 0x6e64988f
.word 0x986858e7
.word 0xc137162b
.word 0xb5c2db9e
.word 0xa9c99c00
.word 0x1afc2497
.word 0x951e45d8
.word 0x00f42ad3
.word 0xb9da520a
.word 0x532ce880
.word 0x750acd99
.word 0x39513004
.word 0x9b999247
.word 0x61ac3143
.word 0x3eebb216
.word 0x0662d526
.word 0x74a62596
.word 0x76792c63
.word 0x62aa3a61
.word 0xf4d96f51
.word 0x1c6c14b6
.word 0x426139e4
.word 0x66d311d2
.word 0x01887655
.word 0x47527b61
.word 0x617e3881
.word 0x781040b8
.word 0x051b64bd
.word 0x24157e16
.word 0x13543245
.word 0xda4d59cc
.word 0x8b6a040a
.word 0x3cdb3042
.word 0x9f9a3bd7
.word 0x2741bb88
.word 0x97c78da2
.word 0x8c32a0e1
.word 0x101f3ec4
.word 0x46b68172
.word 0x0b1897a9
.word 0x1a634db0
.word 0x8463c516
.word 0x7dad72ae
.word 0x31fdc843
.word 0x31c6ee5d
.word 0x6024b769
.word 0xe5528292
.word 0x3ff58e0c
.word 0x6081791d
.word 0x64e6c801
.word 0x6d19ed97
.word 0xbf70ac69
.word 0xa3acb8ac
.word 0x73f6dd24
.word 0x1c65f2af
.word 0x58449b44
.word 0x81543d14
.word 0x7331c868
.word 0x882d5fb0
.word 0x1f5c0629
.word 0x42c25c23
.word 0x1c023030
.word 0x37a1325a
.word 0x838a64b3
.word 0xa26ec139
.word 0x693c205a
.word 0x6b05069e
.word 0x22d77530
.word 0x11accd4d
.word 0x1b5be583
.word 0xf9521064
.word 0x0592a022
.word 0xf2a0aae2
.word 0x0080535b
.word 0x9641b59c
.word 0xbd768723
.word 0x90178410
.word 0xb7c79e9b
.word 0x5e409020
.word 0xc38491f6
.word 0x0b47149e
.word 0x9f8d4763
.word 0x498478b8
.word 0x3b3be019
.word 0xb08f9645
.word 0x032574ec
.word 0x91b2c58a
.word 0x26892cd7
.word 0xd9ac8533
.word 0xcb784bce
.word 0x30afaa05
.word 0x1934aac1
.word 0x1a187091
.word 0x7e059642
.word 0x985d9014
.word 0x0261760b
.word 0x4e9af8aa
.word 0x0703ae15
.word 0xba0ae686
.word 0xb4118cfd
.word 0x895646f1
.word 0x269c7d5c
.word 0xaa94c9f7
.word 0x22845001
.word 0x23f9f87a
.word 0xf832c5ff
.word 0x116d34e8
.word 0x581c6cc2
.word 0x157f7ce6
.word 0x047205cb
.word 0x7290023a
.word 0xe30fdcb2
.word 0x06a53151
.word 0x70e32d9a
.word 0x321da22a
.word 0x86dacc29
.word 0x017cc463
.word 0xc9a772bb
.word 0x635477c9
.word 0x2c7a6161
.word 0x9517e993
.word 0xcc01a3cc
.word 0x50f755a3
.word 0x24875a1e
.word 0xbbf3b9e2
.word 0xaaeaddc4
.word 0xc0b83215
.word 0xb381c483
.word 0x1ceb1910
.word 0x76a2e0ad
.word 0x73f4b890
.word 0x00f6a031
.word 0x7f47590d
.word 0xeab74443
.word 0x54bceb6e
.word 0x268493c8
.word 0xe9fcb99c
.word 0x26a1d270
.word 0xf09f8b33
.word 0xc4ce0a42
.word 0x51c4940f
.word 0xfcb1f6dc
.word 0xaa0fab12
.word 0x5c305805
.word 0xbc09400c
.word 0x86bb85c7
.word 0x68e2a984
.word 0xf88c1873
.word 0x3a210983
.word 0x0879d3b0
.word 0xde0d3439
.word 0x49983d1b
.word 0x6ad3219b
.word 0x2b5f9589
.word 0x3693aa17
.word 0xce6a51ba
.word 0x0318372c
.word 0xb290435c
.word 0xabe0cc07
.word 0xe86a927e
.word 0x021acd56
.word 0x9cd70462
.word 0x423ff328
.word 0xa33080b0
.word 0x3d264145
.word 0x3c67a0d0
.word 0xd808be92
.word 0x76044abf
.word 0xfd80b587
.word 0xa73e9fea
.word 0x3820e857
.word 0x2827dbfa
.word 0x53c02b32
.word 0x7078bcc9
.word 0xd0bc63fb
.word 0x6a9ba2b3
.word 0x3234b42e
.word 0x0d0bf8a5
.word 0x978544db
.word 0x54799a55
.word 0x7a3b999c
.word 0x8cc6058c
.word 0x332b88c8
.word 0x3fa33015
.word 0xa9119d45
.word 0x3706da44
.word 0x426aa293
.word 0xd0485934
.word 0x9edbd319
.word 0xf25d6cac
.word 0x4ab26a51
.word 0x2b22f891
.word 0xb11e683c
.word 0xf352868c
.word 0x8244956b
.word 0xf159a63d
.word 0x856b5d7b
.word 0x78d80738
.word 0x5ccce823
.word 0x8a1d0be0
.word 0x44d65c6e
.word 0xa7cfb977
.word 0xfcc084c5
.word 0xb634f51b
.word 0x0e9ca8a2
.word 0xbabf7e61
.word 0x18010011
.word 0xad1d7794
.word 0x6668bb9a
.word 0x3d10a4b2
.word 0xca09d712
.word 0xe7841a81
.word 0x4a8531cb
.word 0x5bb6bc10
.word 0xfa83a5bb
.word 0x37251b97
.word 0xea947af7
.word 0x002cb4d1
.word 0x6f5c8ba0
.word 0x92617676
.word 0xcf1c985c
.word 0xa925c7d4
.word 0x51a7b5dd
.word 0x0591fdd5
.word 0x762f1b2e
.word 0x7ff1ad44
.word 0x66cba9fd

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
