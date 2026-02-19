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
.word 0x598e4691
.word 0x26533c5a
.word 0x124a1165
.word 0xbd5f7c7b
.word 0xb38116ba
.word 0x98494ea8
.word 0x6468145e
.word 0x29e95006
.word 0x2dc5dc2e
.word 0x617018c9
.word 0xb8a079ec
.word 0x31351a32
.word 0xd4175059
.word 0xbb9f73d4
.word 0x8bb51c28
.word 0xb5c6294a
.word 0x715fb262
.word 0x2f0a96a8
.word 0x05a68c23
.word 0xf1055919
.word 0x628a3e47
.word 0x8ec619b3
.word 0xc6c705bb
.word 0x8b65b7a6
.word 0x20cbc085
.word 0xe935845a
.word 0x8b564cc2
.word 0xc973d47b
.word 0x48e88a89
.word 0x9f68f8c2
.word 0x6a319588
.word 0x779a8221
.word 0x484a2861
.word 0xc8cd0952
.word 0xdb0f0416
.word 0x0570bb97
.word 0x21254b6c
.word 0x2c275408
.word 0x72523593
.word 0x3e590544
.word 0x1a553a34
.word 0xa8b57615
.word 0x61183886
.word 0xaa3ccdc0
.word 0x0069248f
.word 0x9a8789c5
.word 0xb0db4131
.word 0x324bc10f
.word 0xaca54470
.word 0x958a7765
.word 0x6b94e13e
.word 0x997a8898
.word 0xe242ad1a
.word 0x6438560b
.word 0xe16ff276
.word 0xb8b08606
.word 0x065b6ac7
.word 0xb7145394
.word 0x0a9b1e21
.word 0x8a85280a
.word 0x072a9c1d
.word 0x063d6758
.word 0x059168b4
.word 0xe588b773
.word 0x62fa62e0
.word 0x27878f43
.word 0x2f6017b1
.word 0xdae04ac3
.word 0x4bd7554a
.word 0xca9d8ba1
.word 0xa3116e1a
.word 0x526871a4
.word 0xa5b9f471
.word 0xb8abb388
.word 0x56f88498
.word 0x22137462
.word 0x4b463e56
.word 0x476c4f8c
.word 0xc777075a
.word 0x639473ca
.word 0xc0850570
.word 0xe88dab90
.word 0xa0ac0b12
.word 0x25e411c7
.word 0xc20a9748
.word 0x9c35ba9c
.word 0xaa64b595
.word 0xbc29a4e6
.word 0xd5f95908
.word 0xcbb38338
.word 0xfc41e0a9
.word 0x37322a62
.word 0x37903805
.word 0x0f037c04
.word 0xc81fb10b
.word 0x85f89fbf
.word 0xc75347e2
.word 0x90fb565b
.word 0x44a5303e
.word 0x3556b8b7
.word 0x6be18577
.word 0xbe334e16
.word 0x5873886e
.word 0xec8c926b
.word 0x1df7db3b
.word 0x6c002610
.word 0xf7af1ec5
.word 0xce8bd408
.word 0xdb78a7d6
.word 0xd2bd3775
.word 0x1a9c1491
.word 0xf694766f
.word 0x650c7fe4
.word 0x7638f4b7
.word 0x40856071
.word 0x924a95aa
.word 0x01fbc18d
.word 0x51b193b9
.word 0xf9fd5220
.word 0x8384015b
.word 0x11707668
.word 0xcb974ee1
.word 0x5bd09410
.word 0xcb072b2e
.word 0xc0e01305
.word 0x5cd36dad
.word 0x2d2312f5
.word 0x3c81b572
.word 0x90e90b5e
.word 0x90c9e7dc
.word 0x57c7b8ac
.word 0x82184f90
.word 0x9469508e
.word 0x143d441b
.word 0x008bc0aa
.word 0xec8344ab
.word 0x9cdab672
.word 0xa1a01173
.word 0x2752998a
.word 0xc3739137
.word 0x40ab1dc3
.word 0xeb248731
.word 0x03cf554b
.word 0x203be3b0
.word 0x1a5bdc11
.word 0xb0b5581b
.word 0x6d850759
.word 0x173eb577
.word 0x67b6b627
.word 0x952265a3
.word 0x7a9f40d0
.word 0x33b90466
.word 0x60d9620d
.word 0x88977905
.word 0x242f2434
.word 0xb34b4d95
.word 0xf9a876a7
.word 0xc29a9968
.word 0x2dca3233
.word 0x73451733
.word 0xa9e650f2
.word 0x566c4b39
.word 0x134f48a6
.word 0xb59c8b5c
.word 0x41e86bc9
.word 0x8d0af571
.word 0x4c857c9c
.word 0x6240298a
.word 0x1a636003
.word 0x2c1aad73
.word 0x550c7f5f
.word 0x2606909f
.word 0xa56c3065
.word 0x1b529352
.word 0xfe0376e9
.word 0x8c1c9ca2
.word 0xa5014a93
.word 0x850aaad0
.word 0x89aa4f93
.word 0xc1661d4d
.word 0x135e1332
.word 0x1b13cda4
.word 0x9041cf57
.word 0xac187853
.word 0xaafa0e04
.word 0x08d75346
.word 0xa0294418
.word 0x184009f5
.word 0xcb22a02f
.word 0x12382a18
.word 0xb455197a
.word 0x3978be51
.word 0xcb2e3432
.word 0x542261f5
.word 0x14511a8e
.word 0xdaab6749
.word 0xb1ac9c32
.word 0x25b45a79
.word 0xf193db2c
.word 0x725d24e5
.word 0xc74b2297
.word 0x483f668b
.word 0x6b80c0d3
.word 0x4a74bf77
.word 0x21cfb1a9
.word 0xe17aaa7a
.word 0x1ccb8d2d
.word 0x8975da3f
.word 0x73aaba93
.word 0x10882ac7
.word 0xd9240b0f
.word 0x828fcfb0
.word 0x6e019dac
.word 0x6d02dc4e
.word 0xfcaa00e3
.word 0x29f5e36e
.word 0xfbc5f767
.word 0x13ef67c0
.word 0x48b9b6c1
.word 0x150e4a5b
.word 0xe984cfaa
.word 0x628350c4
.word 0x044df058
.word 0xfb8f0b35
.word 0xa4d1cf61
.word 0xed364675
.word 0x6a607435
.word 0x590c7214
.word 0x532368a4
.word 0x5cd05b36
.word 0xcf36e079
.word 0x0944001e
.word 0xb9e34b83
.word 0x478a959b
.word 0x978260a7
.word 0x83db4c57
.word 0xb2a7871c
.word 0x187590ba
.word 0x852a32b7
.word 0xc49a7cb2
.word 0x6d6e85d0
.word 0xa16725cb
.word 0xb5993176
.word 0xa623c09e
.word 0xf798aab2
.word 0x989c938d
.word 0x9451e8c8
.word 0x79584f24
.word 0x87548ecb
.word 0xe91a18b5
.word 0x0ac1cd80
.word 0x288644b4
.word 0xc641c4c2
.word 0xd2778205
.word 0x04039755
.word 0xc436d65a
.word 0xf0dc300c
.word 0x3394adc0
.word 0x923fc6b5
.word 0x44fa7571
.word 0x6d6a64a0
.word 0xb0754982
.word 0x5280aa59
.word 0x47251a4d
.word 0xcd375b2e
.word 0xc3a64677
.word 0x55879f78
.word 0x51b0a1c0
.word 0xcbac634c
.word 0xae26489e
.word 0xce3480cb
.word 0xf2139d52
.word 0x15b03355
.word 0x9c9767c2
.word 0x8adaa7b9
.word 0x61109329
.word 0xdacbb572
.word 0xe2685b33
.word 0x63757635
.word 0x5021da7f
.word 0x123e3fcc
.word 0x5594ce21
.word 0xb8a0bb61
.word 0x7a78b1c2
.word 0x1ef1c2aa
.word 0xf2b3300c
.word 0x96e64dd3
.word 0x3ac0b02d
.word 0x552d57f6
.word 0xcc2996b9
.word 0x8df04fc2
.word 0x207e88ca
.word 0x4ea300a5
.word 0x3cd55b19
.word 0x5bd91275
.word 0x8b94efaf

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
