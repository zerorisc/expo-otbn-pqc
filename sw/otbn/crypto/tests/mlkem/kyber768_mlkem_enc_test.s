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
.word 0x1e4bc7e3
.word 0x16ae9f30
.word 0xa139c61d
.word 0x7dbe0092
.word 0xe9e1a747
.word 0xb27bae10
.word 0xf33eb4d5
.word 0x636698dc
.word 0x4073fb34
.word 0x5e92fc03
.word 0xf7ce0445
.word 0x8709893f
.word 0xbb537a41
.word 0xeab28bc6
.word 0x4275e89e
.word 0x3dbd7aea
.word 0xa73e730b
.word 0x198084bd
.word 0xedb24a8a
.word 0xa01f9526
.word 0x6467cd76
.word 0xfb81009a
.word 0x88b367d6
.word 0x80e6ae16
.word 0xed300cbb
.word 0xb5db5358
.word 0x93903f46
.word 0xee76ec5b
.word 0xf4d2a2a4
.word 0x918a3ebe
.word 0x05850443
.word 0xd52b2fc3
.word 0xa284518b
.word 0x0db7e1a9
.word 0x844ab3f3
.word 0x4ef485c1
.word 0xda9585ab
.word 0x4401c410
.word 0x605a422e
.word 0x7f99463d
.word 0xeaa4b7f7
.word 0x97516064
.word 0x1ea3d503
.word 0xbcc89a53
.word 0x96e539a9
.word 0x7902031f
.word 0x3938bf33
.word 0x02eba15a
.word 0x2ab403e6
.word 0xf80b81ac
.word 0x19d32c43
.word 0xf54a0b26
.word 0x07810ad2
.word 0x72400005
.word 0x6e9c202a
.word 0x61090530
.word 0x95533bcb
.word 0x79c0ec89
.word 0x25602095
.word 0x5a462306
.word 0x960de9a7
.word 0xf51f6c69
.word 0x541b695a
.word 0xfb52a94e
.word 0xab757cfa
.word 0x061b8899
.word 0xd0cf0048
.word 0x2b3a256b
.word 0x6bb60c42
.word 0xff23cae5
.word 0xe41a452a
.word 0x00d6083a
.word 0xeb75969a
.word 0xb7d1a479
.word 0xa6a0173b
.word 0x2a9cd4c5
.word 0x89fa6741
.word 0x4426264e
.word 0x786a1428
.word 0x008902e7
.word 0x270c1613
.word 0x02171c28
.word 0x50040da7
.word 0x7794ed55
.word 0x106f5c44
.word 0x4b910167
.word 0x07021c0a
.word 0xf7159a04
.word 0xf52c8c5c
.word 0x20ba6a9d
.word 0x39930362
.word 0x539015aa
.word 0x5c166cc2
.word 0x915661f4
.word 0x4b7dbe74
.word 0x21b706a0
.word 0xad3d62ca
.word 0x12b33d22
.word 0x0574276b
.word 0x8971e2cd
.word 0x3109193c
.word 0x76987092
.word 0xcf4d0816
.word 0x538038e6
.word 0xbf40ddb0
.word 0x433d0941
.word 0xc2d7cb4c
.word 0x6a97d049
.word 0x955af5f4
.word 0x0a66c3e4
.word 0x8f13f56e
.word 0x441217a2
.word 0x69239f86
.word 0x619cd26b
.word 0x2bb9cba2
.word 0x96b196b7
.word 0x8207c784
.word 0x9e5397b0
.word 0x83b662c5
.word 0x8bfb2b1b
.word 0x67cb707f
.word 0x153cc3b2
.word 0x6879cc3d
.word 0xc47596d8
.word 0x29d10af2
.word 0x8c0a2f64
.word 0x0a87986e
.word 0x56ffc3bb
.word 0x9373d4b7
.word 0x34cf3558
.word 0xc8a91afa
.word 0x64e8f04e
.word 0xa1032238
.word 0x11c43525
.word 0x7f8b4b80
.word 0x716c9826
.word 0x4cf331c4
.word 0x7963b085
.word 0x9f78caf2
.word 0x0a03b358
.word 0x904ab463
.word 0x00103596
.word 0x57eb0e5a
.word 0x6820b51c
.word 0xb42b5af0
.word 0x56961b54
.word 0xc4b0ec0a
.word 0x2b65d1b4
.word 0x7a9e46d7
.word 0x5737348e
.word 0xe79e8511
.word 0x83f01ebc
.word 0x7f6c3f4e
.word 0x5b16eca9
.word 0xb184bb10
.word 0xce6268c7
.word 0x8d5f02ef
.word 0x71aac5d4
.word 0xbc3862b9
.word 0xe951936e
.word 0x25834d26
.word 0x2a09d93e
.word 0xd12340b0
.word 0x980c07a3
.word 0x6d467912
.word 0x8256cbd4
.word 0x17eb5570
.word 0xcde8dcc0
.word 0xe40a8530
.word 0xe458ad07
.word 0x0c384354
.word 0x61568b04
.word 0xf55e5596
.word 0xcb05fa0d
.word 0xe364b279
.word 0xbc3d4055
.word 0xb2c432b8
.word 0xf232d3d1
.word 0xa3419dca
.word 0x00e34d21
.word 0xc805238f
.word 0xfc9faff8
.word 0x3242884b
.word 0x1253d039
.word 0x621eaf80
.word 0x81110036
.word 0xd1909a94
.word 0x809296dc
.word 0x0f773126
.word 0xf33da9db
.word 0xf200b376
.word 0xa97078b0
.word 0x5368641a
.word 0x2bd4b1eb
.word 0xb1f6344b
.word 0x3910e649
.word 0x45fb590a
.word 0x27148096
.word 0x436b20e6
.word 0x34fcbf65
.word 0x09b8cd3c
.word 0x9c705a10
.word 0x91616174
.word 0x02d01499
.word 0xa3747534
.word 0x3282b03a
.word 0x1a4c2c87
.word 0x0dc337fc
.word 0x58876de2
.word 0x74495f29
.word 0xe3bd280e
.word 0x406a40fa
.word 0x0e94a41c
.word 0xa153b0fa
.word 0x734e4b1c
.word 0x909b4c2a
.word 0x6b42e87e
.word 0xea0b84b9
.word 0x5196b678
.word 0xff287254
.word 0x26ab34b6
.word 0x27ab4447
.word 0x526381b9
.word 0x9945138c
.word 0xc3b95778
.word 0xc212b54e
.word 0xa90d2c6a
.word 0x87266fc7
.word 0xa7b088a1
.word 0x46842167
.word 0x84b79653
.word 0xccb4e628
.word 0x7918b166
.word 0x7fb75d5f
.word 0x553aa457
.word 0x1a12cd07
.word 0x85d53296
.word 0x3601f037
.word 0xeaf9be10
.word 0x05fb6bca
.word 0x84c7422c
.word 0xbca84ca4
.word 0x320400bb
.word 0x5a4ea7b2
.word 0xe67261c3
.word 0xba9c2c95
.word 0xfd5bcb41
.word 0x412aab76
.word 0xb0e311a2
.word 0x49974624
.word 0x7cfb3be9
.word 0x5885eca7
.word 0x16c5dcc3
.word 0xcb9f2f03
.word 0x866c8a39
.word 0xf89dcb28
.word 0xc6e5653c
.word 0x05276f51
.word 0xc99b1bf0
.word 0x6256cc82
.word 0x358878b4
.word 0xf2898620
.word 0x692039d3
.word 0x9f45cc68
.word 0x96bdcc8f
.word 0xc4fa8e73
.word 0x3c58470c
.word 0xfb282603
.word 0x811e9594
.word 0x25e6c214
.word 0x54c2011d
.word 0x34ea5475
.word 0x25d1aace
.word 0x07c72255
.word 0xd77ac990
.word 0x6419ec84
.word 0x77bddcd4
.word 0x663b5f93
.word 0x6ab8a08a
.word 0x9eb0045f
.word 0x08164a83
.word 0xa075b067
.word 0x83855c94
.word 0x69233474
.word 0xa00b40ac
.word 0xf88241c5
.word 0x17cb27a1
.word 0x1b63392a
.word 0xdac3d039
.word 0xa2f63710
.word 0xa44a0aae
.word 0x87335142
.word 0x51203df8
.word 0x0c828020
.word 0x1dd9c60c
.word 0x4439555e

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
