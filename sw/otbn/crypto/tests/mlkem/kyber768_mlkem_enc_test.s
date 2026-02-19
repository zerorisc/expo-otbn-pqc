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
.word 0x3ceb3ffd
.word 0x97b75092
.word 0x8b529b4a
.word 0x21636369
.word 0x5eb561a4
.word 0xea7b5bf5
.word 0x9a9a80fd
.word 0x795b929e

.globl ek
ek: 
.word 0x456bdca0
.word 0xc32459c4
.word 0x1c2653b4
.word 0x376665d3
.word 0xa3de6a4b
.word 0xbf7131a9
.word 0x1555d7bb
.word 0x9810ba0a
.word 0xb6f7678b
.word 0xaeb4a38f
.word 0xe07a8d75
.word 0xcf30b0b9
.word 0xac4e4991
.word 0x01da51ac
.word 0x01b017c9
.word 0x10bac8aa
.word 0x419401c4
.word 0x82f28436
.word 0x3a0ec3b9
.word 0x72ac4e61
.word 0x27812d24
.word 0x0d43b594
.word 0x05cc9e38
.word 0x420b3993
.word 0x2634bb16
.word 0xd7f0a853
.word 0x06e4aea6
.word 0x84abda8c
.word 0xbc0223e7
.word 0x4c9aa825
.word 0x7e096970
.word 0xbc11913a
.word 0x407c6791
.word 0x5e7435fb
.word 0x84368a8a
.word 0x7e933a54
.word 0x755093b6
.word 0xe64d2aa6
.word 0x4d0ce689
.word 0x510d44b8
.word 0x255d30d9
.word 0x3b72e256
.word 0xb99145f6
.word 0x307f4a25
.word 0x86f5861c
.word 0x2451f4bd
.word 0xf3d63115
.word 0x9c3ab363
.word 0x63634bd6
.word 0x22fc2f14
.word 0x6b4196c3
.word 0xb93ca0f4
.word 0xf5ea3da9
.word 0x29a8afb9
.word 0x477a4615
.word 0xb9950625
.word 0x208a33c5
.word 0xe539fb8b
.word 0xd289cfac
.word 0x86c6fc7a
.word 0xfc8f56a3
.word 0x46356581
.word 0xb4460d42
.word 0xb125618a
.word 0x4890563a
.word 0x0aa0c292
.word 0xffb88076
.word 0xb654c293
.word 0x971cd698
.word 0xc2a21359
.word 0xcce18cb0
.word 0xca71bb7b
.word 0x0307ab29
.word 0xc307a399
.word 0xcb374349
.word 0x7ab5d64b
.word 0x4721c676
.word 0x5aca67a3
.word 0xefc6dc33
.word 0xc5b553e2
.word 0x1985f817
.word 0xa4279c4e
.word 0xcc3c0998
.word 0x9991631e
.word 0x895efa6c
.word 0x4bc8727a
.word 0x8695d82b
.word 0xce4a5a9b
.word 0x266c2e58
.word 0x9f5a279b
.word 0x1c75c51f
.word 0x321d3389
.word 0x7706c7b5
.word 0x15be7082
.word 0x01ddce44
.word 0x8371cc1e
.word 0x098b18e5
.word 0x514e2cd9
.word 0xcbe8d089
.word 0xcb0436ce
.word 0x7cab2de5
.word 0x30001daa
.word 0xbc19e382
.word 0xe8eb5235
.word 0x6e37747f
.word 0xaf54d876
.word 0x4aecb99a
.word 0x45864449
.word 0xf57742fb
.word 0x5a07c602
.word 0x557c6ec8
.word 0x43455a35
.word 0xba4c4b7c
.word 0x5cb32dc7
.word 0xbe737b63
.word 0xdc2e1d51
.word 0x2ce3f33c
.word 0x84827408
.word 0x3bba4583
.word 0x5e89e603
.word 0xe69c0182
.word 0x49fcc62b
.word 0x64d96183
.word 0xfe1d60f2
.word 0x62e16067
.word 0xb2446f18
.word 0xbe25f2ca
.word 0x6a462012
.word 0x07902e2e
.word 0xea0108fe
.word 0x079759fc
.word 0x3339f565
.word 0x05153517
.word 0x76c7ac87
.word 0x0e74df80
.word 0x7f9a2ace
.word 0x3a08b919
.word 0x17fcdc15
.word 0xd70f631d
.word 0x3a300cac
.word 0x9cd9f508
.word 0x9c997a88
.word 0x73a9cb3b
.word 0x398bddb2
.word 0xf3cdca3c
.word 0x62c45b3c
.word 0x9641e84a
.word 0x19b62131
.word 0x9ad8216a
.word 0x0ab3034e
.word 0x311c721a
.word 0xa9be97f4
.word 0xb1417224
.word 0x3f8c514d
.word 0xa8e8533b
.word 0x97c79d6f
.word 0xb044b786
.word 0x6718600c
.word 0x0e644197
.word 0x2408bc0b
.word 0x08bf8537
.word 0x83cb838a
.word 0xa1a583ce
.word 0xf86fb997
.word 0xa3309805
.word 0xc19c5a90
.word 0x30890dd4
.word 0x54f6f478
.word 0x4a96a723
.word 0x2401b424
.word 0xace7fb5f
.word 0x3c169ce1
.word 0x559b7bc5
.word 0x49a44887
.word 0x1cb2a0b6
.word 0x30385f34
.word 0x13bcb9b4
.word 0x291f1436
.word 0x483ac336
.word 0xba698d1c
.word 0x049bdc89
.word 0x3ac3baa8
.word 0x5900dc70
.word 0xfb7b9898
.word 0x62397ea9
.word 0xb8917303
.word 0x5f41b918
.word 0xf3c84816
.word 0x5e7cc307
.word 0x969a41bc
.word 0x2395a471
.word 0x13151771
.word 0xe67f7bd6
.word 0xea9a2eb2
.word 0x8656b54e
.word 0x4e40215a
.word 0x405212a3
.word 0x9706bc62
.word 0xbf72a6b5
.word 0x35051ddb
.word 0x74c22447
.word 0x001de35f
.word 0x179246f9
.word 0x59f3db00
.word 0xf034f4dd
.word 0x9aa5942b
.word 0x52a8388e
.word 0xc510720d
.word 0x54048776
.word 0x63c4b242
.word 0x308b91d3
.word 0xa4e85ed1
.word 0x71f81308
.word 0x042fa2db
.word 0x14134669
.word 0xc9ac3ab7
.word 0xd9b66267
.word 0x66fe4629
.word 0x7ff47b5e
.word 0xe2271122
.word 0x200d6133
.word 0xca2c5257
.word 0x1699477f
.word 0x8aa00f0c
.word 0x6ea8457c
.word 0x9573e3d9
.word 0x91a294d5
.word 0x09c1369d
.word 0x0412f9dc
.word 0x5cb79e20
.word 0xbd49d2c0
.word 0x1701b50d
.word 0xec6b8e09
.word 0x48993c7c
.word 0x560d9c5a
.word 0x69f0391a
.word 0x87bb744b
.word 0x439fa248
.word 0x93cf6428
.word 0xc4e52f61
.word 0x8a464359
.word 0x17f63421
.word 0xb08c9f5d
.word 0xe01a93eb
.word 0xf5797392
.word 0x24d96aa2
.word 0x853a307c
.word 0x966a5a68
.word 0x43f1591f
.word 0x59bfa6a3
.word 0x6b533ca4
.word 0x5b4a6104
.word 0x8676e66d
.word 0x83d77b90
.word 0x9f05830e
.word 0x921c38be
.word 0x17fb19c4
.word 0x3fb0ab15
.word 0x480c1a83
.word 0xa470ae77
.word 0xa723295a
.word 0xa1c7c84f
.word 0xb68b9dc7
.word 0x76b702bc
.word 0x9d530980
.word 0xb376c92a
.word 0x08836551
.word 0xce27a07c
.word 0xa3af83db
.word 0x12ebb12c
.word 0xc3b07962
.word 0xd0e67ed3
.word 0xac90f240
.word 0xeacd0089
.word 0xb7e235d1
.word 0x1eaace08
.word 0x16840b67
.word 0x60e2795c
.word 0x9f342434
.word 0x5296878b
.word 0x28247299
.word 0x00762cab
.word 0x56851867
.word 0x2a9f6acc
.word 0x1759a425
.word 0x99846463
.word 0x8a4ba4d7
.word 0x6422bfcb
.word 0xe9bfc8eb
.word 0x5e25a5be
.word 0x710621b9
.word 0x9c94c074
.word 0x47387ca4
.word 0xe7446443
.word 0xad5b1865
.word 0x0204952e

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
