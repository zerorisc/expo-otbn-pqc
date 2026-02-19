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
.word 0x4634d6f2
.word 0x379650f9
.word 0x9291b028
.word 0x2e29f43f
.word 0x278c3c64
.word 0x99751e12
.word 0xbf532c7d
.word 0xc9266963
.word 0x49db7c81
.word 0x46ad6931
.word 0xc80a30d6
.word 0x08a0c0c9
.word 0xeb1615b5
.word 0x27ae0d31
.word 0x1c8b1a36
.word 0xe50e44ac
.word 0x23aa5fe3
.word 0x04c30f0a
.word 0x2448527b
.word 0xc34881d7
.word 0xcd54c04e
.word 0xe285e679
.word 0xf55e4aab
.word 0x33a76318
.word 0xec6151a9
.word 0x27789283
.word 0xaa549999
.word 0x4d58264e
.word 0xe27242cb
.word 0xc98b6eb8
.word 0xae390be5
.word 0xaa616fc6
.word 0x305284be
.word 0xfe7b178b
.word 0xe5a591e0
.word 0xa2615331
.word 0x652a3aa6
.word 0x91ba57e5
.word 0xa144f300
.word 0xce5725bb
.word 0xd78ec4d8
.word 0x0ab5b97c
.word 0xeb964016
.word 0x6a0f61c2
.word 0xada83c58
.word 0xd58876bf
.word 0x92a17d65
.word 0x18849e17
.word 0xb6aa31a2
.word 0x6bc764a8
.word 0x72d89351
.word 0xc86c3331
.word 0x73520977
.word 0x73b3415f
.word 0x56bc2558
.word 0xb45f388c
.word 0x34994544
.word 0x74333783
.word 0xcb4acd7b
.word 0x9bd043b2
.word 0xef6422d9
.word 0x22c15ef4
.word 0x2a8affcc
.word 0xe08514da
.word 0xc6664618
.word 0x3a4a8569
.word 0x4b7bdbc0
.word 0xdc0032ca
.word 0x8c484f81
.word 0x2e62862e
.word 0x018ac5e2
.word 0x20d41bc4
.word 0x926526fe
.word 0x60537f29
.word 0x003ce776
.word 0x1a5bc2c3
.word 0x4a2491d3
.word 0x98036c8f
.word 0x0b6397ca
.word 0xc1488952
.word 0xb25a5d83
.word 0xb402a497
.word 0x195a1f33
.word 0x0cc5525f
.word 0xa162aa5e
.word 0xc3af78e6
.word 0xa887aa74
.word 0xdc13da45
.word 0x084865c1
.word 0x44ccf8d0
.word 0xbcb349d2
.word 0x0c7fc475
.word 0x359af45c
.word 0xaccceb3d
.word 0x3939c51b
.word 0x6c45267d
.word 0x3105039b
.word 0x934b7322
.word 0xa180faad
.word 0x33369722
.word 0x34b66cf4
.word 0x67fc6939
.word 0x75049192
.word 0xfc6ab9e9
.word 0x731167c5
.word 0xe8553483
.word 0x90214ef7
.word 0x5ab26f95
.word 0x639c11eb
.word 0x32cd9f12
.word 0xc2523100
.word 0x7fb2594b
.word 0x780109b5
.word 0xae2bdb74
.word 0x89bf0349
.word 0xd4616006
.word 0x8f169bb2
.word 0x87a14695
.word 0x2c9279c5
.word 0xc9697b20
.word 0x4f1d00ec
.word 0x191e10cc
.word 0xb0891802
.word 0xb7c19bfd
.word 0x251c3ec4
.word 0x69fc9941
.word 0x616e6bf0
.word 0x19fe5ae2
.word 0x601b125c
.word 0xc3c602c0
.word 0x13d55a78
.word 0x77304f2a
.word 0xb9cdebd4
.word 0x4ab17e46
.word 0x6268c6c1
.word 0x876b83d8
.word 0x24883bd7
.word 0x3e25c7b3
.word 0xa110d184
.word 0x07a59141
.word 0x7fd0738e
.word 0x5e150466
.word 0x01309a1b
.word 0x56a21f20
.word 0x44481b1e
.word 0x939e57c2
.word 0x76149440
.word 0x168707d9
.word 0x4cd1ba2c
.word 0x6c061f38
.word 0x9d3daa5b
.word 0x50a81907
.word 0x187cdcb4
.word 0x80a82232
.word 0xb3736df2
.word 0x1e1c3761
.word 0xee4102b6
.word 0x109a2478
.word 0x776c371b
.word 0xa4196753
.word 0x59cd8056
.word 0xb26b7847
.word 0x940c46ec
.word 0xdb951566
.word 0x23581a8c
.word 0xaa98c058
.word 0x2c27338b
.word 0x935828cb
.word 0x9ac0a591
.word 0xd790af5b
.word 0x2bbad0ce
.word 0x2f62ec53
.word 0xf5fab3c4
.word 0x8ae1b379
.word 0xa442d4f0
.word 0xca61845c
.word 0xc3d3aa84
.word 0x6d29aa97
.word 0xd7d90ea4
.word 0x9931a52e
.word 0x92314719
.word 0x5721cde3
.word 0x6c957d2a
.word 0x5d964029
.word 0xdc50333a
.word 0x7bbce908
.word 0x057e89f6
.word 0x3ab90ce1
.word 0x1bbc089a
.word 0x4c818820
.word 0xf1de2d18
.word 0x16469c9d
.word 0xddad0976
.word 0x32646172
.word 0x5c879396
.word 0xd8622929
.word 0x04b55d79
.word 0x8969f85b
.word 0xd8938b1e
.word 0x4110cd72
.word 0x5dc89e74
.word 0x78700c0d
.word 0x9cc3857a
.word 0x3a68132f
.word 0x289e85c1
.word 0x23e5c820
.word 0x96ba46a1
.word 0xa63a4917
.word 0x47790275
.word 0x8635b49f
.word 0x4bbb7198
.word 0x8bdd10dc
.word 0x4c898e06
.word 0xf49cb570
.word 0x09db2156
.word 0xbe10910f
.word 0x88cda5b1
.word 0xca267419
.word 0x35d76432
.word 0xf993f95f
.word 0xc94022fa
.word 0x15528e3f
.word 0x05ac9065
.word 0x75d51ee1
.word 0xaa22b460
.word 0x386d500e
.word 0x82339590
.word 0x3612b229
.word 0xb65f9b14
.word 0xe9892923
.word 0x51468207
.word 0xb81319ea
.word 0x4ce36162
.word 0x6ad343ca
.word 0xee65fc14
.word 0x4c413b51
.word 0x089bf06f
.word 0x2a2683f4
.word 0x804e589c
.word 0x48e30c38
.word 0xbc31a954
.word 0x095c91d3
.word 0x56c63aa7
.word 0x051776e4
.word 0xac0a335a
.word 0x283aee1b
.word 0xe768eb1a
.word 0x6c81adb6
.word 0x2a16f651
.word 0x14297849
.word 0xb40f81d2
.word 0xb4609282
.word 0xfb169093
.word 0x03150d32
.word 0x97a8bcad
.word 0x9f4a0110
.word 0xacf162b5
.word 0xcfdcad2a
.word 0x73303699
.word 0x89f81e26
.word 0x865c0748
.word 0xaca5e15e
.word 0x19107fc3
.word 0x34b9c53a
.word 0x569c57d7
.word 0x82c3c010
.word 0x8508b7b9
.word 0x3e7953db
.word 0xf8f8a55a
.word 0xbec6907e
.word 0x9e4490da
.word 0x41c75b2a
.word 0x5e1be5b5
.word 0xea5560c6
.word 0x65fb9ae3
.word 0x21fb7dc0
.word 0xd64a9c02
.word 0xbcccbd4c
.word 0x2969f601
.word 0x8f352c09
.word 0x38fa25b5
.word 0x2c728e0b
.word 0xbe0d012c
.word 0x01256e67
.word 0x8a12bac6
.word 0x3318d1e7
.word 0x76b48ac8
.word 0x8bb9ea0c
.word 0xb689854e
.word 0xa93b4dca
.word 0x32f1bac8
.word 0xb1525c47
.word 0x1969b847
.word 0x8722d298
.word 0x71bda049
.word 0x38419916
.word 0x92148d12
.word 0x950c4755
.word 0x35605c47
.word 0xaa3cc527
.word 0xdc93e3d6
.word 0x153d4818
.word 0x825abb29
.word 0x2a748499
.word 0xd275120a
.word 0x8e4c3737
.word 0x45543473
.word 0xd768847c
.word 0x8d984a00
.word 0xd6175167
.word 0x14bc4815
.word 0x55bc45c4
.word 0x6e59189c
.word 0x73e830d8
.word 0x9ac7625a
.word 0x4fae62d8
.word 0x6c907873
.word 0x7cd52db0
.word 0xe42541e3
.word 0x26f570b8
.word 0x2455a827
.word 0xbecbb148
.word 0x6a148526
.word 0x82857d62
.word 0x6b0bf4eb
.word 0x858208cb
.word 0x5eeafc69
.word 0x3db42501
.word 0xaa0e04bb
.word 0x5602ea7a
.word 0xf94687dd
.word 0xf7328b1c
.word 0x23759490
.word 0x1718a86d
.word 0x58fa7f35
.word 0x4e304918
.word 0xad53c437
.word 0x41cf6491
.word 0x09a9a248
.word 0x98a87cf5
.word 0x260395d5
.word 0x1489987f
.word 0x690cc66c
.word 0x663879a1
.word 0x9170a713
.word 0x8e86b77e
.word 0x2b5f9213
.word 0x71c3f32e
.word 0x4b008c02
.word 0xf1b850b0
.word 0x8536c031
.word 0x98bc6722
.word 0xf89839fa
.word 0xcd96a89a
.word 0xf302d2bb
.word 0x738c8313
.word 0x8df5d52e
.word 0xf8a4a5cb
.word 0xccff26a6
.word 0x49cc695b
.word 0x1f6f80f9
.word 0x83016b5b
.word 0x74221433
.word 0xce1f0b8b
.word 0x19cd88e1
.word 0xae124f89
.word 0x68c3a952
.word 0x3808263c
.word 0x3f33e337
.word 0xcca33533
.word 0x92ef6db7
.word 0x1ba2ac52
.word 0x190b3157
.word 0x92157bb8
.word 0x77b6a73a
.word 0x175c65a4
.word 0xebb96730
.word 0xc4b87aa9
.word 0xb13f88f6
.word 0x604d90d9
.word 0x11590569
.word 0x3c53925e
.word 0x48535f40
.word 0x4bf09d7e
.word 0xeaf02b99
.word 0xbfd060da
.word 0xcdbe7842
.word 0x68a89920
.word 0xf9f60d78
.word 0x7eb08838
.word 0x4c3cc39a
.word 0x8a5093ef

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
