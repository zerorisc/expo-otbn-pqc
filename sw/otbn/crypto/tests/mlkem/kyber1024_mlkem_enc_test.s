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
.word 0x52e6b438
.word 0xf2a74de4
.word 0x269e0d37
.word 0x6513270e
.word 0xa6a3a450
.word 0x0c5c7fd0
.word 0x128b2f33
.word 0xd23f0824

.globl ek
ek: 
.word 0xc75949ef
.word 0x8129af24
.word 0x10010dba
.word 0x144200d2
.word 0x0275c804
.word 0x13f17363
.word 0xaa913741
.word 0x49759b02
.word 0xb6946f14
.word 0x30472a7a
.word 0x695f3fd9
.word 0x52d8229a
.word 0xa50b444e
.word 0x998a25c1
.word 0xae5b7276
.word 0x98af298e
.word 0x28e3c384
.word 0x3e894f3f
.word 0xd90fb6b4
.word 0x6b378849
.word 0xcdab6a58
.word 0x82723aa6
.word 0x46fc0536
.word 0x7889654a
.word 0xc737dc6b
.word 0x913fc079
.word 0x9b40ce30
.word 0x0e7d8cf2
.word 0x58028065
.word 0x855b5c06
.word 0xbb686af5
.word 0x089f604c
.word 0xc7c4a52d
.word 0x05be4c30
.word 0xdb7e8e31
.word 0x2e938353
.word 0x11c3b43a
.word 0x935f8923
.word 0x12071176
.word 0x19b5f552
.word 0xc69d728c
.word 0xb56b0a86
.word 0xc212c9aa
.word 0x38510b44
.word 0x22d9ad3a
.word 0xca2a2ced
.word 0x09e03ac3
.word 0xb64a0bac
.word 0x4a9aa06f
.word 0xe5af4820
.word 0x788b0802
.word 0xae8563dd
.word 0xa9049a0c
.word 0x0d5cec91
.word 0x4b8f569d
.word 0x13c9209b
.word 0x814cda72
.word 0xac53a520
.word 0x66b1c965
.word 0x9c33c94f
.word 0xd83c06f0
.word 0xa7c53e47
.word 0x6761395d
.word 0xf41fcb59
.word 0x058ca71b
.word 0x27ab5612
.word 0x8ca226bb
.word 0x853270b2
.word 0x539b4e9e
.word 0x88c9b69b
.word 0x9bfea5d0
.word 0xc24c15a0
.word 0x96491a23
.word 0x13736ab3
.word 0x7e06d562
.word 0x672da36d
.word 0xd74ba56c
.word 0x90c06614
.word 0xbcba9979
.word 0x86681897
.word 0xad5b245f
.word 0xd02f98a9
.word 0xa465650c
.word 0x848ad220
.word 0xd35333f7
.word 0xd9447fa3
.word 0x7468917e
.word 0xdaa635d1
.word 0x81cf11c9
.word 0x8d31fb83
.word 0xc0656bcf
.word 0x629b92c3
.word 0xc7e67647
.word 0x61b912d1
.word 0xf4792c2c
.word 0x909c951c
.word 0x78442368
.word 0xb9e72396
.word 0x7012c48c
.word 0x8980d803
.word 0x368dc87b
.word 0xce656c92
.word 0x5d3f2203
.word 0xc886a4c0
.word 0x3088a156
.word 0xda29f951
.word 0xb5c38abc
.word 0x20b8a362
.word 0x1a9b3b0e
.word 0x11e5cf89
.word 0xb5b27333
.word 0xda235b6f
.word 0x44e34d19
.word 0xc0573553
.word 0x4945f55d
.word 0x6b569e25
.word 0x1f459046
.word 0xd8c822d3
.word 0x889818f3
.word 0x5f42b81e
.word 0x93a9b381
.word 0x95adc49c
.word 0x5dd101a7
.word 0xea9473a4
.word 0xc1bcb729
.word 0x5e53f563
.word 0x76080bd7
.word 0x4307811a
.word 0x15455004
.word 0xaf4d94b0
.word 0x463bad30
.word 0xbfd84b3e
.word 0xe76b1412
.word 0x0c5f4093
.word 0x96c7096e
.word 0x6d1252f4
.word 0xd1f3911b
.word 0xc056c28b
.word 0x235adabf
.word 0x964a3620
.word 0xad64eb76
.word 0xe9ca2c22
.word 0xb13f4458
.word 0x2cc4880e
.word 0xd4286ceb
.word 0x06b11f57
.word 0x8ec891a3
.word 0xf7498baf
.word 0x22684388
.word 0x69d941ae
.word 0xc0245a5e
.word 0xda8f1889
.word 0x838584a1
.word 0xac5e3065
.word 0x559290c9
.word 0x4892e435
.word 0x73696ab0
.word 0xbb01821b
.word 0x2dc4e890
.word 0xca2a2b10
.word 0x14e59347
.word 0x2087b091
.word 0x1837a26f
.word 0x387ac356
.word 0x4dec6b0d
.word 0xa9696b14
.word 0x1a160365
.word 0x6679a810
.word 0x7d5c3b60
.word 0xa77814cb
.word 0xa698442d
.word 0x1d3cd08a
.word 0xc55f32da
.word 0x13552269
.word 0xd9bc7aa7
.word 0x3c999ac1
.word 0x0c591c45
.word 0xd0785930
.word 0x3a1c71a9
.word 0x7e2acf34
.word 0xf4219212
.word 0x755e7327
.word 0xaa9a645b
.word 0x2e6cd083
.word 0x5aca9138
.word 0xc288ba94
.word 0x28bacce4
.word 0xb2a04649
.word 0x6d3b290f
.word 0xee672100
.word 0x315a30e0
.word 0x9f410958
.word 0x4baa4664
.word 0x5588ca79
.word 0x63284142
.word 0x300987fd
.word 0x63209b66
.word 0x2c796688
.word 0xb42b15f3
.word 0x1827938c
.word 0x2eccfd4d
.word 0x3f67ac07
.word 0xe37603fc
.word 0x3d75009b
.word 0x4c6e3170
.word 0x4a919747
.word 0x8f0c3448
.word 0x355dd480
.word 0xf1c7bf98
.word 0x4af8f843
.word 0x1b34f79b
.word 0xb2b4adc2
.word 0xbee9f583
.word 0xed748985
.word 0x267a21ea
.word 0x80eb3b98
.word 0xcec1e035
.word 0x19b4cc39
.word 0xc563909e
.word 0xe38a7aaa
.word 0xf5c50142
.word 0x87b1a3c0
.word 0x2685062b
.word 0xab6744ca
.word 0x28e9809d
.word 0xa8285ac2
.word 0x35acc7b1
.word 0x977087a2
.word 0x5a6c9c7a
.word 0x035b1a38
.word 0x3c6ca018
.word 0xff2a78fe
.word 0x87c395d0
.word 0x31d94012
.word 0x3036e8bb
.word 0x801da175
.word 0x444a0cbb
.word 0x150020ae
.word 0x33a41b26
.word 0x208c1a5c
.word 0x94128ad3
.word 0xc9ed2683
.word 0xaaea7e7c
.word 0xdd63c3f9
.word 0xea9d6182
.word 0x28791dc9
.word 0x6b805976
.word 0x27547b13
.word 0x4eb6f053
.word 0xaab664cd
.word 0x1c58119b
.word 0x5103cd1a
.word 0xfa83d09e
.word 0x7c0d5618
.word 0x1f18361a
.word 0x1e8270db
.word 0x0cfa5be1
.word 0x3129dd60
.word 0x0e62b17d
.word 0xa3c3b48a
.word 0x5b5b5352
.word 0xbd18c60b
.word 0xe87da014
.word 0x1dc010c3
.word 0x6549a034
.word 0x93d66967
.word 0xba8a86b0
.word 0x226dd715
.word 0x9ae362d0
.word 0xc64a1a91
.word 0x6227015f
.word 0x69b32324
.word 0x58d1379e
.word 0xd89ed892
.word 0x1a82bb8c
.word 0x13e0f885
.word 0xab514427
.word 0xe16a5034
.word 0x6c9a889f
.word 0xe3233403
.word 0xacc44e2b
.word 0x8838e219
.word 0x60ce4c77
.word 0x386b7f2c
.word 0x3f994111
.word 0xc1637971
.word 0xc09d0317
.word 0xb0cbbab9
.word 0xeb6572b4
.word 0x1bb71037
.word 0x1d849b0b
.word 0xc320e61e
.word 0x51b6aef3
.word 0xc93cec96
.word 0x8c6154d4
.word 0x933f7b04
.word 0x17d79580
.word 0x8e2975a2
.word 0xd973ae59
.word 0x89726f7c
.word 0x43116760
.word 0x01da6923
.word 0x08868505
.word 0x85a0fcbb
.word 0x65a7ce82
.word 0x1c67141e
.word 0xeeb1e96e
.word 0xa3d45226
.word 0x2aa13dc2
.word 0x3211fbc0
.word 0x90bd3295
.word 0xba826658
.word 0x6251d636
.word 0xf0d7393a
.word 0xce206456
.word 0x859dbb87
.word 0x23c7492c
.word 0xcc9758b2
.word 0xd05983ec
.word 0x658f4e0a
.word 0x238c862b
.word 0x0d56047b
.word 0x092e6cfb
.word 0x3c05df1e
.word 0x0bb9e0c2
.word 0x98be3eb9
.word 0x7a14281a
.word 0x1d1fba8f
.word 0xd40935ab
.word 0x3d03ff23
.word 0x3b0376d4
.word 0x75e289d0
.word 0x4433e44c
.word 0xa03e27fc
.word 0x77574b83
.word 0x431a3f54
.word 0x9910cb92
.word 0xd6d010c6
.word 0xcabb922b
.word 0xbb7aea0f
.word 0x84c5ca53
.word 0x2f32f445
.word 0x489432bb
.word 0xf99c7c31
.word 0x456aed2d
.word 0xc13f8562
.word 0xf3951c9b
.word 0x28535f7e
.word 0x44ca56d5
.word 0x81118f54
.word 0x59597033
.word 0x197793fa
.word 0x32fd57e1
.word 0xb433529f
.word 0x3158b3f5
.word 0x348f7209
.word 0xc0069e97
.word 0xff8fa729
.word 0xb0a75813
.word 0x2de760aa
.word 0x7311c6bd
.word 0xa2d764f5
.word 0xbf31fc04
.word 0x8d0e987f
.word 0xaba76c44
.word 0xb2e77eb9
.word 0x179e4039
.word 0x9b590cf1
.word 0x76d48623
.word 0x3469e229
.word 0x0212b0fa
.word 0x158ac5c9
.word 0x569ce085
.word 0xd07d17e8
.word 0x07a923aa
.word 0x097600f6
.word 0xbaad662c
.word 0x9480163a
.word 0x4318f94a
.word 0x3a3b5d13
.word 0x123a8f4c
.word 0xc458a0ad
.word 0xf7d96972
.word 0x9513803b
.word 0xe91f0c7c
.word 0xd6643547
.word 0x279727b7
.word 0xd41d5335
.word 0xd802d903
.word 0xd9b9d5f9
.word 0x93435102
.word 0x44777e35

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
