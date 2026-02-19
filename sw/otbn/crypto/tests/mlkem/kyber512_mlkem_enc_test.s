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
.word 0x3c6da5d7
.word 0x4da4f9fc
.word 0x1a6916c7
.word 0xb8a1abcd
.word 0x656412a9
.word 0x7a97c643
.word 0x27ac435a
.word 0x1710cf53

.globl ek
ek: 
.word 0xec773bf8
.word 0x210e6019
.word 0xa2286526
.word 0xa1698011
.word 0x93f93374
.word 0xb5c27778
.word 0xee4e7411
.word 0x533a47ab
.word 0xaa78aa31
.word 0xf679a19b
.word 0x371aa062
.word 0x3fbbed7f
.word 0xec3b452b
.word 0x8b876068
.word 0x59e1f065
.word 0x8735595e
.word 0xf65d37a2
.word 0x531535cc
.word 0x8099a156
.word 0x2c0bcf9c
.word 0xc47be978
.word 0xde7bd46b
.word 0x76d389ba
.word 0x0a57bb61
.word 0x8ccd42f2
.word 0x5821cd38
.word 0x8b5c6494
.word 0x7bc191a7
.word 0x8a3ca91c
.word 0x2ee1e614
.word 0xc2c41435
.word 0xd03c5998
.word 0x5ff01f1f
.word 0x7b4ebbb2
.word 0xea9332e8
.word 0x1a4243aa
.word 0xa325797d
.word 0x30a1b6b3
.word 0x7964ab78
.word 0xd019dcf6
.word 0xc9f74374
.word 0x298a0d33
.word 0x854f493c
.word 0x109eae39
.word 0x68a89449
.word 0x013d3cfd
.word 0x1cfb7d90
.word 0x36e92b5f
.word 0xaba1e440
.word 0x8adc7f6a
.word 0x82516b9a
.word 0x4a343ca8
.word 0x939e36d8
.word 0xb4499ac3
.word 0x1ea0414c
.word 0x69e18e30
.word 0x7c350645
.word 0xbe2d7087
.word 0x45c48ebc
.word 0xaec3ae99
.word 0xfd5367ea
.word 0x9bb190e5
.word 0x8b527eb3
.word 0xfc0fe530
.word 0xbb7d90a2
.word 0x7af59ba1
.word 0x092658c6
.word 0x225bc47b
.word 0x238349b8
.word 0x130aca7e
.word 0x19a72eb7
.word 0x1b48b263
.word 0xee8f4be1
.word 0xdbafb4f4
.word 0x2f15314d
.word 0x861bc0a4
.word 0xc36a48e0
.word 0x4c63e957
.word 0x91373c27
.word 0x62004b0b
.word 0x7fb611ba
.word 0x0b86b403
.word 0x36c68830
.word 0x9aa650a7
.word 0xf58ba630
.word 0x453c5118
.word 0x33a3701e
.word 0xe5a737a0
.word 0xb8e73000
.word 0x86acf1ae
.word 0x0165239e
.word 0x73ea05a4
.word 0x3c2bc18d
.word 0xab73100f
.word 0xcc4e894a
.word 0xa942b685
.word 0x877a42c0
.word 0x041d6dd2
.word 0x2eb9a9a3
.word 0x18b7d1e9
.word 0x7bde6696
.word 0xbc035462
.word 0x87a31222
.word 0x47b1bbd2
.word 0x474883c7
.word 0x551ce333
.word 0x3a9a864b
.word 0x2a89f0af
.word 0x59846c4d
.word 0xc1035faa
.word 0x7946b7cf
.word 0xa256c32e
.word 0x9c6d05ca
.word 0x2d313c74
.word 0x939f7a21
.word 0xf4c2cb04
.word 0x87fac00b
.word 0xdc6c795a
.word 0x73ec2358
.word 0x86b9cb5f
.word 0x9cb86ac6
.word 0xd9a01285
.word 0xb29b5b40
.word 0xcfc41503
.word 0x28639095
.word 0x5a161f30
.word 0x9a3662c4
.word 0x8cb216d6
.word 0x7077092b
.word 0x0794c051
.word 0x7228453b
.word 0x30f6f522
.word 0x723ba894
.word 0xdae72a97
.word 0xa4d4caaf
.word 0xdea7c205
.word 0x754b50d8
.word 0xb057df54
.word 0xa867457c
.word 0x3b718627
.word 0x7e3b45ae
.word 0x907c5a69
.word 0x20433989
.word 0xc632c4c9
.word 0x026391d1
.word 0x3c057990
.word 0x0463fb75
.word 0x737cbaeb
.word 0x08d87d34
.word 0x9a6a9a2c
.word 0x7e090030
.word 0x80168a03
.word 0x1d8bdc9f
.word 0xf539c098
.word 0x23a84273
.word 0x9ea90187
.word 0xec83b0c6
.word 0xac570162
.word 0x97d9ce8e
.word 0x1278b148
.word 0x03e6a379
.word 0x19aa13a6
.word 0x4852750c
.word 0x42c77c4b
.word 0x910234a6
.word 0x953a85a3
.word 0x5bab6a4c
.word 0x8a0a7ea5
.word 0xe3aedbc1
.word 0xa2edc3d0
.word 0x8149e495
.word 0xed84a02d
.word 0x9b8c2aeb
.word 0xb40bf295
.word 0xa5cee761
.word 0x32230a69
.word 0x5c577850
.word 0xebd00644
.word 0x037f45c8
.word 0x071230ac
.word 0x99324548
.word 0x6ba699b3
.word 0xb1284a40
.word 0xbb35fba1
.word 0xa96d3ed2
.word 0x7e297a2f
.word 0xa1ace44f
.word 0x93dc84f4
.word 0xa060ff3b
.word 0xcc139a6d
.word 0xa71301b0
.word 0x9888dec3
.word 0xaa7b4cf1
.word 0x40cec610
.word 0x8bd39ebc
.word 0x2c24d192
.word 0x9d485044
.word 0xa852e605
.word 0x67967c2d
.word 0xa161f4ac

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
