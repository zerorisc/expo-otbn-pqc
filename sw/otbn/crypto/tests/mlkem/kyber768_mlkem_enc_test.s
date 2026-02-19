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
.word 0x3a096533
.word 0x5ed34fe5
.word 0xf658f7a7
.word 0x6018366c
.word 0x205738d1
.word 0x317017a6
.word 0xb46ee1da
.word 0x0b3510b0

.globl ek
ek: 
.word 0xfc2fd2fb
.word 0x731b4097
.word 0x6ff53c85
.word 0x9ccb64ec
.word 0xa6a0b673
.word 0x42cc062c
.word 0x2937dbc9
.word 0x96c579ea
.word 0x0c791426
.word 0x09a4dc65
.word 0x660b3c35
.word 0x20e5d7c7
.word 0x47a672ae
.word 0x3b610d11
.word 0xa07bc13d
.word 0x14c17773
.word 0x58f0760a
.word 0x39048053
.word 0x50be75ad
.word 0xb3a5b476
.word 0x6049953e
.word 0xb282a97d
.word 0x868142ba
.word 0x6796ce76
.word 0x90451c4a
.word 0x9ce95f01
.word 0xa9a7a8b3
.word 0x70c272df
.word 0x98149ad2
.word 0xa464cc32
.word 0xc71254ff
.word 0xe56d5597
.word 0x1db63996
.word 0x5e666002
.word 0x06cb5b9b
.word 0x1355e5c7
.word 0x532fe689
.word 0x5b509b56
.word 0x38c26a5c
.word 0x98669120
.word 0xb1b41c65
.word 0x8913f835
.word 0x25c43c5e
.word 0xfcd19007
.word 0x44d37ac6
.word 0xcc5bc152
.word 0xca231f6b
.word 0xa2710a75
.word 0x334e67da
.word 0x32510d77
.word 0xb0849a26
.word 0x30713743
.word 0xe99f7ef5
.word 0x2f98eba4
.word 0x6833868a
.word 0x64812e73
.word 0xa3745f34
.word 0xe7361108
.word 0x850514a8
.word 0x6d13e21d
.word 0xe3bdd491
.word 0x97da9a28
.word 0x2f53a271
.word 0xcb5c53da
.word 0xd0178050
.word 0x3362c8b1
.word 0xe1a0c893
.word 0x3b79b759
.word 0x3be3d885
.word 0x20cd8679
.word 0xe0088624
.word 0x55245fb6
.word 0x083e55af
.word 0x3a74ae42
.word 0x3344f43a
.word 0x4507728f
.word 0x8bd370c1
.word 0x0bc559c0
.word 0x26686a1f
.word 0xcc5daa7a
.word 0xc11038a0
.word 0xbf929093
.word 0x32d6b584
.word 0x4e94abb4
.word 0xf0cd769c
.word 0x24b7924c
.word 0xb1a7b70c
.word 0x74571c8f
.word 0x707ea2d8
.word 0x168a558d
.word 0xb9bb63fa
.word 0xc9235f44
.word 0x487c5cb1
.word 0xbb8d5b09
.word 0x20d271d2
.word 0x6142604e
.word 0x0f71c538
.word 0x349e7951
.word 0x33a8af82
.word 0xd6384096
.word 0x08d0a5ea
.word 0xb8a2b0cd
.word 0x20813498
.word 0xd52b4925
.word 0x15d1f8a0
.word 0xfd8df737
.word 0xfca809b4
.word 0xc2e68504
.word 0xcf06caf6
.word 0x529b185b
.word 0xb609f90a
.word 0x52b6212a
.word 0x81fa55e6
.word 0x92860839
.word 0x636a1b46
.word 0x8286726a
.word 0x3aace603
.word 0x9e5daa01
.word 0x43768540
.word 0x285b7f1d
.word 0xd53e9ab4
.word 0x2b766fc6
.word 0x441b642f
.word 0xad143ac0
.word 0x97558213
.word 0x9c79bf93
.word 0x62a246d0
.word 0xe219a2a7
.word 0x5f68044b
.word 0xfb174ac6
.word 0x192eb174
.word 0x9e41d364
.word 0x4961826f
.word 0x0cbc78ba
.word 0x46524a3e
.word 0x8d5f58c4
.word 0xd64f0b90
.word 0xc1d75d73
.word 0xd815180e
.word 0x5c843b52
.word 0xc432d489
.word 0x9dcfa27e
.word 0xf658602b
.word 0x0bdbb6bf
.word 0x241b7160
.word 0xaa7f6c78
.word 0x27f7055a
.word 0x58306c07
.word 0x28601cb8
.word 0x58e71a94
.word 0x05a9354b
.word 0xeada6712
.word 0x2dc3b7cd
.word 0x8bc457aa
.word 0x13882d99
.word 0xb339646f
.word 0xae1f3b40
.word 0xe0700a59
.word 0xa897eb9b
.word 0x51235652
.word 0x26869784
.word 0x54997948
.word 0xaf2fd374
.word 0x2a8c1adc
.word 0xcc649e18
.word 0x7b90859c
.word 0x81257b09
.word 0x065a926c
.word 0xf4b9354b
.word 0xaa092654
.word 0x13250879
.word 0x49a1905f
.word 0x10ba70a4
.word 0x23070d25
.word 0x62b5c1b2
.word 0xaa88377c
.word 0x897b613d
.word 0xe2b5bc97
.word 0xa3726049
.word 0xb9f5bf36
.word 0xbb4289a9
.word 0x32ba8425
.word 0x782b741b
.word 0xdbb4033f
.word 0xd79a11c0
.word 0xaf497a24
.word 0xd8157a9c
.word 0x34be0011
.word 0x7db8bf8b
.word 0xaa274cbc
.word 0xd01d37ab
.word 0x14cc2f3d
.word 0xce5b9681
.word 0x447c33c7
.word 0x41136250
.word 0x9c8419dd
.word 0x858d85b8
.word 0x74ea1ac1
.word 0xcf79815f
.word 0x0b387a2a
.word 0x61949c21
.word 0xf67d1918
.word 0x3a413bf6
.word 0xcac8789e
.word 0xfc140bd7
.word 0x3a224d52
.word 0x2d643471
.word 0x0e66599e
.word 0xe93d4a83
.word 0x5e709cb0
.word 0x59be0480
.word 0xb0988317
.word 0x0553ab21
.word 0x397af03f
.word 0x75018ed3
.word 0xa178ab6a
.word 0x0fa2c876
.word 0x57d056a2
.word 0xc2a40a6c
.word 0x7668a99a
.word 0xf00186a4
.word 0x23326e24
.word 0x892b2b94
.word 0xe9b40391
.word 0x92a13c8d
.word 0x32bb6bae
.word 0x350eb1c3
.word 0x1fd93558
.word 0xc3cd9705
.word 0xcc4b89dc
.word 0x73c60c0c
.word 0x9164a729
.word 0x676a2298
.word 0x0c0487a0
.word 0x99043bbd
.word 0x91d0b069
.word 0x32f985bd
.word 0x188cbb1b
.word 0x778a5480
.word 0x0b71ecbd
.word 0x618f3122
.word 0x08f933d9
.word 0x283404cb
.word 0xa9821386
.word 0x0bf10535
.word 0xa815f42e
.word 0xf4ce67fd
.word 0xb37908d7
.word 0x4177d62d
.word 0x46961bd6
.word 0xb94a5ff6
.word 0x4443d6c6
.word 0x1a9b74c7
.word 0xe1c43f59
.word 0x061b7b05
.word 0xe6adc491
.word 0x707b7d45
.word 0x08a7f20a
.word 0xab3568d3
.word 0x7814b199
.word 0x6635c248
.word 0xd573e960
.word 0x87b35177
.word 0x67e25b29
.word 0x6002a276
.word 0xa2731fa3
.word 0x2df7f9b3
.word 0x42bc141a
.word 0xa97b28aa
.word 0xc53c0581
.word 0x1423eb61
.word 0x5a6b76c0
.word 0xbe867b7c
.word 0xe2265374
.word 0x357d8cd1
.word 0xbc30a546
.word 0x3e282aa9
.word 0x523d447b
.word 0xad9cf60c
.word 0xc578d74e
.word 0x7a18b318
.word 0x3b681ac5
.word 0x3bcce352
.word 0x68bcb42b
.word 0x299cfc8a
.word 0x511cc3b3
.word 0xc4d816f8
.word 0x31a4df65
.word 0xf24a17fb
.word 0x315ac334
.word 0x7922fd59
.word 0x276c7b61
.word 0x01441b16
.word 0x54354b7d
.word 0x2de92442
.word 0x76227ba5

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
