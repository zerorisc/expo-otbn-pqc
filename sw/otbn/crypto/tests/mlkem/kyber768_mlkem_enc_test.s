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
.word 0x115991c2
.word 0x97517965
.word 0x8577b5a3
.word 0x96039729
.word 0xc64aa94b
.word 0x3b2ad8a1
.word 0xe02ca11c
.word 0xe5b44b24
.word 0xb0280e42
.word 0xe36b0b6e
.word 0x4b757b1b
.word 0x28a07c4e
.word 0x4b5b485c
.word 0x883b2884
.word 0x1fab0278
.word 0x0592e608
.word 0xb3cb2e13
.word 0x54338e24
.word 0x19523ad5
.word 0x693f5065
.word 0x2572b63f
.word 0x6fab2154
.word 0x037cb14b
.word 0xabe11830
.word 0xf54bd31e
.word 0x595b4d28
.word 0xa73320ca
.word 0xa11996d8
.word 0xc73550d1
.word 0x7d23d983
.word 0x311c908e
.word 0x91c15c44
.word 0x03603f77
.word 0xf205ca05
.word 0xa7135f8a
.word 0x62d58e4e
.word 0xe74b5c40
.word 0xa9c09a26
.word 0x05ea0d5a
.word 0xe26d24c7
.word 0xd3765a11
.word 0x3a9658c6
.word 0x1c5c98d8
.word 0xe9084f49
.word 0xc43cdd29
.word 0x074856b8
.word 0x38584c1b
.word 0x99a352be
.word 0x7d5e79c0
.word 0xe4b09586
.word 0xcc984609
.word 0xf549aaf1
.word 0x6302239c
.word 0x91437917
.word 0x5203b773
.word 0x09ee4502
.word 0x7282db54
.word 0xdf30866a
.word 0xc853a823
.word 0x6bf789ad
.word 0xee5fc383
.word 0x496b4ca7
.word 0x378c7b18
.word 0xe249d1d2
.word 0x09666441
.word 0x8a96a249
.word 0x333b17b1
.word 0x54cb7a93
.word 0x599ae8ae
.word 0x45694b33
.word 0xb99f0fa8
.word 0xac593430
.word 0x66be347e
.word 0x63e8036b
.word 0xbcfb63c6
.word 0x5c33e8b0
.word 0x3cd3896b
.word 0x2f874a5e
.word 0x98667900
.word 0x3793a387
.word 0x9407078e
.word 0xf9c34560
.word 0x5c879f60
.word 0xc7e57284
.word 0x45656953
.word 0x00511f7a
.word 0x3a039f24
.word 0x3cb7785c
.word 0x48e233b8
.word 0x73788bae
.word 0x466fd291
.word 0xba6e2f3a
.word 0x135b7819
.word 0xb6075654
.word 0xa0466d32
.word 0x25e65c15
.word 0x050a51fe
.word 0xf4610315
.word 0x168b452f
.word 0xc06e16c6
.word 0xd8dc6d91
.word 0xb0d343ac
.word 0xe0cc6c4c
.word 0x701c779c
.word 0x6b251f47
.word 0x0e45f909
.word 0xd3194e67
.word 0x75a3ad27
.word 0x5dca4cdb
.word 0x59732b58
.word 0x8fe1d05a
.word 0x04bd7680
.word 0x0cc90419
.word 0xbf900c98
.word 0xbd23b262
.word 0x2be73ac1
.word 0x06e72b02
.word 0xeb0c3c50
.word 0xd33aa895
.word 0x5f970abf
.word 0xbe06661f
.word 0xfce07bbc
.word 0xcee31e6a
.word 0x160e4145
.word 0xb14103e9
.word 0x7772c62a
.word 0x65516b34
.word 0x06524da0
.word 0x5eb7608e
.word 0xca47975e
.word 0x15ff3846
.word 0xb380c4a3
.word 0xb589e415
.word 0x58e62285
.word 0x4870730d
.word 0xba6e93d0
.word 0xe3036213
.word 0xa0acac14
.word 0x0c42079c
.word 0x414c6488
.word 0x43bc8da5
.word 0xec3436be
.word 0x700b1c47
.word 0x30430843
.word 0xec6b5925
.word 0x5c0104b2
.word 0x986aa115
.word 0x6823a774
.word 0x3a6ea494
.word 0x2552613c
.word 0x89c9a4f7
.word 0x7bde2024
.word 0x9b8a6929
.word 0x3a5ef515
.word 0x501dcb00
.word 0x8576fa3a
.word 0xa1336aa3
.word 0x322ca94a
.word 0x5ae1e89a
.word 0xf024d3f3
.word 0x19472887
.word 0x6229ddca
.word 0x431b45f7
.word 0x361f51d7
.word 0xa7802e18
.word 0x39247523
.word 0xc09d4144
.word 0x42563c2f
.word 0x6174478a
.word 0x35636cd3
.word 0x5cfc1d8e
.word 0xea2da352
.word 0x34e72c49
.word 0x07eaf18e
.word 0x9c9267ab
.word 0xd8fc3a87
.word 0x8af8bc7c
.word 0x4c2d367f
.word 0x90fc3a2b
.word 0x29518234
.word 0x7f6eec71
.word 0x898503e1
.word 0xb9aad33c
.word 0x7a2d065b
.word 0xd58f1c74
.word 0x800734bc
.word 0xb9ba613e
.word 0xb3dc1f63
.word 0x7d110c02
.word 0xb747a8d8
.word 0x2305cd29
.word 0x3676c54d
.word 0x578548f4
.word 0xf121a060
.word 0xa9889e80
.word 0xf0b4d034
.word 0xd0984c65
.word 0x08a2d224
.word 0x4e662a87
.word 0x14f7b6c0
.word 0x5ff81a9d
.word 0xde2984fe
.word 0xabd9a990
.word 0x23005636
.word 0x6f50ca1d
.word 0x06c0083a
.word 0x9deafa45
.word 0xddc9a8ef
.word 0x65e03fcc
.word 0x854793c0
.word 0xb007f769
.word 0x6c47cfe9
.word 0x4c187476
.word 0xdc4c6cf9
.word 0xbc2131cb
.word 0x89057341
.word 0x3aa639db
.word 0xa13b3900
.word 0xa015f368
.word 0x1dc36159
.word 0xcc3179ab
.word 0x85e5e4cd
.word 0xd679e250
.word 0x90842e05
.word 0x54b9076d
.word 0xd9baab6c
.word 0x40765382
.word 0xb5e5b305
.word 0x43478b83
.word 0x6b7bce93
.word 0x7440dc95
.word 0x30bcec3f
.word 0x9ced6865
.word 0xa8090c85
.word 0x5750ec9b
.word 0x78f88690
.word 0xbd212e61
.word 0x090b2cc9
.word 0x434d2a31
.word 0x9bdab44b
.word 0x9bba2c34
.word 0x790a47f6
.word 0x3b49091d
.word 0x02a3c721
.word 0xf9e3bc03
.word 0x36eb0dad
.word 0x5a7dfa5a
.word 0x53c943b1
.word 0x3be2e79e
.word 0x52c7a6f2
.word 0x37604283
.word 0xcc95ce6a
.word 0x69c85b42
.word 0xe7cdb1f1
.word 0xc80a6d09
.word 0x4b67c3c2
.word 0xc0a67be6
.word 0x5709bf7f
.word 0xbe02b4ce
.word 0x505da022
.word 0x18b3cf0f
.word 0xae22d6b2
.word 0x286ecb3b
.word 0x75533d90
.word 0x9ba72a91
.word 0x9ad446d8
.word 0xc590a999
.word 0xe8c5c08f
.word 0x8030a679
.word 0x69ea10cd
.word 0x78249c72
.word 0xbc8d7508
.word 0x2946f34a
.word 0x288c54ad
.word 0xa00652cc
.word 0x669afbcc
.word 0x28661320
.word 0x8005ba32
.word 0x5df0bbbf
.word 0x81611a4d
.word 0xea562b80
.word 0xc4d45269
.word 0xf41da82a
.word 0x73bb2186
.word 0x9c84f8c3
.word 0x67a68480
.word 0xf8e54968
.word 0x18102596
.word 0xc97ab0c4
.word 0x12c0bd0c
.word 0x60b46621
.word 0x3b4034b7
.word 0x7e6f0986
.word 0x59b8acb7
.word 0xc4b517bc
.word 0xdebf0f21

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
