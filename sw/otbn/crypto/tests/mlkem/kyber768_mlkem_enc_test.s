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
.word 0xcb1855fe
.word 0x92e5dfe8
.word 0xd26b9496
.word 0x14a03569
.word 0x7c2b3abe
.word 0xc320a473
.word 0x42f9a039
.word 0x096d3737

.globl ek
ek: 
.word 0xada4aa45
.word 0x39bd10b1
.word 0xb490b97b
.word 0xee73f5d8
.word 0xbb9ecee1
.word 0xae857514
.word 0x210c7280
.word 0xc12f96cb
.word 0x5fe15f70
.word 0xd7b3f1f5
.word 0xc4665b60
.word 0x91bb11a7
.word 0xec3d2af1
.word 0x0bfcb192
.word 0x9e9aa53f
.word 0x0eb20983
.word 0xd4884d89
.word 0x89cbf00b
.word 0x9fce5333
.word 0x8350cd75
.word 0x51212b49
.word 0x2eceba77
.word 0x334f9a33
.word 0xb7158b58
.word 0x0636f36a
.word 0x0af02ad4
.word 0x55857e94
.word 0x9d03ab9f
.word 0xa97c93cc
.word 0x28ec071a
.word 0x1830175e
.word 0xb69c04e7
.word 0xc244b707
.word 0xc0cad89b
.word 0x80e098e4
.word 0x2e10b503
.word 0x9b20927c
.word 0x7c45a4e0
.word 0xa77622c2
.word 0x5f523bf3
.word 0x26286428
.word 0x0b643c9f
.word 0xb1203616
.word 0xcbbc2e85
.word 0xbc6ba033
.word 0xaebfacb5
.word 0x597ea41c
.word 0xa8862f1f
.word 0x3c5e734e
.word 0xa5ef069c
.word 0x71c458c7
.word 0x6d863be5
.word 0xe6ea2974
.word 0x0dea4e34
.word 0x32210312
.word 0x40ef145a
.word 0xb3b0d72f
.word 0xd9648673
.word 0x101e2d46
.word 0x66d82654
.word 0x1fa6e1bb
.word 0xa796b258
.word 0x4a29b181
.word 0xc0a60936
.word 0x246756e2
.word 0x41055cc9
.word 0x1d1c77bd
.word 0x188056aa
.word 0x837002bb
.word 0xe9830c82
.word 0x89c94319
.word 0xb554dfa9
.word 0x09a6fa6d
.word 0xe8f18809
.word 0xcaec82a1
.word 0x241cc294
.word 0xe28dbe9a
.word 0x96fb07b1
.word 0xed4c3394
.word 0x1682a863
.word 0x1348a85b
.word 0x9f7f2342
.word 0xb6fb6571
.word 0x62ba1b1a
.word 0xf94858d4
.word 0xb260bdb1
.word 0x0c06771f
.word 0x41624b1c
.word 0x2c3c4ba1
.word 0x09326b33
.word 0x927d6b43
.word 0x49e39e39
.word 0xbc15c886
.word 0x134f4891
.word 0x08c09a49
.word 0x1964278a
.word 0x66a186db
.word 0x1cd58152
.word 0x741031c8
.word 0x1f9f3996
.word 0x903c2e76
.word 0x905b5c94
.word 0x397c319f
.word 0xd7102534
.word 0x23333b2e
.word 0xde453b03
.word 0x1610b910
.word 0x2807de04
.word 0x3b2167b1
.word 0x3504b95c
.word 0x3c91385f
.word 0x4e9d465a
.word 0x80b36955
.word 0xb3a59911
.word 0x14b009ae
.word 0x718c9d2a
.word 0x52b9d88b
.word 0x5cadc3ff
.word 0x442779d3
.word 0x9fd8f56f
.word 0x8e0f15e9
.word 0xb2ce3143
.word 0x75b51e01
.word 0x1c767b2d
.word 0x93b22268
.word 0x3875d580
.word 0x4d1412b0
.word 0xe56e3593
.word 0xcebbb33d
.word 0x01b30226
.word 0xbc247861
.word 0x6fd47a6f
.word 0x023470e0
.word 0xc4546a16
.word 0x8125143d
.word 0x77271b65
.word 0x92692829
.word 0x8140c077
.word 0x036a39bd
.word 0xc75b6ef1
.word 0xbf859160
.word 0xa863fcd2
.word 0xb935b153
.word 0x374ae04b
.word 0x31a0b8f2
.word 0x57093c9b
.word 0x16d42364
.word 0x4c3eacd3
.word 0x06c56fc9
.word 0x6a204d0b
.word 0xb46299b7
.word 0x61344434
.word 0x05f05091
.word 0x4c496c3f
.word 0xe2f87f72
.word 0x51b48760
.word 0x9273c95a
.word 0x54b8cb5c
.word 0xb780215f
.word 0xdea5577e
.word 0x63c629c0
.word 0x05e579bb
.word 0x4e6b75b7
.word 0xa8bd3667
.word 0x39ac6ac3
.word 0x9b42a863
.word 0x6a113c13
.word 0x28b26650
.word 0x5c7cf588
.word 0x1b08cfa5
.word 0x9896fa5b
.word 0xdd4380d5
.word 0x021a0200
.word 0xc99a7922
.word 0x2431351e
.word 0x72447b27
.word 0x6a2316b3
.word 0xa18fdbb8
.word 0xba030628
.word 0x6f4adab3
.word 0xd633b8e2
.word 0xe1da7300
.word 0x41d33dcd
.word 0xbb911be7
.word 0x63329880
.word 0x8ff8f418
.word 0xa750d52a
.word 0x05307e10
.word 0x90167390
.word 0x36b44623
.word 0x7129bfa1
.word 0xb430f002
.word 0xc6481218
.word 0xaa3e929b
.word 0x1c953b42
.word 0x0c47a0e4
.word 0xb4e72196
.word 0xbed74896
.word 0x624ed82e
.word 0x43ab6cf4
.word 0x0bd6351a
.word 0xb59953bc
.word 0x9b6c65c6
.word 0xa1695460
.word 0xfb1c64da
.word 0x24036ea9
.word 0x2a9a918f
.word 0x5912ab4f
.word 0x95192b47
.word 0x73c93707
.word 0x9c5c67a8
.word 0x215d3ae9
.word 0x09311592
.word 0x0621ca73
.word 0x11913bc4
.word 0x24cacf68
.word 0xd013277f
.word 0xd2408b46
.word 0xcb019b82
.word 0xc926c5b5
.word 0x6b0a89f3
.word 0xaf3b4e85
.word 0xa586b860
.word 0x92673f9b
.word 0xc916b941
.word 0xdab2cc18
.word 0x71a83a94
.word 0x0fd53d28
.word 0x297ad4e6
.word 0xf50436d2
.word 0x5f3b2e65
.word 0x7d7937f2
.word 0xbad9b959
.word 0x61a9788d
.word 0xbd8b05b2
.word 0x57711350
.word 0x11a2663c
.word 0xd5a1c1a6
.word 0x298b613c
.word 0x8d60e1cd
.word 0x81254bb9
.word 0x21afc924
.word 0x28f45b86
.word 0xa4781699
.word 0xabb3abf7
.word 0x6f615b15
.word 0xe523e2c3
.word 0x4c1e87e6
.word 0x7fe9566c
.word 0x880d92a0
.word 0xb74102b3
.word 0x93447dad
.word 0x750141f1
.word 0xe8112852
.word 0x379c9951
.word 0xcb945c57
.word 0xb6156625
.word 0x5c28089b
.word 0x253dd6c6
.word 0xbbc57eea
.word 0x4e8618b6
.word 0x563e920c
.word 0x02cc5472
.word 0x5aeb2246
.word 0x570d85f4
.word 0x63ac85fa
.word 0x917afd2a
.word 0x9cc85255
.word 0x99e9965c
.word 0x644ac645
.word 0xd2c1f4be
.word 0x59b9bcc0
.word 0x14428f14
.word 0xf5c50567
.word 0x0209158a
.word 0x343a8c2b
.word 0x2b6ca6d0
.word 0x6cb5b440
.word 0x443c8c50
.word 0x05b2b393
.word 0x16a87772
.word 0x56747c14
.word 0xe186100e
.word 0xd6690014
.word 0x3cf5d585
.word 0xb721333e
.word 0x9b3fa647
.word 0xab4423cb
.word 0xffafc16b
.word 0x792f40a5
.word 0xc80ce47e
.word 0x5dbd35d5
.word 0xced5bc40
.word 0x247dc59c
.word 0x48d93e0a
.word 0x16106072

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
