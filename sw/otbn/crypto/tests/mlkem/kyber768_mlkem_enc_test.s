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
.word 0x2265b1f5
.word 0x91b7584a
.word 0xd8f16adf
.word 0xcd613e30
.word 0xc386bbc4
.word 0x1027c4d1
.word 0x414c343c
.word 0x1e2feb89

.globl ek
ek: 
.word 0x22cd6950
.word 0x49ddc2ab
.word 0x2bacfebe
.word 0x4c0a4bac
.word 0x56360c3b
.word 0x82f30874
.word 0xf34a66f1
.word 0x757c501c
.word 0x28fc451d
.word 0xa5b6b125
.word 0xc94d10c1
.word 0x71222509
.word 0x38c7309c
.word 0xb79390bc
.word 0x42573fac
.word 0xf49bf552
.word 0xf3bd3029
.word 0x013387ba
.word 0x1b2e7411
.word 0x316564fa
.word 0x78783ec7
.word 0x74adfbf3
.word 0x08cc056c
.word 0x4c3b36bf
.word 0xe276c8aa
.word 0x00b628b6
.word 0x9fd1c86c
.word 0x3f12f9d0
.word 0x36cdbab5
.word 0x2aea1eba
.word 0x9b2f2c6b
.word 0xd5846cca
.word 0xb5f2e795
.word 0xfd23a207
.word 0x67d61c1a
.word 0xac253494
.word 0xdbad94d6
.word 0x471e6992
.word 0xaf8b13a6
.word 0xef6da884
.word 0xcba90587
.word 0x7f63e0b2
.word 0x61861228
.word 0x7b7e1195
.word 0x4cca4c3d
.word 0x7c2e42fc
.word 0x92546be3
.word 0x2a1c9647
.word 0x75bdf852
.word 0x4cd38008
.word 0x5bc9c14d
.word 0xf36ef33f
.word 0x32b66140
.word 0x7703ff39
.word 0x770241fa
.word 0xf01a5b1a
.word 0xc69accc4
.word 0x688ca367
.word 0xe783abd1
.word 0x2d7af1b1
.word 0x2255f517
.word 0x8c746248
.word 0x6b253561
.word 0x586a5b65
.word 0x198474e0
.word 0x195491b4
.word 0xec008338
.word 0x39402d29
.word 0xa715fc90
.word 0xd338001e
.word 0x29e64900
.word 0x3265d0cc
.word 0x9d39c1a0
.word 0x3c6a4a22
.word 0x1d50d9a8
.word 0x3b87d17e
.word 0x916824f3
.word 0x1286c32b
.word 0xd36d57e9
.word 0x5754c122
.word 0x8fba243a
.word 0x01755ad3
.word 0x9aeb5d4c
.word 0x71768e64
.word 0x8f69fca2
.word 0x463ec133
.word 0xc2c14116
.word 0xda0571a0
.word 0x6296a9ac
.word 0x9fc7d593
.word 0xbd88aad9
.word 0x14a154b5
.word 0x6f9a6c49
.word 0x0d8d21c5
.word 0x975844c7
.word 0x4c0088b9
.word 0x7cae9b7d
.word 0x33cb3522
.word 0x06f20d56
.word 0xbf9719ce
.word 0xe1b11a69
.word 0x5765c660
.word 0x0424e6e6
.word 0xeabf0129
.word 0x02b32885
.word 0xc718b52e
.word 0xfa38c411
.word 0x05e16257
.word 0x873fdcd4
.word 0x3a0bbc34
.word 0x3066b3c7
.word 0x9b4a5be5
.word 0x16db7110
.word 0x82f60d0d
.word 0x54bbf079
.word 0xd26dcc02
.word 0x8838ac7c
.word 0xff235c49
.word 0x591c46b1
.word 0x74f70ab0
.word 0x1300687f
.word 0xd31702e1
.word 0xc8e24828
.word 0xf8aed213
.word 0xda344357
.word 0x8852969d
.word 0x807263f5
.word 0x4b8088a8
.word 0x7286f825
.word 0x8d74b3ae
.word 0x67090d45
.word 0x9f2a024e
.word 0xbb081251
.word 0x5cc188a2
.word 0x045b7858
.word 0xeb58239e
.word 0x4be54dc7
.word 0x268105bc
.word 0x9b8a82cc
.word 0xf53dc740
.word 0x5b7a91cd
.word 0x5fc1875c
.word 0x4746ae91
.word 0x0a830855
.word 0xeb526a83
.word 0x798cba88
.word 0x9559045e
.word 0xc04561e3
.word 0x5cad18c5
.word 0x8107903a
.word 0x326968fb
.word 0x8bd3a6db
.word 0x4422a3a1
.word 0x3c8e075e
.word 0x64534788
.word 0x0d600b9a
.word 0xb739288a
.word 0xfcb03eba
.word 0x330ba8ae
.word 0x89a829be
.word 0x265b617c
.word 0x2dfadac1
.word 0x5308d9dc
.word 0x009b4269
.word 0x2289bf58
.word 0x346994d1
.word 0xb610b531
.word 0xacec5e60
.word 0x907d7bd3
.word 0xd552a2aa
.word 0x40ab4c87
.word 0x27423a83
.word 0x544c20bb
.word 0xc565aa65
.word 0x3eae9848
.word 0xb1783363
.word 0xa700e974
.word 0x0c2e821b
.word 0x7189443c
.word 0x2e7bae1d
.word 0xc234c3b8
.word 0xf3595481
.word 0xacb074ae
.word 0x55325067
.word 0x9083aee1
.word 0x0ce89621
.word 0x5e6b88d3
.word 0xca0c7b51
.word 0x1862ac3a
.word 0x02b46a68
.word 0x347f5fa3
.word 0x31d9dfa0
.word 0xd07792d0
.word 0x60f20f46
.word 0xbebaeea1
.word 0x82377b70
.word 0xfaac6019
.word 0x9a383617
.word 0xcdbc18c3
.word 0x0a109bf6
.word 0xa1b36787
.word 0xba6ad26a
.word 0x23024823
.word 0xc19c8420
.word 0xee95968a
.word 0xb6916917
.word 0x976a551e
.word 0x9b9e24d2
.word 0x290b4a03
.word 0xa696a6b1
.word 0xc33b662a
.word 0xe3f79c60
.word 0xb2503385
.word 0x2355c985
.word 0xd4a95a96
.word 0x879c9ea7
.word 0xae9c454a
.word 0x59c32da5
.word 0x5c226e1f
.word 0x5f5c554a
.word 0x9c274dda
.word 0x033b6389
.word 0x055b5115
.word 0x15090205
.word 0x81a2c72d
.word 0x3faa5840
.word 0xd4a8283b
.word 0xa96a4d9e
.word 0x0140722e
.word 0xc12e8d94
.word 0x03cb194d
.word 0x41cc363a
.word 0x9b9b342a
.word 0xbae7cb7b
.word 0x60bbf5d0
.word 0x1c492329
.word 0xbd57a7a2
.word 0x40a522f8
.word 0xa4115770
.word 0x0017fb3a
.word 0x6179ac74
.word 0xba94bab3
.word 0x5db73318
.word 0x991265ff
.word 0xead06b88
.word 0x7892d3b0
.word 0xd21996de
.word 0x645e2963
.word 0x53fa9e82
.word 0x93a1f524
.word 0xa3d17312
.word 0xa5983da8
.word 0xdf5e201b
.word 0x2353a516
.word 0x14317696
.word 0x052a690c
.word 0x48378d09
.word 0x6802e3c0
.word 0xe78b3bf1
.word 0xe8ea76e9
.word 0xacb5c495
.word 0xb14f8a37
.word 0xe7efabb7
.word 0xb903cf79
.word 0x6603620f
.word 0x5a634e77
.word 0x66451023
.word 0x077d9574
.word 0x226820b2
.word 0x0e58ba33
.word 0x718c479d
.word 0x5c1d2375
.word 0x5489e23c
.word 0xbb2fc84e
.word 0x143169d8
.word 0x28e33e58
.word 0x041ee21f
.word 0xbc0d8ca0
.word 0x2c88beaf
.word 0x957c07d6
.word 0x563d3233
.word 0x036a2e84
.word 0x16657ac5
.word 0x92dccee9
.word 0xcf50c533
.word 0xa367a21c
.word 0xd6c03f11
.word 0x5d93a15d
.word 0x472339d5
.word 0xb73e5e3b
.word 0x21f7353d
.word 0x669677a2
.word 0xfd138627
.word 0xc9c08adc
.word 0xb31b15e9
.word 0x1d47dd8b

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
