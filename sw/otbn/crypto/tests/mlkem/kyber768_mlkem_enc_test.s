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
.word 0x27a30c34
.word 0xca6d7ab8
.word 0x2a08de8b
.word 0x6c736c9c
.word 0xfc551d12
.word 0x164745b3
.word 0xf160d146
.word 0xa83e1a89
.word 0xa722622a
.word 0x41933b1f
.word 0x6b5052d2
.word 0x3ff89a1d
.word 0x59a6b7b3
.word 0x12715748
.word 0x8dea3fa0
.word 0xec7b2a03
.word 0x6a0bcf58
.word 0xab5a9c3b
.word 0x878a9002
.word 0xdb4f2aeb
.word 0x8252ef36
.word 0xcc4462e0
.word 0x1acfc5c3
.word 0x955095ce
.word 0x110b934d
.word 0x029b0293
.word 0xb3f3c242
.word 0x7bbca8bd
.word 0xea0d4457
.word 0x1298ce90
.word 0x328a3210
.word 0xf6c601b4
.word 0x86caffa4
.word 0x4292918a
.word 0x4192ba46
.word 0x183049b3
.word 0x7f7ae883
.word 0xc740a407
.word 0x81a80460
.word 0x9bccca50
.word 0xc8c47b74
.word 0x4431986d
.word 0x881ae169
.word 0x65019b25
.word 0xca6b13b5
.word 0x24c20748
.word 0xb1b14705
.word 0x47d52589
.word 0xb00e64ca
.word 0xf22b0f60
.word 0x4e20f3b1
.word 0x9658488e
.word 0xd20a9135
.word 0x35480d90
.word 0x167b7bdf
.word 0x4c292f57
.word 0x3f8900ae
.word 0x2d6635be
.word 0x44346594
.word 0x5cc34401
.word 0x395b49ce
.word 0xe7bf6829
.word 0x63ca292e
.word 0x23c9f897
.word 0x89499187
.word 0x08a51f02
.word 0x7441c8f4
.word 0xb5608d18
.word 0xcce165b6
.word 0xc56647f0
.word 0xe47b116c
.word 0x797b8bad
.word 0x4c2359c2
.word 0x8273a5f4
.word 0x69063c0c
.word 0xf83ca332
.word 0x0a610914
.word 0xbf930343
.word 0x9c163223
.word 0x3a43c5d7
.word 0x80a1327c
.word 0x789e82c1
.word 0xba7f3c87
.word 0xb8618217
.word 0x03081865
.word 0x33c8b7ea
.word 0x1ec95062
.word 0x72c5201d
.word 0x7636b957
.word 0x52595ca2
.word 0x0c87d248
.word 0x1ab190d9
.word 0x90d0f136
.word 0xc19249ed
.word 0x30218dba
.word 0x9986477a
.word 0x209442cf
.word 0xc46c5a16
.word 0x313c3b89
.word 0xb21d30b4
.word 0x11ba5fb9
.word 0x8590357b
.word 0xf9505bbe
.word 0x6af23dd7
.word 0x66fac960
.word 0x1e0a9281
.word 0xf5563949
.word 0x7a3ad231
.word 0xe24dbaef
.word 0xc2ff5db9
.word 0x233b3d6d
.word 0x0548d304
.word 0xf7f1110c
.word 0xa96cca1c
.word 0x36be8019
.word 0xf758b1d4
.word 0x25995fc5
.word 0xcda83b1d
.word 0x53cb07c8
.word 0x7c1622c0
.word 0xc8a94c5a
.word 0x71973e20
.word 0x6947b711
.word 0x9ba718b0
.word 0x485da849
.word 0x5ee6062d
.word 0xa374a791
.word 0x1285aab5
.word 0xbe87fbbb
.word 0x1eafa50f
.word 0x729a38a6
.word 0x0466d3ba
.word 0x7a3a8476
.word 0x37ab3b15
.word 0x4f99b7ce
.word 0x535dc5c6
.word 0x74df13f0
.word 0x98897d12
.word 0xef3612b2
.word 0x86cf78a6
.word 0x90924546
.word 0x4f00d698
.word 0xb0a667f9
.word 0x7e782297
.word 0x29a3171b
.word 0x22f8791a
.word 0xc9b59684
.word 0xae3101c7
.word 0x387b9f83
.word 0xc050b558
.word 0x6d60554d
.word 0xb98e2ed0
.word 0x7232dc39
.word 0xdca91252
.word 0x953359d4
.word 0x40c6c11d
.word 0xd34c69e5
.word 0xc8a7487c
.word 0x5814ce2f
.word 0x6abb10e9
.word 0xa02b7cb6
.word 0x406a5697
.word 0xc5855739
.word 0x168cce21
.word 0xcec43d2e
.word 0x9ecec253
.word 0x831cb760
.word 0xa80bf865
.word 0x81b1b955
.word 0x42147203
.word 0x0c19825e
.word 0x4e714b87
.word 0xf41022c2
.word 0x8e8475ce
.word 0x67bcbcea
.word 0x009885d1
.word 0xa1591250
.word 0xabae1558
.word 0x0baca6d4
.word 0x9ba1036e
.word 0xdc0653c7
.word 0xc31c9df3
.word 0x7388f30e
.word 0x43bdd48a
.word 0xa2b73998
.word 0x0b548b0b
.word 0x6ac7d640
.word 0x6443053a
.word 0x69684517
.word 0x9015e12a
.word 0xcc8b5be0
.word 0x9cb2a878
.word 0xfe289383
.word 0x4491abb3
.word 0x36461654
.word 0xb0913c97
.word 0x32946a8a
.word 0xbffa9324
.word 0xfa4f67f4
.word 0x28a479a0
.word 0x0eb17832
.word 0x229823c8
.word 0xe1fd87a5
.word 0x8f1b427b
.word 0xfd0a4601
.word 0x594c41cb
.word 0x36a03140
.word 0xf547725d
.word 0xba504ef2
.word 0x599bc9b9
.word 0x6e86eaa7
.word 0x06c758e7
.word 0x30f3680a
.word 0xcabef6fd
.word 0xf0b47d56
.word 0x10b6e14d
.word 0xc37b3367
.word 0x941da1b4
.word 0x2c63ec07
.word 0x020658cd
.word 0xc854a234
.word 0x0324f5b2
.word 0x76cf924c
.word 0xcbd2b2b1
.word 0x4995121a
.word 0xc00bca1f
.word 0x883e22e3
.word 0x38f94c67
.word 0xee6ec861
.word 0x3a972d41
.word 0xb77b1591
.word 0x8778250a
.word 0x37a686c7
.word 0xc6b7c09e
.word 0x2920c4b5
.word 0x04ec4aa2
.word 0x2f57ff30
.word 0x085e97db
.word 0xc8028ca9
.word 0x182c652f
.word 0xd75ecca4
.word 0x10493dd0
.word 0x031a0995
.word 0x9c8df5c0
.word 0x7323b6b4
.word 0x3fe16dce
.word 0xfa1f8817
.word 0x600ba113
.word 0x25ccc760
.word 0x0bb2f234
.word 0xb05bb8bc
.word 0x58e2e14d
.word 0x676e5ac4
.word 0x0cc8b158
.word 0x6e270e9c
.word 0x1099fc7e
.word 0xc3096d60
.word 0x4c6c1c21
.word 0x5bc49482
.word 0x6ac36f58
.word 0x02789c81
.word 0x821eb635
.word 0xf75c30db
.word 0x1b70cc99
.word 0x2e47e710
.word 0x3ab52487
.word 0x8bf31bb6
.word 0x771436d9
.word 0xe663992a
.word 0x92421933
.word 0x607d684f
.word 0x8c548067
.word 0xa5301ec1
.word 0x85a420c5
.word 0x02ff5e92
.word 0xb869023d
.word 0x98709783
.word 0x40bc4152
.word 0xa390dd22
.word 0xa8287aed
.word 0xa61f8336
.word 0x1f655209
.word 0x337728da
.word 0xc1332a74
.word 0x7d92af34
.word 0x54bc977d
.word 0xd9b917c4
.word 0x9e0b358d
.word 0xe0b6eeb5
.word 0x289eee62
.word 0x798f8604
.word 0x5f3aeef2
.word 0xbee15237
.word 0xdd2acbd5
.word 0x39c0f97f
.word 0xd94755da

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
