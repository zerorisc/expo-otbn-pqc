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
.word 0xd82c07cd
.word 0x629f6fbe
.word 0xc2094cac
.word 0xe3e70682
.word 0x6baa9455
.word 0x0a5d2f34
.word 0x42485e3a
.word 0xf728b4fa

.globl ek
ek: 
.word 0x24a946ea
.word 0x9b5d2766
.word 0x8981947c
.word 0x360af50c
.word 0x88a7a53a
.word 0x80574b1a
.word 0xb2b271a2
.word 0x53912048
.word 0x4b40ba5a
.word 0x3ac0d37d
.word 0x036a9b40
.word 0x9537028b
.word 0xd4bf760a
.word 0x10a36478
.word 0xa9112b09
.word 0x49007174
.word 0x33543bcc
.word 0x317a2755
.word 0xc797cc8b
.word 0xfb2bade1
.word 0x59a04893
.word 0xa2336884
.word 0xf6564f1a
.word 0x07265378
.word 0xa514a0e1
.word 0xea9b3a8b
.word 0xb8a920b3
.word 0xa4548a18
.word 0xe6f505c5
.word 0x0de3f617
.word 0x592a42ff
.word 0xc0b1b75c
.word 0xc961bc99
.word 0x774dd969
.word 0x1adea66a
.word 0x56653332
.word 0x829c362c
.word 0x96c9b533
.word 0x5b06766f
.word 0x27172a74
.word 0x4a8d7388
.word 0xa40ce29c
.word 0x133d7cae
.word 0xe7f7bf61
.word 0x15126132
.word 0x737093f8
.word 0xf4d924c2
.word 0x8b09b496
.word 0xc8a1ec9c
.word 0xaa193cfb
.word 0x7594a5b3
.word 0xc08f1c4d
.word 0x3949b490
.word 0x98a87e18
.word 0xcecd54d0
.word 0xd34146fc
.word 0xbff9fa20
.word 0x6ab9b0e6
.word 0x1ce38871
.word 0x7420628a
.word 0x413f43eb
.word 0x07a3b535
.word 0x3a56372c
.word 0xb5b0e563
.word 0x942aacd3
.word 0x2c477e75
.word 0x5f4c8075
.word 0xa6c126a6
.word 0x0187c83d
.word 0xfa14a10a
.word 0x94c37fd2
.word 0x1feae640
.word 0x45a81c70
.word 0x787d9852
.word 0x20c6d64d
.word 0x18843384
.word 0x78bb3963
.word 0xa53430b8
.word 0xae6d44b6
.word 0x756d01fb
.word 0xabb76d06
.word 0x9020c477
.word 0xc9088f84
.word 0xb772e475
.word 0xb480f918
.word 0x017e8256
.word 0x84fcbe4a
.word 0x4919c51c
.word 0x16558b86
.word 0x3971bdb2
.word 0x499a6bd1
.word 0xf6ff8069
.word 0x4108a96c
.word 0x7614c864
.word 0x66c14764
.word 0x2872ad04
.word 0x7c54a766
.word 0xfc346ee1
.word 0x63b5d259
.word 0xc653b9d2
.word 0x49b1b622
.word 0x0f715771
.word 0xbab4a44e
.word 0x33accbc3
.word 0xb228e3c1
.word 0xb20dd3ce
.word 0xa308cab6
.word 0x1009de1b
.word 0x9d44e206
.word 0x58004f52
.word 0xa2a4c188
.word 0x51576af6
.word 0x12ab3026
.word 0x5b5a4d82
.word 0x6f4e82f4
.word 0xa260b1f1
.word 0x6bd7bcac
.word 0x1925c3e6
.word 0x51d8c1c8
.word 0x9d823b73
.word 0x93c7b8b1
.word 0xc9bd2704
.word 0xa1f972ba
.word 0x93c3250d
.word 0x83c07a58
.word 0xc401821f
.word 0x121921d8
.word 0x719fb502
.word 0x5df4f20a
.word 0x5640555a
.word 0x30decbac
.word 0x3044caa7
.word 0x1191a361
.word 0x3bf4a338
.word 0x63a35d6e
.word 0x9fbfe843
.word 0xb2839d4b
.word 0x9233603a
.word 0xfb31733f
.word 0x547b42e6
.word 0xa9c45d38
.word 0xde474065
.word 0x94cd7d19
.word 0x0d034f19
.word 0x9faa405b
.word 0xd0531dd0
.word 0x48c54948
.word 0xb56736db
.word 0x51221489
.word 0x5a227701
.word 0x40c0c220
.word 0xd66eac54
.word 0x0506405d
.word 0xe16171c9
.word 0xa81957a7
.word 0x3dc5680d
.word 0xcb3f4717
.word 0xdaec63f9
.word 0x44556809
.word 0x390f3093
.word 0x5cd90530
.word 0x2db78a18
.word 0x4057f322
.word 0x220742c7
.word 0x4c822900
.word 0xfc36078f
.word 0xd6705aab
.word 0x309814b8
.word 0x6eaaa059
.word 0xd4ef3447
.word 0x4296a018
.word 0xab236377
.word 0xaaa3c580
.word 0xb87c11c5
.word 0x0210f6af
.word 0x1b143e39
.word 0xb4b37b93
.word 0xf3a6d255
.word 0x80584683
.word 0x9743a1aa
.word 0x3181d993
.word 0xec71cee2
.word 0x6b369489
.word 0xdd23698f
.word 0xb1f857c0
.word 0xa54c3aca
.word 0x530c5057
.word 0x42ed0553
.word 0x56967d7e
.word 0x832208e7
.word 0x2b638283
.word 0x11a6137c
.word 0xfd5cd8da
.word 0x46d64e6c
.word 0x03285d68
.word 0xa00fcac8
.word 0x05f06ba9
.word 0x15542938
.word 0x7166f0ed
.word 0x59f661b6
.word 0x93bb712c
.word 0xca1cbaca
.word 0xd3146739
.word 0xa694e442
.word 0x535536c3
.word 0x716e3170
.word 0xbdf8de3f
.word 0xf48d1159
.word 0xa7a215aa
.word 0xbf3ba710
.word 0x75cbf11d
.word 0x59b78663
.word 0x3ae6f5b2
.word 0x2983128b
.word 0x52db1d9c
.word 0x4189f26f
.word 0xe27f2caa
.word 0x33af74ca
.word 0xb4880b14
.word 0xf20f6a5d
.word 0xa568c0d4
.word 0x7f34351d
.word 0xc72236c7
.word 0x3a4e0743
.word 0x40aafa6d
.word 0xa23d4af9
.word 0x51ff0585
.word 0x9ba13eb8
.word 0x1e5fc7ef
.word 0x01818f80
.word 0x1cb4ce9b
.word 0x18159c3a
.word 0x18e071e4
.word 0x8ac765b3
.word 0x60789b00
.word 0x22da22b3
.word 0x942aa0c7
.word 0x48cd5aaf
.word 0x905ba5d5
.word 0x422365c4
.word 0xcba128b3
.word 0xdcf5b218
.word 0x16854d63
.word 0x0f8dd4de
.word 0x0c16c4d6
.word 0xcde3786f
.word 0x28488516
.word 0x4b2e5df3
.word 0x04039a70
.word 0x94c24bc9
.word 0x9a6bb2fa
.word 0x75b39f9d
.word 0xdfa6d9db
.word 0x8ad06561
.word 0x08e7c800
.word 0x666f2a42
.word 0x79998b49
.word 0x7993b534
.word 0x21abfce2
.word 0xa0b5bcda
.word 0x254495a5
.word 0x1d269634
.word 0x11587bab
.word 0x6079f417
.word 0xe4182590
.word 0xb9d678da
.word 0x5316402a
.word 0xe9ae4035
.word 0x81780c9a
.word 0x26187479
.word 0xff718576
.word 0x71d830f2
.word 0x45cb572b
.word 0x5b145696
.word 0xd8cf5688
.word 0x80a81710
.word 0x534a32c8
.word 0xc3799f10
.word 0xcb269e1b
.word 0x381c9233
.word 0x2a9abf00
.word 0x709a923b
.word 0x1fb51121
.word 0x4b30aa65
.word 0x894c086c
.word 0x077126ad
.word 0x4a975cb1
.word 0x9bc7984b
.word 0x377ea44c
.word 0x4ac331c7
.word 0x0df00528
.word 0xaeafb934
.word 0xf2bc3523
.word 0x4dd0a948
.word 0xae2959b9
.word 0xf424b9f6
.word 0x5f80c94b
.word 0xe66b8926
.word 0xea0f9f37
.word 0x2b526885
.word 0x438f8645
.word 0xfccfb759
.word 0x4da75048
.word 0x5a6428a3
.word 0x403129e1
.word 0x1891875a
.word 0x6696837b
.word 0xf1102955
.word 0x9721ef3b
.word 0x3e31b2c4
.word 0x735890d7
.word 0x7b546d53
.word 0xaf3568c2
.word 0x1b737bfa
.word 0x87760262
.word 0xfc262b0f
.word 0xb8a78a66
.word 0x0d940621
.word 0x653eac0f
.word 0x479a7f13
.word 0x89e2c875
.word 0x5ea132cf
.word 0x669512c5
.word 0x6cc07e9c
.word 0x0002ac3e
.word 0x412e6db5
.word 0xb8127f81
.word 0x1995da17
.word 0x4071bd72
.word 0x97e81c7a
.word 0x5009dc7b
.word 0xf2eb7a2a
.word 0x5387caba
.word 0xb1966b32
.word 0x19ec1db7
.word 0x54da8292
.word 0x2226a374
.word 0x622494e4
.word 0x10597c15
.word 0xfebe0cce
.word 0x7ae30837
.word 0x7d347c41
.word 0xa16f9312
.word 0xb5803cf8
.word 0x0f392133
.word 0x0663a82e
.word 0x33f381c8
.word 0xc99189c2
.word 0x92a51a90
.word 0xe8428494
.word 0x5f0c0207
.word 0x998590ae
.word 0x809aa9d3
.word 0x2cfaa34a
.word 0x2a28c18c
.word 0xdc5e22c4
.word 0xc138d37e
.word 0xdeb74211
.word 0x917f2938
.word 0xa6390a94
.word 0x5b897623
.word 0xa51eb954
.word 0xb6a8229a
.word 0xa64e40ab
.word 0xb6a0a778
.word 0xca8b8dc3
.word 0xd882fc7e
.word 0xa7c09e7a
.word 0x5072489b
.word 0xed787961
.word 0x63d01fe2
.word 0x91363d5e
.word 0xd774f85f
.word 0x4c760db0
.word 0x33f8f453
.word 0x009143d0
.word 0x667371ad
.word 0x8e4188af
.word 0x8d85e636
.word 0x3a7fa280
.word 0x1c7a8564
.word 0xb6c0664d
.word 0xd72cc362
.word 0xc2c65a05
.word 0xb083c62c
.word 0xa19363bd
.word 0x19819ccf
.word 0x7f8f6cc7
.word 0x59c565c2
.word 0x4b6607b1
.word 0x7b6c1798
.word 0x115e1e42

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
