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
.word 0xe3299145
.word 0x18ce03f0
.word 0x723122c4
.word 0x6193069e
.word 0x28fd4b61
.word 0xab7cee66
.word 0x1136511f
.word 0x69847b16
.word 0x379c2606
.word 0xf565c181
.word 0x5170b0b6
.word 0x9554e12a
.word 0x10801beb
.word 0x16a58512
.word 0xc3f5d989
.word 0x9209d47e
.word 0x9cbf169a
.word 0x8cb14e28
.word 0xb3cac784
.word 0x79e90b10
.word 0x1c70d751
.word 0xdf74a9a0
.word 0xf3bf0bfc
.word 0xc5abcf87
.word 0x4392452d
.word 0x6b1836fb
.word 0x479bb069
.word 0x048395d0
.word 0x46323a75
.word 0xb62969be
.word 0x96043c2a
.word 0x76cf1116
.word 0x702155c0
.word 0xf73ca5f3
.word 0xf23a214b
.word 0x5839e68a
.word 0x291667cc
.word 0xf1133f05
.word 0x6257220f
.word 0xc185b1db
.word 0x9a042ae1
.word 0xca29f4cb
.word 0x77a52551
.word 0xf0d136a9
.word 0x7b3b0667
.word 0x7114c9e1
.word 0xe05d982b
.word 0x18ebf55b
.word 0x7364216d
.word 0x08aa8107
.word 0x52f0c19f
.word 0x3c0086ed
.word 0x803b5ef4
.word 0x12d0f0cd
.word 0xcc74fb5a
.word 0x5c7f41b2
.word 0x3da4b390
.word 0x08567b17
.word 0xbcff2f30
.word 0x6ce4819f
.word 0x530b9689
.word 0x092dc6a4
.word 0x250c1aa6
.word 0x2613e916
.word 0x942e9a59
.word 0x0b9504a3
.word 0xd0c14289
.word 0x02569c91
.word 0x6cb4c7b6
.word 0x233ffa13
.word 0x3b0855f5
.word 0xbe61892d
.word 0x468b556f
.word 0xd62d3bc6
.word 0x99c47a9a
.word 0x8e29d2ba
.word 0x7a939394
.word 0x9a3c6c50
.word 0x141e76f6
.word 0xa774bd58
.word 0xa7f1e491
.word 0xb5a3bbcb
.word 0x0b54729b
.word 0xaf8afeb6
.word 0xa9866718
.word 0xe0fcbc59
.word 0x4721a195
.word 0xde3ab899
.word 0xa492a067
.word 0x92824851
.word 0x0f8a43fe
.word 0x0aec01e7
.word 0xc0c6087b
.word 0xaf4d073a
.word 0xf461cbac
.word 0x6dc03d58
.word 0x4d56c951
.word 0x454dcc92
.word 0xa3ac721e
.word 0xd9851959
.word 0x11777c29
.word 0xa4020c9f
.word 0xfac416e1
.word 0x54847a70
.word 0x08eb95bf
.word 0x4a919242
.word 0x1c3f8670
.word 0xa31bccac
.word 0x47465a8a
.word 0xab0418fb
.word 0x294540a0
.word 0xaa8cc9cc
.word 0x8b17578c
.word 0x059b0c52
.word 0x0f47544c
.word 0x5b4a6ac6
.word 0x317c5447
.word 0x893947d6
.word 0xb9f525b2
.word 0x0138c2c7
.word 0xaf7a9c44
.word 0xa27c8930
.word 0x13881841
.word 0x828821c1
.word 0xa7f8ba28
.word 0x168ab8c8
.word 0xc742a4fa
.word 0xaad615a2
.word 0x5d62ffbb
.word 0x07b1f543
.word 0xe2d00ad9
.word 0xcd248498
.word 0x3c071314
.word 0xfb6c0761
.word 0x09631cc6
.word 0x78800336
.word 0xa34c5997
.word 0x4218dc98
.word 0x205272c7
.word 0x447a2349
.word 0x96b57218
.word 0x3e66e3c2
.word 0x31fb85ca
.word 0x24e094c1
.word 0xe37ce248
.word 0x4cfd861c
.word 0x5e0afd97
.word 0x3b29c24a
.word 0x72ad41f0
.word 0x585762b1
.word 0x3102b286
.word 0x1c75a449
.word 0x46b9a282
.word 0xa60726cc
.word 0xb806c794
.word 0xa2f7ca15
.word 0x90a1b6c3
.word 0x24f66195
.word 0x13280db8
.word 0x98330439
.word 0x1b92c419
.word 0x08240633
.word 0x7ca1764a
.word 0xe2aa5d97
.word 0x1bb8fe9a
.word 0x6c700922
.word 0x905200c0
.word 0x4b95e100
.word 0x36c83970
.word 0x986a7ebc
.word 0x37a86181
.word 0x0ec253da
.word 0xf2de2a20
.word 0x1a50dd8c
.word 0x229b14dc
.word 0xa98930d3
.word 0x12464e9a
.word 0x82a2d523
.word 0xa0310093
.word 0xbb769945
.word 0xd5a877ed
.word 0xe51273bb
.word 0x8c55fd8a
.word 0x19a8f317
.word 0xc9736a7c
.word 0xb9493e3a
.word 0x6b0ba612
.word 0xc8491d17
.word 0x12a115a0
.word 0x3130f890
.word 0xc430c950
.word 0x4bb56615
.word 0x086306b2
.word 0xb2331265
.word 0x7d610839
.word 0xa1cc31a2
.word 0x0458cc81
.word 0xcf09fdce
.word 0x0a8bfb42
.word 0x94cc2c31
.word 0x71b71b40
.word 0x67ba67c7
.word 0xf0dba41c
.word 0x3a48d500
.word 0x79c9a2d8
.word 0x0351cef2
.word 0x16a6374f
.word 0x2334992e
.word 0xace26b61
.word 0x788bab72
.word 0x346a75e2
.word 0x7cd02407
.word 0x83f19182
.word 0xa503ccc9
.word 0xd4c621c8
.word 0x41fb87b3
.word 0x62696623
.word 0xfbea96d3
.word 0x30e428cb
.word 0x7700d2fe
.word 0xf1628f44
.word 0x936c3f85
.word 0x00c7ca7a
.word 0xa9dc7e72
.word 0x1378f160
.word 0x149e09c6
.word 0xd6173303
.word 0xa461fc2f
.word 0xa86004eb
.word 0x720b61fa
.word 0x1e34e230
.word 0xbb8910b0
.word 0xf48b36f9
.word 0x3577f38f
.word 0x7db1627e
.word 0x76ed6cd4
.word 0x7d693b16
.word 0xdf092b74
.word 0xc0ef84da
.word 0x12867da1
.word 0xbb2ba83f
.word 0xc492cc89
.word 0x17d4fb00
.word 0xc6ba3899
.word 0x04793331
.word 0x56d2d227
.word 0x969073c5
.word 0x24182725
.word 0x207373ab
.word 0xae8ed568
.word 0x18a48f85
.word 0x29bc7918
.word 0x47247aef
.word 0xb0ad97b6
.word 0x6a5c0071
.word 0x755a30c5
.word 0xa326038a
.word 0x92f1aacc
.word 0xdd6de6c1
.word 0xd9901317
.word 0x18e28f4b
.word 0x4b789090
.word 0xdc2fbdda
.word 0x0b45e2a6
.word 0x11453229
.word 0x620fb280
.word 0x4011fa87
.word 0xa7a726e7
.word 0x94e94a05
.word 0x59735245
.word 0xcfc05277
.word 0x5449b662
.word 0x126b2b79
.word 0xb62586f0
.word 0x073c2675
.word 0x03b4a926
.word 0x912af229
.word 0xebe2a5e9
.word 0x0fd9f13e
.word 0xe86cb8aa
.word 0x2aa67ae9
.word 0x2f25a780
.word 0x5a0ae96f
.word 0x99dec67b
.word 0x6ea19f5e
.word 0x962684eb
.word 0x53d113a9
.word 0x61c7ec0a
.word 0x66ad0a3d
.word 0x02e49ba6
.word 0xaa3733ad
.word 0x397473cc
.word 0x06cf1d28
.word 0x7d416280
.word 0x5a3dd108
.word 0x8bba8a31
.word 0xbfd5927e
.word 0xc52fc3f5
.word 0x790b68c4
.word 0xac70e1b6
.word 0xbe7cb1cb
.word 0x35584a4a
.word 0x63c2f61e
.word 0xe41f7412
.word 0xacb3b1b8
.word 0x5ff50684
.word 0xe13b37dd
.word 0x80d20d93
.word 0x0d05be11
.word 0x04cc8666
.word 0x79153e62
.word 0xcaf00397
.word 0xcdc11aa6
.word 0x66f84b32
.word 0x5d24f383
.word 0x5d40732d
.word 0xb3e5b40b
.word 0x52d57737
.word 0x2283d9e4
.word 0x0388b322
.word 0x22a31f23
.word 0xb26526ea
.word 0xec7f2683
.word 0xa8c47faa
.word 0xe336344f
.word 0x93fe5f08
.word 0xbb477a6d
.word 0x62cd3943
.word 0x852c8869
.word 0x1159c643
.word 0xe7296a27
.word 0x64da2599
.word 0xcc41fb0c
.word 0x820a9090
.word 0x50b32373
.word 0x8586d454
.word 0x9eb57098
.word 0xb5686a45
.word 0xc73798c2
.word 0x06b3a48a
.word 0x8664668a
.word 0x2808a644
.word 0x7687eabf
.word 0x163eaf00
.word 0x0e28024e
.word 0xfb889b16
.word 0x972886f9
.word 0x1183b92d
.word 0x54c0215c
.word 0x3c68626a
.word 0x2450727c
.word 0x23c267db
.word 0x690559d3
.word 0x35eaac03
.word 0x99a67196
.word 0x85bdad9a
.word 0x50780db5
.word 0x4088f25c
.word 0xdaca6670
.word 0x67a45307
.word 0x3336f3a8
.word 0x7a9e29b9
.word 0x7f2a6324
.word 0xe03fcbac
.word 0x817e0759
.word 0x7bd9d02d
.word 0x2692a999
.word 0x57af9662
.word 0x29e5a959
.word 0x471d23ed
.word 0x077604fc
.word 0x6f670eb8
.word 0xea96a28e
.word 0xb4e5cd2a
.word 0x3c9b5231
.word 0x94067c29
.word 0x79de16ea
.word 0x40201563
.word 0x0a0472e4
.word 0x4692743b
.word 0x7ef3ed5c
.word 0xdd626738
.word 0xab5aa712
.word 0x3e42daa5
.word 0x0b96271a
.word 0x9b04ecac
.word 0x09ff1044
.word 0x8ab98cc1
.word 0x573227dc
.word 0x67af2fdf
.word 0xbd69a9fe
.word 0x8e069ccc

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
