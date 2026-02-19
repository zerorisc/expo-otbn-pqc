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
.word 0x7687a66e
.word 0x9cfbac6e
.word 0x5f915ef0
.word 0x4462ebfc
.word 0x237751aa
.word 0x2fa73207
.word 0xddd6ff55
.word 0xad38835e

.globl ek
ek: 
.word 0xbdb232af
.word 0xf1485e37
.word 0x1e52327c
.word 0x2e1070b7
.word 0xdca4194a
.word 0x84a5e5c7
.word 0x95b6f53d
.word 0x83e1a354
.word 0x92046c91
.word 0x81c1b733
.word 0x97361373
.word 0x9ae24a39
.word 0xd0c955ce
.word 0x5a31b936
.word 0x35d74597
.word 0x01765c24
.word 0x78c3a4db
.word 0x6b522e4c
.word 0x57aee90a
.word 0xf4f62c06
.word 0x5cdbebbb
.word 0xefa1eac3
.word 0xa2e82578
.word 0xb6a46a93
.word 0x997c568d
.word 0x15a86759
.word 0x0a87cf98
.word 0xcaa1e7c6
.word 0xc4353d07
.word 0x8603a0b7
.word 0xdba9c6b1
.word 0x7055028a
.word 0x6b70117c
.word 0x2194ca1f
.word 0xe2ecce0c
.word 0x6bdccb3b
.word 0xa03e37e0
.word 0xab876c21
.word 0xc49adaa7
.word 0xc24c785d
.word 0x9994a294
.word 0xae301e4a
.word 0xb4bc23f1
.word 0x00b61f20
.word 0x72b54d37
.word 0x72728638
.word 0xfb024906
.word 0x931bd832
.word 0x983728a0
.word 0xfa88b6e5
.word 0x15648144
.word 0xf58707d8
.word 0xab20b64a
.word 0x5834fb34
.word 0x8f37c110
.word 0x84f34358
.word 0x0642c299
.word 0x847430df
.word 0xc80f98aa
.word 0x01165aad
.word 0xa6bc897c
.word 0x5467c326
.word 0x1dfcee09
.word 0x58a55304
.word 0x09e6a7f5
.word 0x8625cec0
.word 0x3fa26a0d
.word 0x280c9d1c
.word 0x19a8c559
.word 0xd0b92abb
.word 0x409d3e90
.word 0x75d5b770
.word 0x1aacb902
.word 0xa41b1726
.word 0x248b8805
.word 0xfe9401bf
.word 0x1bea9931
.word 0x1f04f774
.word 0xa4326c15
.word 0x558c7859
.word 0x8113a258
.word 0xe38ce9f6
.word 0x3634a1d8
.word 0x4249b25b
.word 0x2926e656
.word 0x331c0211
.word 0x75260a9d
.word 0x7ca4c94f
.word 0xc2311923
.word 0x7c72f984
.word 0x8f1f1ac4
.word 0x63a72eb0
.word 0x1954c207
.word 0x1d89fc69
.word 0xa9ef9a71
.word 0x2d919645
.word 0x131a86c3
.word 0xd1421337
.word 0x1a4985bf
.word 0x9550c8ee
.word 0x30c7907a
.word 0x0dda6e8b
.word 0x124ce2bd
.word 0xe6ef5672
.word 0x59510bab
.word 0xf1b4723a
.word 0xc595b081
.word 0x92d7f2a1
.word 0xa7abb202
.word 0xe51a8a92
.word 0x92d03ba6
.word 0xf098facd
.word 0x36f356b6
.word 0x9cb4704e
.word 0x411267ca
.word 0x43907371
.word 0x37e7a908
.word 0xcbaf0c5f
.word 0x30f5bc81
.word 0x6b24cf57
.word 0xcdc62122
.word 0xb9529764
.word 0x56288e54
.word 0xde9b9ced
.word 0xe50a38b7
.word 0x042a80ca
.word 0x998fc6c3
.word 0xb33f8247
.word 0x2973e124
.word 0xc0323a39
.word 0x1bc5ca21
.word 0xb535bf65
.word 0xfd15e4dc
.word 0x09facd68
.word 0xac2aa3ae
.word 0x381cca20
.word 0x16e745e4
.word 0x4b1847a2
.word 0x2d1b7990
.word 0x1151ccc4
.word 0x53b82e4a
.word 0x754b297f
.word 0xc6ebc343
.word 0x9e24822a
.word 0x02bf70af
.word 0x47ed7b7c
.word 0xa7520492
.word 0x467f2aaf
.word 0xc274ae27
.word 0x669b93c0
.word 0x089315d2
.word 0x22b41af6
.word 0x876a7eb0
.word 0x0dcf7006
.word 0x89f06461
.word 0x4876ba62
.word 0xae4aecf6
.word 0x21ef5c68
.word 0x590c058d
.word 0xcc52a076
.word 0x861c17c4
.word 0xcb63af2a
.word 0x1b08ba63
.word 0x7479c923
.word 0x7431300e
.word 0x7aaafc57
.word 0xdaf58552
.word 0x3aa2bcab
.word 0xb2b2d225
.word 0xc2765512
.word 0xb1d77cc5
.word 0xc8aa3a89
.word 0xc8583812
.word 0x980bdbc1
.word 0xd51c32f3
.word 0x4bc3b0a5
.word 0x1870d16d
.word 0xb99f445b
.word 0x930199e9
.word 0x4202d167
.word 0x8d519bc4
.word 0x09840a92
.word 0xb5c7c6a1
.word 0x1072e542
.word 0x672d97d1
.word 0x4b105dc5
.word 0xde09c830
.word 0x21861db8
.word 0xca90854e
.word 0x3e4e1bea
.word 0x4af0cf1b
.word 0x36869518
.word 0xdd3ed422
.word 0x23d43197
.word 0xc07b2b9d
.word 0x11c92a74
.word 0x00af3401
.word 0x9063b587
.word 0xc87ba84c
.word 0x16219354
.word 0x52485abe
.word 0xa129c2f8
.word 0x0ba9c1d2
.word 0x28db7236
.word 0x60aedb23
.word 0x15e406f7
.word 0x199a035e
.word 0xe945a06e
.word 0xc05ba894
.word 0x8c048a12
.word 0x2d50eb5b
.word 0x7130a832
.word 0x92706b6f
.word 0x6a297127
.word 0x4c82cb23
.word 0x931b2206
.word 0x115487c4
.word 0xf4306260
.word 0x6b69d162
.word 0x1a965358
.word 0x5aaa8720
.word 0x322871ab
.word 0xd3adbb0e
.word 0xd40bc467
.word 0xbba8437a
.word 0x1e89ccfb
.word 0xd35ec7ac
.word 0x134767ab
.word 0xdf7fe7bc
.word 0x41f27299
.word 0xb91348b7
.word 0x743e4c36
.word 0x7880b130
.word 0xa5e7861f
.word 0xdf860232
.word 0x8063ba17
.word 0xa9c8b732
.word 0xdb3a16dd
.word 0xf1d7a316
.word 0x40176405
.word 0xb05e3cb2
.word 0xe37e07c0
.word 0x2bc6b961
.word 0x7f69c88f
.word 0x7bc584e8
.word 0x97f61085
.word 0x9819389d
.word 0xa0e36670
.word 0xcd01aac6
.word 0x74be9885
.word 0x11753b51
.word 0x31790d93
.word 0xf397d77f
.word 0x1a6f265a
.word 0x1ff3c81f
.word 0xd4409af5
.word 0x84fe5756
.word 0x133782cd
.word 0x41821698
.word 0x541d4f75
.word 0xcb97b58d
.word 0xee83e478
.word 0xd42c17c5
.word 0x01748645
.word 0xcf2b361a
.word 0x11099485
.word 0x47617f3d
.word 0xd23ec9ba
.word 0x3a177192
.word 0xbd3ced22
.word 0xc36fa2fe
.word 0x646a4e69
.word 0x49da923d
.word 0xb92a7911
.word 0xf99cc597
.word 0xb955a41a
.word 0x8ebe9c2b
.word 0x36c374a1
.word 0x100303bc
.word 0x023e903f
.word 0x038624cc
.word 0x3a45e618
.word 0x618f5ca0
.word 0x710e5b67
.word 0x4cb490b5
.word 0x4656177f
.word 0x18223e42
.word 0x02c193b1
.word 0x620777c5
.word 0x1107ba3b
.word 0xcc274999
.word 0x00ba4906
.word 0x448c58f4
.word 0x1c934228
.word 0xe66b02e6
.word 0xf3897eb6
.word 0x0698ebce
.word 0x01325074
.word 0x76f98601
.word 0x0942f6a1
.word 0x1d9d75ac
.word 0x0a3a3941
.word 0x5cb65e43
.word 0xd0637839
.word 0x23568fd4
.word 0x4e8a3927
.word 0x306ec686
.word 0xb55c1f1b
.word 0x540a6b33
.word 0xe283b045
.word 0xb95a0443
.word 0x51b0b502
.word 0xa96cdc25
.word 0xd46d1b55
.word 0x719bb5b8
.word 0x8809bb8a
.word 0x796f5b85
.word 0x1c1cc81b
.word 0xbc621ace
.word 0xe4e0aa15
.word 0xcd5c1910
.word 0xee0ffb5c
.word 0x008c9484
.word 0x1a3ae66b
.word 0xc09542b6
.word 0x48b314c8
.word 0x43232509
.word 0xe57c70c1
.word 0x8b896bb5
.word 0x3cc77359
.word 0xc00fe7a7
.word 0x85d461e9
.word 0xb06a2c41
.word 0x135ae47b
.word 0x31e66eb8
.word 0x74f8c372
.word 0xeab9a8f2
.word 0xb515c5fb
.word 0x09b2139e
.word 0x0bb54910
.word 0x97435683
.word 0xb089ae3b
.word 0x7e9289b2
.word 0xc82188f0
.word 0x4d088815
.word 0x2420091c
.word 0xa173a156
.word 0x2096aa53
.word 0x3e3febae
.word 0xe373a3b2
.word 0x7018ac84
.word 0x2abedcce
.word 0xc20fca43
.word 0x01c04db9
.word 0x0dbd2519
.word 0x756da321
.word 0x46b45365
.word 0x8273ec57
.word 0x1941b820
.word 0x9ff90752
.word 0x77ab1841
.word 0xd953ca53
.word 0xb60aa318
.word 0xdc06f988
.word 0x85362e11
.word 0x4833884c
.word 0x179ec769
.word 0x1bd4a802
.word 0x7155940c
.word 0x0a19a1e2
.word 0x5babbc82
.word 0x8701fea0
.word 0xe2a635fc
.word 0xb3decc71
.word 0x9a9aca50
.word 0xf40e7cab
.word 0x12d73978
.word 0x1ff4568f
.word 0x0152648a
.word 0xfca2539b
.word 0x6f06e728
.word 0x517c6aed
.word 0x4ae81eec
.word 0x377bef6e
.word 0x04e786e3
.word 0x2a4eb33a
.word 0x01dc345f
.word 0x30aa427b
.word 0x12d788c8
.word 0x969be1d9
.word 0x1cfb21cc
.word 0x8f5da10f

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
