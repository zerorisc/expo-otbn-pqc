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
.word 0xfec4a4b4
.word 0xa79b75e6
.word 0xbdd5b4c9
.word 0x4f2321cd
.word 0xfb180c8b
.word 0x544cf47f
.word 0x7b43f240
.word 0xa8a7b044
.word 0x28378e8a
.word 0xe2b16166
.word 0x17546a8a
.word 0x17131b6c
.word 0xcc91f787
.word 0xa8c96971
.word 0x6318122d
.word 0xa20e73bc
.word 0x867db3e7
.word 0x234ca106
.word 0x8f64f723
.word 0xdc194b78
.word 0xa1a23018
.word 0x07a193d1
.word 0x3c1bb523
.word 0xb240127f
.word 0xfc8b1cc7
.word 0xf562929c
.word 0x784375c1
.word 0x240175a4
.word 0xe93f0051
.word 0xbdca9259
.word 0x8d7c0ca6
.word 0x45c7175a
.word 0x4a01d1ca
.word 0xfe4405a0
.word 0x77375744
.word 0x50da70b3
.word 0xc786e45d
.word 0xa5288f76
.word 0x3fd2cf75
.word 0x804b2790
.word 0x67dc7553
.word 0xa024d378
.word 0x8123c590
.word 0x03610fda
.word 0xb8718321
.word 0x903f87d8
.word 0xd45fb11a
.word 0x32890034
.word 0x015b2bc7
.word 0x8ccdbeac
.word 0x9561d835
.word 0x2390d35e
.word 0x002d87bc
.word 0x051533b3
.word 0xfb233336
.word 0xcbe94139
.word 0xcc300102
.word 0x9f84376f
.word 0x679dbeea
.word 0x1fe0550d
.word 0xcf5f67f5
.word 0xeade3569
.word 0x6af5a54f
.word 0x20c02b9b
.word 0x4749b755
.word 0x48f2c2bb
.word 0xa24e6257
.word 0xd2366c5c
.word 0x3329732d
.word 0xba547c27
.word 0x536540e6
.word 0x691656bd
.word 0x174f3044
.word 0x24aabb45
.word 0xbe71924e
.word 0x79641b96
.word 0xf7d431c8
.word 0xc72bf276
.word 0xadad69a5
.word 0xf5212ac2
.word 0x07ac7c43
.word 0x7d694b94
.word 0xc8830a46
.word 0x860ced5f
.word 0xd9ab4997
.word 0x132f73c1
.word 0x0e907b83
.word 0xe0902ce6
.word 0x04a722f2
.word 0xad0ba715
.word 0xeac3c649
.word 0xe4339721
.word 0x02870011
.word 0x58cc4360
.word 0xec8e5c32
.word 0xaf50e36f
.word 0x2e20198d
.word 0x32017444
.word 0x8e74bbcf
.word 0xb868f459
.word 0x01a3b6b5
.word 0x0692c094
.word 0x4c89c0fb
.word 0x1c22b585
.word 0xb6bbb556
.word 0x6402e2be
.word 0x5748516c
.word 0x6a12b06b
.word 0x2f7f7517
.word 0xb4d32196
.word 0x3e460a38
.word 0x75801820
.word 0xd2720b6a
.word 0x3b40521b
.word 0xc1827161
.word 0x41541d52
.word 0x37431a8c
.word 0x4e446406
.word 0xf5ca3df8
.word 0x6728dbcf
.word 0x7f3d0272
.word 0x950c7b10
.word 0xcaab1ac0
.word 0xbfb845f6
.word 0x2148c3c7
.word 0xb586d294
.word 0x1ebee6d0
.word 0x7b20960c
.word 0x52110034
.word 0xab3d521c
.word 0x76d468d1
.word 0x96804a1f
.word 0x3d4fe58d
.word 0xe7a68e59
.word 0xbeab993c
.word 0x6ec91cc7
.word 0x42af2bdb
.word 0x21da7028
.word 0xd563d8f1
.word 0xf01c4574
.word 0xa398f997
.word 0x03008908
.word 0xe962a39b
.word 0xa7c87f17
.word 0x4d75e05c
.word 0x8a592cb1
.word 0x6ec8d406
.word 0x1ba96687
.word 0xe91b56d9
.word 0x25165c5a
.word 0x1569988a
.word 0x015f4d36
.word 0x1c411285
.word 0xe64dd53d
.word 0xb95e6cd3
.word 0x625c9656
.word 0x9a5b9b9f
.word 0xfa7d5e61
.word 0x073b682e
.word 0x272459ec
.word 0xbb0e6cc4
.word 0xb3573748
.word 0x64600a7c
.word 0xb499823b
.word 0x10a44323
.word 0x35c501e4
.word 0x505486da
.word 0x88c44f74
.word 0x3025dcfb
.word 0x398fc833
.word 0x95f4efc0
.word 0x2a03502a
.word 0x23850e91
.word 0x7a698e35
.word 0x4a73501c
.word 0x2394b386
.word 0xa147ee85
.word 0xc772e1c7
.word 0x96806036
.word 0xc4871e74
.word 0x1a732962
.word 0x571114e8
.word 0x853586bd
.word 0x3bc30975
.word 0x25268168
.word 0x6aaae295
.word 0xef92897f
.word 0xf3e13cb8
.word 0xb1572209
.word 0xd5698c4c
.word 0x1c2a3058
.word 0x75907741
.word 0xfe002ce6
.word 0x522c4c8b
.word 0x5315172c
.word 0xbc8c51a8
.word 0xc31e4e2b
.word 0x98b53bac
.word 0xd04e466d
.word 0xd5d761aa
.word 0xc12a76a7
.word 0x68a4f8f1
.word 0x88caab88
.word 0x8e82196d
.word 0x5354b585
.word 0x9979b108
.word 0x89291e7a
.word 0xd222b19b
.word 0x333fc487
.word 0x5b0928a6
.word 0xe47f4956
.word 0x34137709
.word 0x065bcd45
.word 0x1805e997
.word 0xb4f0aed5
.word 0x4f48a27d
.word 0x520cca0e
.word 0x90e227ab
.word 0x18b1cb6a
.word 0x171bf7d4
.word 0xe8791c97
.word 0x20b0b65d
.word 0xf90bd60d
.word 0x24f3996b
.word 0x38bad026
.word 0x5f0d203e
.word 0xc8dc14ba
.word 0xbdc90341
.word 0x984b1449
.word 0x5a7ecd9b
.word 0x758b4e4f
.word 0x6a4ef6a7
.word 0x94047beb
.word 0xa8394306
.word 0xfd8e999b
.word 0x7173a114
.word 0x45c8f5b6
.word 0xd40f4b8b
.word 0xd0529e36
.word 0x8775f603
.word 0x5d98169c
.word 0xb226763a
.word 0x89a0bbc8
.word 0xe88aa9cb
.word 0xfc362f59
.word 0xccd9f4ab
.word 0x8e36dbed
.word 0x82dda0d5
.word 0x6bd2cd66
.word 0xf6c4f9a7
.word 0x466744b9
.word 0x5403236b
.word 0x96c896d6
.word 0x58b038b9
.word 0x6f4cf54b
.word 0x239b4923
.word 0x0028ccc0
.word 0x9b97bcc4
.word 0x1c44eb86
.word 0x0ba4aaf2
.word 0x4ac3bb5c
.word 0x5dabb26c
.word 0x1a1874c0
.word 0x4904cd13
.word 0x189f3c12
.word 0x99bb5600
.word 0x66621a20
.word 0x58ba812c
.word 0xc9f74b33
.word 0xa6533d0b
.word 0x8f659553
.word 0x23fc9292
.word 0x106788c9
.word 0x8425556f
.word 0xf97f6cb8
.word 0x29c1169c
.word 0xb680ba39
.word 0xe6580156
.word 0x68a14b24
.word 0xf06130bd
.word 0x61e37219
.word 0x3cd4c9b4
.word 0x726c90bd
.word 0x94488a7b
.word 0xbcbc3287
.word 0xbb087852
.word 0xf50cafba
.word 0x6a528ca7
.word 0x93634133
.word 0x7b104438
.word 0x3a534418
.word 0xfa6fac90
.word 0xaa122c31
.word 0x38e9c789
.word 0xe4656aeb
.word 0xb0d8adc1
.word 0x60003014
.word 0x03099381
.word 0x2a923b75
.word 0x2893ef7c
.word 0x868f4557
.word 0x2900c8e4
.word 0x87a9b705
.word 0x45444652
.word 0x822ba044
.word 0x52756202
.word 0xd5acb335
.word 0x454c6311
.word 0x9b302bb8
.word 0xd36df803
.word 0xbc630ab8
.word 0x6b47306b
.word 0x5b8fd89b
.word 0x54f620f2
.word 0x814c79c5
.word 0xa5b0f158
.word 0x417c90fb
.word 0xb790c77e
.word 0xeacbb543
.word 0x556fb705
.word 0x552bfe2f
.word 0x96217ca4
.word 0xf43b3640
.word 0x524a652b
.word 0xbab54820
.word 0x9bb83c34
.word 0x6902ca74
.word 0xd08dd8bb
.word 0x0b8496e1
.word 0x3723c916
.word 0x954a62e2
.word 0x612607a0
.word 0x81e13023
.word 0xd8176036
.word 0x957112cb
.word 0x92986d37
.word 0x7eba06d1
.word 0x90573cea
.word 0xbc2a1409
.word 0x8e9545e5
.word 0x79ad84ca
.word 0x843b3e54
.word 0x98052bb7
.word 0xd8457112
.word 0x61d20689
.word 0xa348c116
.word 0xf1bb9916
.word 0xb1ab946f
.word 0x2b4525ff
.word 0xc429b92b
.word 0x3b9696cb
.word 0x227e562e
.word 0xe7f228bc
.word 0x14142957
.word 0x4871e19f
.word 0x1bb71aeb
.word 0x295200c3
.word 0x42a1e763
.word 0x20ce7e7c
.word 0x8d84cc21
.word 0x647de175
.word 0xfae5b7ec
.word 0x6f398607
.word 0x6b53e35a
.word 0x31e18618
.word 0xcf90ed14
.word 0x5d5850d3
.word 0x31d030a8
.word 0xbdc22fa7
.word 0xabcb5039
.word 0x8816cd8b
.word 0x8ef24864
.word 0x6f535ce8
.word 0x2719362c
.word 0x6ee5a64d
.word 0x543672ac
.word 0x65fabdd4
.word 0xb9e9760b
.word 0x6f5f5079
.word 0x49bc0630
.word 0x23eb4385
.word 0x7c1ee499
.word 0xfc0d514b
.word 0x83364513
.word 0x77f967d9
.word 0x5a6c2ea5
.word 0xb1cd72bd
.word 0xd02bb1cf
.word 0xe4385425
.word 0xed0fcb99
.word 0xef6954e0
.word 0x1ef6399d

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
