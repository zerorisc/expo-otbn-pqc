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
.word 0xf4bea973
.word 0xdcf4bb99
.word 0xf2a4d27b
.word 0xd95bafc8
.word 0x0e7a269f
.word 0x177219d3
.word 0x15ba2bdd
.word 0x5c6e4337

.globl ek
ek: 
.word 0x50bfd21e
.word 0x12c86a12
.word 0x8339856b
.word 0x6367676d
.word 0x4c8030fb
.word 0x70a9884c
.word 0x8a21d0c1
.word 0x08a962a9
.word 0x1271db0c
.word 0x1c20155b
.word 0x953b9628
.word 0x0ad9da7d
.word 0xabc504a8
.word 0x616b6846
.word 0x3fb07988
.word 0x4fa5375b
.word 0x916d1ca6
.word 0x04b9316e
.word 0x4b40d214
.word 0x43481432
.word 0x5b189c8a
.word 0xe92ea1e6
.word 0x82be50f8
.word 0x1de74079
.word 0xb9443630
.word 0x22683e28
.word 0x308306b9
.word 0x42772a48
.word 0x179315c2
.word 0x0a499e56
.word 0x5739c7d5
.word 0xb8d339a0
.word 0x89db985b
.word 0xdc79c406
.word 0x302e4679
.word 0xaa2ae136
.word 0xb427358b
.word 0x84e2be08
.word 0x22e71725
.word 0x8eced53f
.word 0x85e51e32
.word 0xca42e88b
.word 0x9e1478c5
.word 0xac179d98
.word 0xa541c76e
.word 0xa43b2a32
.word 0x99d85922
.word 0x1535ce10
.word 0x53014830
.word 0x6a5833c5
.word 0x476330c0
.word 0x371ec9a3
.word 0x20f654f9
.word 0x3842a81b
.word 0xcb98bc45
.word 0x3c184251
.word 0xc62cce76
.word 0x6746160d
.word 0x80b7b186
.word 0xc79107a7
.word 0x280f722a
.word 0xa2f7b3f6
.word 0x7ff21432
.word 0xb900d981
.word 0x401e0687
.word 0x4a09ba56
.word 0x7c114c3f
.word 0x3146c4f5
.word 0xc4db08bf
.word 0xf401eaeb
.word 0x57d89fe2
.word 0x2826223e
.word 0xb2631816
.word 0x001ebb7a
.word 0x01b94ba9
.word 0xce07d7a4
.word 0x817c3be4
.word 0x44d8746a
.word 0xf4b38b3e
.word 0x9a8f86b6
.word 0xae78f788
.word 0xbda9fb39
.word 0x4c7a9a8a
.word 0x7c3002a1
.word 0x0413ab4f
.word 0x218b90bc
.word 0x95dc999f
.word 0x8b30e2b3
.word 0xd9113167
.word 0xa58607a7
.word 0x0247c29e
.word 0x86f74380
.word 0xb3c23cc7
.word 0x3fc6d5aa
.word 0xc2b92b79
.word 0xa8aaec79
.word 0xc326ea8f
.word 0xb31f2532
.word 0xadb913a9
.word 0x69b42048
.word 0xabfa846a
.word 0x5f3b7664
.word 0x66cf8116
.word 0x27e58378
.word 0x6c22d406
.word 0x3c4f2845
.word 0xe5c2719a
.word 0x8661b3c2
.word 0x473db6ec
.word 0xf2536734
.word 0xa39b3c85
.word 0x55cf5897
.word 0x711f6092
.word 0xa9cc867b
.word 0x31c97071
.word 0x28a3210c
.word 0x93f050ca
.word 0x93c9571a
.word 0x94c1343c
.word 0x6e5bb249
.word 0x3c66c465
.word 0xcbb9cfe2
.word 0x820c58c3
.word 0xdd929665
.word 0x23d74174
.word 0xa4501c55
.word 0x8b8f9ce1
.word 0xe521cf5b
.word 0x66b05633
.word 0x840817a7
.word 0x307c8f38
.word 0x08cc0a67
.word 0x33a55138
.word 0x44f296a6
.word 0x1a33b999
.word 0x538ba3ec
.word 0x765f7286
.word 0xc1133ac8
.word 0x2dbaa02b
.word 0x1b550f11
.word 0xaa1aab27
.word 0xffcf389a
.word 0x0c5d12d6
.word 0x3682b913
.word 0x2fa28aa2
.word 0x5c5c28da
.word 0x65c1841c
.word 0x195d12b3
.word 0xecab60cc
.word 0x364b60c3
.word 0x74250cd3
.word 0x4b8113e5
.word 0x65929878
.word 0x8215899a
.word 0x512dcf73
.word 0x7ff556b4
.word 0xaf03e591
.word 0x895682b5
.word 0xb6ea1e93
.word 0x49bb7c57
.word 0xa4098437
.word 0x816b1772
.word 0xedc8b102
.word 0xe2ad5953
.word 0x1337f116
.word 0x41724519
.word 0xbc5f332c
.word 0x872b869a
.word 0x09791c06
.word 0x40b64445
.word 0xc5e75d9c
.word 0x3781a592
.word 0x5c4b78c5
.word 0x04b7f248
.word 0xbb50c7e5
.word 0xbae1409b
.word 0x7d376078
.word 0x8825c69b
.word 0xc622a2a2
.word 0x283033c3
.word 0xaa8ba93a
.word 0xa92228c2
.word 0x5bd6a486
.word 0x478eb3ce
.word 0xa3153b27
.word 0x948c644a
.word 0xe82fd735
.word 0xb2bfa221
.word 0x84b1243c
.word 0xa59bf523
.word 0x258c9fc8
.word 0x64124c97
.word 0x5f5d204c
.word 0x70d466d2
.word 0x09835bc1
.word 0xf1b9e1e2
.word 0x750923c8
.word 0xc349c1ae
.word 0x9c3fa345
.word 0xe6987189
.word 0x054ab25e
.word 0x5b7d07e3
.word 0x8016be46
.word 0x79f5a988
.word 0x89ad9c46
.word 0x2758c613
.word 0x6a9cf69e
.word 0xfb4862d7
.word 0xd862b0f5
.word 0x6e35a11e
.word 0x1d38c058
.word 0x38500fc1
.word 0xa0c6a8a7
.word 0x3605a84a
.word 0xc843349b
.word 0x0ac04543
.word 0xa67874dc
.word 0x05ec41a4
.word 0x7462576b
.word 0xacbc176f
.word 0xbaf81e48
.word 0xa818edc3
.word 0xd575dab8
.word 0x17999648
.word 0x9ce17f4a
.word 0x7a578331
.word 0x86e16838
.word 0x35b9242d
.word 0xfb6bc57a
.word 0xb69b69ec
.word 0x51060958
.word 0xfc4af886
.word 0x89bb7a28
.word 0x5c990637
.word 0x2772ba53
.word 0xd1935562
.word 0x111508b8
.word 0xe729b3c1
.word 0xf2523754
.word 0x8524abcb
.word 0xa63c87fb
.word 0xc4a8beac
.word 0x664c6164
.word 0x2581f694
.word 0x105d80b5
.word 0x9a8cc161
.word 0x28be9a62
.word 0x08976ca5
.word 0x2f3101a5
.word 0x5021719d
.word 0xa1699360
.word 0x31170f80
.word 0x4aaaf6a2
.word 0xa0a54d32
.word 0x1b7cd1cc
.word 0xd97b4ba0
.word 0x5b38a91c
.word 0xa861ccc1
.word 0x1b6476b3
.word 0x70133711
.word 0x30d7de11
.word 0x6ea299a0
.word 0x16d38afc
.word 0xaab3ef35
.word 0x70b2f6c7
.word 0x049f47c6
.word 0x12f5c592
.word 0x889a2062
.word 0x52cf50b0
.word 0x51865632
.word 0x03a33519
.word 0x127cc468
.word 0x491b5651
.word 0xcd1e069a
.word 0x17e2b4b7
.word 0xb2eb30b9
.word 0xfbb0830f
.word 0xd824c138
.word 0x5b5b469a
.word 0xa15fc193
.word 0xe3d42ba2
.word 0x8ee98f10
.word 0x74ccc715
.word 0x92eb46d6
.word 0xcdc7f712
.word 0x58bce8ab
.word 0x8a45710a
.word 0x4d9af99f
.word 0x6fb51597
.word 0xa847c9d8
.word 0x4b5cb6ba
.word 0x32a053fa
.word 0xf22d1b26
.word 0x6f85e467
.word 0x3659e736
.word 0xc49405e0

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
