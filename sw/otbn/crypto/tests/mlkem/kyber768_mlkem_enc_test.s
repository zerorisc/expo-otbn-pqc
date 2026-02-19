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
.word 0xd82c07cd
.word 0x629f6fbe
.word 0xc2094cac
.word 0xe3e70682
.word 0x6baa9455
.word 0x0a5d2f34
.word 0x42485e3a
.word 0xf728b4fa

.globl ek
ek: 
.word 0x031656e5
.word 0x992b25a7
.word 0x5b664d61
.word 0x1a1c73a5
.word 0x48b349e9
.word 0x7495861c
.word 0xfd1de23d
.word 0x26618867
.word 0x1af43c02
.word 0x0b2ae598
.word 0x599fb11b
.word 0xbf968063
.word 0x3f986749
.word 0xd02dc513
.word 0x48f80f24
.word 0xb5aaaaac
.word 0xb2e8cb2c
.word 0x11577f79
.word 0xd4892826
.word 0xd7738136
.word 0x84065b61
.word 0xa9a952f7
.word 0xf3c66421
.word 0x079c0503
.word 0xab9020cd
.word 0xa6925261
.word 0x2a84c80d
.word 0x85c02a48
.word 0xc2d93eca
.word 0x582be0ad
.word 0xff1a6129
.word 0x951437c3
.word 0x6850beb0
.word 0xac86210f
.word 0xc3a0199c
.word 0x5d90c179
.word 0xf47e3254
.word 0x924aa9b6
.word 0xa189bd60
.word 0xff21d75b
.word 0x9c887f26
.word 0x9df62d0a
.word 0xfdba7b54
.word 0x39ac7c87
.word 0x3a476624
.word 0xc541b366
.word 0x54f2c95b
.word 0x4e80a66c
.word 0x2f143b84
.word 0x1b2444cb
.word 0x4a26e78a
.word 0x1105c7f7
.word 0x659aa14a
.word 0x8b501217
.word 0x3b99598f
.word 0xd95f48c6
.word 0x2db827b8
.word 0xc409006d
.word 0xb9d63db5
.word 0x124200cc
.word 0xc976833a
.word 0x17111570
.word 0xc6e7be06
.word 0x62a524a4
.word 0xc4e79430
.word 0xc58ac681
.word 0xf790e7ca
.word 0x641d6219
.word 0x4443e9b9
.word 0x1b4373c4
.word 0x5b723524
.word 0x0146887e
.word 0x740af643
.word 0xa99f8f16
.word 0x0a996ba8
.word 0xf0aafb44
.word 0x2836b576
.word 0xacfb33cf
.word 0x56415505
.word 0x423a74dc
.word 0x8e376fc3
.word 0xdb33403d
.word 0x4775cd1a
.word 0x833b6c0b
.word 0xd792e1f7
.word 0x5123435c
.word 0x98297276
.word 0xa97125da
.word 0x9215ca19
.word 0xcd8b22c8
.word 0x10c3a900
.word 0xda156b88
.word 0x1156ba11
.word 0x0f6005f3
.word 0x01e45fc0
.word 0x261bfaa2
.word 0x3307badf
.word 0x80425d06
.word 0x2eb0bf27
.word 0x011a0121
.word 0x99de45bc
.word 0x8a3285a2
.word 0x5010f5fb
.word 0x60c8c791
.word 0x3aaba183
.word 0x3ac63c7c
.word 0xb62f1cfa
.word 0xbf54f7b3
.word 0x1570c5ce
.word 0x881f44c2
.word 0x916884b8
.word 0xb227239b
.word 0x40d926c1
.word 0xb101408a
.word 0x1b63f886
.word 0x600f40b4
.word 0xa3c7e8a7
.word 0x761ed9d3
.word 0x4596ac4c
.word 0x30511845
.word 0xa6bdec87
.word 0xa4b67017
.word 0x53586a8f
.word 0x73930648
.word 0x7b0b8f18
.word 0xc24697ae
.word 0xf359dbc1
.word 0x34107e71
.word 0xa7ac9f46
.word 0xfe45c53f
.word 0xc21c68c6
.word 0x5a92b0bd
.word 0xa2406c71
.word 0x52ab67eb
.word 0x2c22cb76
.word 0x5b1b209e
.word 0x4319a121
.word 0xad90924a
.word 0x4cce4c35
.word 0xc0c5bf59
.word 0x84c8c208
.word 0x787d39a4
.word 0x22a10563
.word 0x4ad52893
.word 0x201c65d7
.word 0xf1c8507a
.word 0xa494c270
.word 0xa8b06a53
.word 0x79e9029a
.word 0x00cb272a
.word 0xd9520036
.word 0xa15a64b1
.word 0x4a95daca
.word 0xda70f477
.word 0x45189f95
.word 0x4e159ea3
.word 0xa468bc5a
.word 0x3b8d39fb
.word 0x0fdb687d
.word 0x4805a286
.word 0x071a5520
.word 0x8de7c00b
.word 0x35ce714a
.word 0xabe83746
.word 0x5cb8ec0f
.word 0xec0cd9b2
.word 0x898b29f0
.word 0xcce0e021
.word 0x0fb6237f
.word 0xe5e5c42b
.word 0x33b4a07c
.word 0xe73b34ae
.word 0x453b58a3
.word 0xcc917b74
.word 0x8f8fb2cc
.word 0x7a8c7fe9
.word 0x454713c7
.word 0x42ca8cb7
.word 0x04dc0434
.word 0x2d08ce30
.word 0xb4180777
.word 0x95a4681c
.word 0x0e49137e
.word 0xe602f324
.word 0xa52d6b32
.word 0x6f95648d
.word 0x8c1d89f0
.word 0x56175ba8
.word 0x2f3a5ecb
.word 0x2819b752
.word 0x62d7af87
.word 0x64d41181
.word 0x4c6fa304
.word 0xe799048a
.word 0x479518b3
.word 0x50789457
.word 0x80fb2acc
.word 0x48c9397a
.word 0x79393363
.word 0xca900cc4
.word 0x379184ab
.word 0xa2a7e458
.word 0xdb720d50
.word 0x94d4728b
.word 0xf8c9db9c
.word 0x71b82271
.word 0x299ad703
.word 0x5e933871
.word 0x19d64204
.word 0xc3f3fc15
.word 0x22ce0766
.word 0xd1ceb618
.word 0x866480c0
.word 0xd40f4858
.word 0x584ca410
.word 0x3263c55b
.word 0x5dcc2c63
.word 0xa9715195
.word 0x4debf8b2
.word 0xfa85f711
.word 0x59d7c168
.word 0x0f66a88f
.word 0x37b8a0dd
.word 0x22b54e4a
.word 0xa7d29f55
.word 0xf66cfb7b
.word 0x19245b69
.word 0xce81b444
.word 0x7c995566
.word 0x263560c2
.word 0x615b0dae
.word 0xf89d0b55
.word 0xe7af23ac
.word 0x1632888f
.word 0xbd1c056d
.word 0x22065767
.word 0xc8273366
.word 0xa0203701
.word 0x601cc4d9
.word 0x1d458c46
.word 0x223f4bcd
.word 0xbb2c5355
.word 0x899c1698
.word 0x5f060433
.word 0x13380c5c
.word 0x6e1c4933
.word 0x0e25a62b
.word 0x196764b2
.word 0x2b18ff71
.word 0x5029f620
.word 0x35043357
.word 0x2b16f830
.word 0xc23b7bda
.word 0x03886459
.word 0x2a5b1463
.word 0x6a2b461d
.word 0x1164290b
.word 0x6c2aab34
.word 0x3691a9da
.word 0x20de9dc1
.word 0x715c1f78
.word 0x6fb98357
.word 0x4ab8adf7
.word 0x15436254
.word 0x6917614b
.word 0x294002c1
.word 0x568894a0
.word 0xf9569284
.word 0x93faa1c2
.word 0x6fa65696
.word 0xdd116529
.word 0x6669aacb
.word 0x3a58fa79
.word 0x6e7ec392
.word 0xab670ca1
.word 0x46ac5eb7
.word 0x707e4a4f
.word 0x93788f17
.word 0x9f2262ca
.word 0x94ad3909
.word 0x790ec216
.word 0x9e0cb8ce
.word 0x257efcf9
.word 0x082b76d0
.word 0xb02c8819
.word 0x0f60d02e
.word 0x1b266e42
.word 0x27f53c04
.word 0xf8c73469
.word 0x9e4d6209
.word 0x4c7f06f1
.word 0x9e8c4d16
.word 0xb2511763
.word 0x48003d3e
.word 0x0fa62890
.word 0x6e977564

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
