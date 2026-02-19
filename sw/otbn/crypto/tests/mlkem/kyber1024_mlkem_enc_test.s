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
.word 0x3ceb3ffd
.word 0x97b75092
.word 0x8b529b4a
.word 0x21636369
.word 0x5eb561a4
.word 0xea7b5bf5
.word 0x9a9a80fd
.word 0x795b929e

.globl ek
ek: 
.word 0x6e830280
.word 0xe05c577a
.word 0x12046f90
.word 0x1aa5d0d9
.word 0xfa8f7da0
.word 0x9e6954af
.word 0x2853093a
.word 0x83cd32c3
.word 0x27b06682
.word 0xfc00f7a4
.word 0x85df31e3
.word 0x702c7883
.word 0x5b1397e7
.word 0x5aa3b912
.word 0x6218a661
.word 0x7abe84d6
.word 0x50b81c8c
.word 0x7eb30e39
.word 0xc70620d2
.word 0x630c12f7
.word 0x17a15f31
.word 0xe720ba46
.word 0xb2631d1c
.word 0x4d7461ac
.word 0x4a31ab7d
.word 0x17238a44
.word 0xb8e98948
.word 0x6a0be436
.word 0x2a8b1604
.word 0x2de87d6e
.word 0x83bd8ba0
.word 0x3c8e91e5
.word 0x787c6f33
.word 0x26012a3c
.word 0x28891578
.word 0x5a89c3b1
.word 0xac6e8785
.word 0xeca873f5
.word 0x92f2c123
.word 0xf8bfd2a6
.word 0x90432aa0
.word 0x55ebfe7e
.word 0xa662e3c0
.word 0xb60e5c62
.word 0x6d0b4600
.word 0xe9a416f0
.word 0xbc0c7bfb
.word 0x4f058206
.word 0x02110b9d
.word 0x804646e0
.word 0xa101b153
.word 0xa93cf3ad
.word 0xe1668627
.word 0x4313ee32
.word 0xc23854cd
.word 0x045c1042
.word 0x0952d7b7
.word 0xee20a3d0
.word 0xaad0c288
.word 0xa363ae2f
.word 0xac7259af
.word 0xca996645
.word 0xb6a7b070
.word 0x6a8cebcf
.word 0x5b8fb1e9
.word 0xcc5b7ea6
.word 0x1e99978f
.word 0x0a1f544c
.word 0x864ac0b3
.word 0x0b3ee759
.word 0xcbe4cda2
.word 0x565ada9d
.word 0xe44bfaae
.word 0xe5ce52f1
.word 0x97a8c6bd
.word 0x4bc71b71
.word 0x114dcd06
.word 0x6098991f
.word 0x73144177
.word 0x07553b28
.word 0x1070a08d
.word 0xfd77e8aa
.word 0x21073509
.word 0xa8565391
.word 0x515a8c74
.word 0xd63b4d35
.word 0x18180743
.word 0xb5ac3135
.word 0xb329a2c6
.word 0x02e89e44
.word 0x20b435e4
.word 0xa5c4ad17
.word 0x96e153a5
.word 0xaa985433
.word 0xb52991a6
.word 0xbc69855b
.word 0xfa46846f
.word 0x36dd2fb6
.word 0x3d759b9d
.word 0x3583b42b
.word 0xdb746f67
.word 0x5a958959
.word 0x1d4bca86
.word 0x056cc516
.word 0x27fabf1b
.word 0x08ba73e5
.word 0x59299dd7
.word 0x2a886baa
.word 0x39cda783
.word 0xf9a4c623
.word 0x1e827213
.word 0x4a69043a
.word 0x82114385
.word 0xc222b60f
.word 0x059a2776
.word 0xb3671671
.word 0xba167714
.word 0x24200b82
.word 0x38ab5430
.word 0x443c9e80
.word 0x90ae337a
.word 0x966e265c
.word 0x768b0992
.word 0xac763b70
.word 0x264d39c7
.word 0xc9c3a8aa
.word 0xbe018912
.word 0xf2c8549b
.word 0x27f292ab
.word 0xeb0b27a3
.word 0x195d4532
.word 0x2de023c4
.word 0x8a17d810
.word 0xf13a3384
.word 0x8c007393
.word 0x3892014f
.word 0x64cc53b9
.word 0x91499645
.word 0x47470356
.word 0x10c95c75
.word 0xb507fc5f
.word 0x52c4a8cd
.word 0x506724c9
.word 0xd00c561c
.word 0x35b40836
.word 0x87904f24
.word 0xa9d4c845
.word 0x1833b25e
.word 0xc83faab6
.word 0xc29c4f49
.word 0xb9328477
.word 0x249378c2
.word 0xa8294455
.word 0xe52db125
.word 0xb55020e3
.word 0x85784fce
.word 0x490fa13f
.word 0x61dfa088
.word 0x6a2bb961
.word 0x7b62165a
.word 0x7669a15b
.word 0x0d458699
.word 0xd387579c
.word 0x09024d6b
.word 0x81977d68
.word 0x0c005891
.word 0x9a34acd1
.word 0xc7b88f17
.word 0x3e4cb5ca
.word 0xd16ca634
.word 0x35513074
.word 0x7a485591
.word 0x76ac634a
.word 0x14782d22
.word 0xca5e2aca
.word 0xa0b09db4
.word 0x3e66f366
.word 0x8501324e
.word 0xb332a81c
.word 0x47e68c77
.word 0x3f51128a
.word 0x00ba866a
.word 0x031bacbe
.word 0xf226b9c0
.word 0xe78e1393
.word 0xc8d89215
.word 0x2270e5b6
.word 0xf6bcba24
.word 0x9d1a40b8
.word 0x20892089
.word 0x072d5489
.word 0x9920136d
.word 0x989f1a56
.word 0x6017492a
.word 0x4f98946a
.word 0x8d5f409e
.word 0x739f800c
.word 0x2bc63890
.word 0x8a0ce6f9
.word 0x47389d22
.word 0x0f22bd45
.word 0x93bb83e1
.word 0x54a21e38
.word 0x191af6bf
.word 0x80a04038
.word 0xc7522063
.word 0x8f9bd94b
.word 0x8e03516d
.word 0xf1db2a8a
.word 0xca1a081f
.word 0x9764d1d6
.word 0xa6819348
.word 0x978c39c5
.word 0xa36ae7bc
.word 0x15233257
.word 0x05613186
.word 0xe1880a8d
.word 0xe5dc1074
.word 0xbcf13fc6
.word 0x353a1239
.word 0x94c31545
.word 0xbf1aec11
.word 0x0e75d173
.word 0x721d6bea
.word 0x36f9bec2
.word 0x20c9821c
.word 0xc3180cc1
.word 0xc9b00dab
.word 0x619b54f0
.word 0x08b65d40
.word 0xb8764834
.word 0x5582a9d9
.word 0x96bb16f6
.word 0x418b33ab
.word 0x9f1052b1
.word 0x90a536e1
.word 0x856c198c
.word 0x6e245586
.word 0xf7bb0403
.word 0x0cc3e52b
.word 0xb02ac622
.word 0x38dc8a80
.word 0xc3c7dc8e
.word 0xfb2de7c4
.word 0x38588598
.word 0x104ac0a2
.word 0x7e9c3cd3
.word 0xc48d84d9
.word 0x5993be40
.word 0x39157519
.word 0x4a2e8d32
.word 0x1e48a576
.word 0x5db528e8
.word 0x920a68e1
.word 0xc464bb68
.word 0x4370d5e9
.word 0x039e24f4
.word 0x4e790382
.word 0x139f1cfd
.word 0x14c69271
.word 0x4a643329
.word 0x091d2bd9
.word 0xc0bf392a
.word 0x7e34ac06
.word 0x3a39114e
.word 0x043eb50c
.word 0x3a46ec78
.word 0x6f67c0fc
.word 0xa61c2243
.word 0x7586c49b
.word 0x93c35020
.word 0x81b3b178
.word 0x7c6001c4
.word 0x4a4579ab
.word 0x343a5f59
.word 0x76f4945d
.word 0xb904daaf
.word 0x50328109
.word 0x35c7de92
.word 0xc193bba5
.word 0x3ce2c8e8
.word 0xc8c9cec0
.word 0xe05facbc
.word 0xd4c0591a
.word 0x9ee2e00b
.word 0x5301256b
.word 0x6aa40f1a
.word 0x32ec8b3f
.word 0x1560f939
.word 0xfac6c953
.word 0xa81567b9
.word 0xf9c0ab1f
.word 0xe1005727
.word 0xacfb35b6
.word 0x6a1d9147
.word 0x25b4435a
.word 0xb24c8413
.word 0xcd1f3735
.word 0xe2b31da8
.word 0x2c57868e
.word 0x9cc3fb53
.word 0x68837bec
.word 0x44398c08
.word 0x1c456455
.word 0x89f81358
.word 0x14f7fe9c
.word 0xc575183b
.word 0x6adf951c
.word 0x620c1a26
.word 0x5147e06f
.word 0xa7819086
.word 0x43f2a471
.word 0x83bacb2c
.word 0x19398831
.word 0x5c8c2858
.word 0x3cc82bb2
.word 0x1a49c847
.word 0x82d1a398
.word 0x4a708c9f
.word 0x457bce3c
.word 0x4c41590d
.word 0x93c5bc8a
.word 0xd7db81f7
.word 0x00b50949
.word 0xdda9042e
.word 0x24269fa9
.word 0x9da67da3
.word 0xaa0e1656
.word 0x3044a829
.word 0x7f8bad78
.word 0xd02ab281
.word 0x98eeb3b3
.word 0x22283200
.word 0x32a5223a
.word 0x392c4c0a
.word 0x3678afc2
.word 0x4911c059
.word 0x5224bbc3
.word 0xa8ead352
.word 0xa199d82a
.word 0xf7cdb6f7
.word 0x52897b23
.word 0x6293e77d
.word 0x791cc959
.word 0x9400167a
.word 0x78101852
.word 0x19c21485
.word 0x095cb02f
.word 0xdd20369a
.word 0xcc291be3
.word 0xb909bb6e
.word 0xe5250c14
.word 0x55ae12d7
.word 0x8ba3525e
.word 0xe4c15363
.word 0x1202c9d0
.word 0x0a54b13b
.word 0x734ad21e
.word 0x796929e0
.word 0x9924b8af
.word 0x88227ced
.word 0xc3e58607
.word 0xb8a76c69
.word 0x187b3ab2
.word 0x5bf2c661
.word 0x9fda3331
.word 0xc8bc602b
.word 0x9cae1724
.word 0x6894dc21
.word 0xfd622b25
.word 0xa89452ba
.word 0x3d54c4b6
.word 0xfba6bbc2
.word 0x098f2541
.word 0x990b6598
.word 0xa133091b
.word 0x223e6fc6
.word 0x9f2b1364
.word 0x40bd23bc
.word 0xca6003d0
.word 0x8883725a
.word 0x5671116b
.word 0xe9ad0e2c
.word 0x7ad80704
.word 0x9e8a419e
.word 0x3d55650e
.word 0x8160d9ce
.word 0xbb86899f
.word 0xf626b4ee
.word 0x8a1b3494
.word 0x0bbe007e
.word 0x475da353

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
