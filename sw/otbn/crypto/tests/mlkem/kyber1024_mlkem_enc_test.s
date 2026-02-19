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
.word 0x3a096533
.word 0x5ed34fe5
.word 0xf658f7a7
.word 0x6018366c
.word 0x205738d1
.word 0x317017a6
.word 0xb46ee1da
.word 0x0b3510b0

.globl ek
ek: 
.word 0x855af8fe
.word 0x29aa88a9
.word 0x3323dc60
.word 0xbfa497ce
.word 0xc15988d3
.word 0xcd859f3a
.word 0xb1077097
.word 0x2819a0aa
.word 0x4bead185
.word 0x67c24c47
.word 0x29d9054c
.word 0x86810f41
.word 0x803374ad
.word 0x322339f1
.word 0x257987ab
.word 0xefb5f76d
.word 0x3a059175
.word 0x059a888b
.word 0xdd1af453
.word 0x9cb22865
.word 0x1afac202
.word 0x4e227757
.word 0x6c7777f4
.word 0x055244ba
.word 0x5d55845c
.word 0x8b603904
.word 0x36487280
.word 0x3428974c
.word 0xd08da229
.word 0xc4e84b2e
.word 0x54055ae7
.word 0xd9317a3b
.word 0x6d2581b8
.word 0xe53ca5ea
.word 0x748d4a58
.word 0x0743f330
.word 0x8a165785
.word 0x00c7a28a
.word 0x0468af18
.word 0x9f88a9b1
.word 0xdb4307ac
.word 0xcf403945
.word 0x35295ca8
.word 0xa3f25e40
.word 0x8b897188
.word 0x8e5697ab
.word 0xf3ea8c24
.word 0x5106a54e
.word 0x6e5a271a
.word 0x3ba3551c
.word 0x9271f635
.word 0xb66db865
.word 0x12345277
.word 0x096b5465
.word 0x46907cd2
.word 0x18f3a390
.word 0x61e4721e
.word 0x6d655136
.word 0x536141ba
.word 0x1172d24c
.word 0x2245e3bb
.word 0x3521a016
.word 0x30fc6e08
.word 0xf347fbf7
.word 0xf1e49140
.word 0xae312b90
.word 0xedcb0a53
.word 0x111d88ac
.word 0x5425346f
.word 0x06b20392
.word 0x30e57dd5
.word 0xbd0aaa2c
.word 0x7e4bb6ef
.word 0x31322828
.word 0x82cb059b
.word 0x2e849084
.word 0xf312b823
.word 0x3e160247
.word 0xfd59e5d3
.word 0x97e39826
.word 0x9713ca14
.word 0x819e128b
.word 0x3a9a6e77
.word 0xba979748
.word 0xf63ec2cc
.word 0xdc853877
.word 0x57f2a939
.word 0x9c1f32bb
.word 0x25ce076b
.word 0x9cb61e95
.word 0xbf7107ba
.word 0x58e32dcc
.word 0xcd18d2cd
.word 0x549de6cf
.word 0xf7167961
.word 0xcae17792
.word 0xe79ff191
.word 0x651760e1
.word 0x3e81a301
.word 0x7029d93c
.word 0x75b12c21
.word 0x0227057b
.word 0x54b0ca9f
.word 0xcb6d6b07
.word 0xcf4cae4e
.word 0x1550774a
.word 0xc2066446
.word 0x29196440
.word 0x707c85ac
.word 0xab5a8069
.word 0x79e1d3ab
.word 0x202da2b3
.word 0x1baa66a9
.word 0x751181cf
.word 0x8a2802e5
.word 0x8586a3ba
.word 0x063678c0
.word 0xfaa32359
.word 0xcce373ec
.word 0x997977cf
.word 0x8cab7830
.word 0x76486b00
.word 0xb3c6367f
.word 0xb017eb11
.word 0x97d0b8e3
.word 0x29358130
.word 0x2934435a
.word 0x46dbb2c1
.word 0xbe10cfc1
.word 0xe292b3c0
.word 0x0c592c03
.word 0x610a40c9
.word 0xf7ae4597
.word 0x1a3e1de6
.word 0x93913f7c
.word 0x9fce2635
.word 0x7bbb1b22
.word 0x7a126e93
.word 0x28205212
.word 0xd61e996c
.word 0xa090ba94
.word 0xbda6c2d0
.word 0x61b021f8
.word 0x6a3c8f68
.word 0xd44531b4
.word 0xa1830196
.word 0x6ddb62cb
.word 0x44807ad9
.word 0x25fa6b59
.word 0xbf70aa74
.word 0xfd0b903a
.word 0x3a27adfc
.word 0x042c309d
.word 0x0c65d545
.word 0x246f6aa7
.word 0x80e689b2
.word 0x6f4b0cfc
.word 0x27891b5c
.word 0x9db4f362
.word 0x43a1c143
.word 0x5548c90c
.word 0x7615fb18
.word 0x90c00352
.word 0xdc4224a7
.word 0x09593197
.word 0x939df708
.word 0x502a6d30
.word 0x49d24359
.word 0xe6aa5230
.word 0x05a345ec
.word 0x3b586412
.word 0x529834d0
.word 0x74fc0708
.word 0xb2d4b2ad
.word 0x9e658516
.word 0x0c541d9c
.word 0xb8b3cccd
.word 0xc62d3b31
.word 0x48d840ec
.word 0x5e763538
.word 0xe8a99881
.word 0xa4609fa0
.word 0x300b4063
.word 0x36bcf45e
.word 0x26a275bc
.word 0x22a2c821
.word 0xd2bdd6b2
.word 0xfaf0ac9c
.word 0x42b06a75
.word 0xcb2dfac8
.word 0x5bab20a2
.word 0x77735233
.word 0x2a56b7e6
.word 0x82c9a4e0
.word 0x899cd373
.word 0xfc0ab9e9
.word 0xc18b1720
.word 0x4f829961
.word 0xd2852bfd
.word 0xa1202d70
.word 0x5c24dec6
.word 0xc7b50058
.word 0x9b5a7fda
.word 0x27f0f68d
.word 0x3ca9a6c4
.word 0xc70e4a0c
.word 0x55e10584
.word 0xa7ca6690
.word 0xe16942ba
.word 0x8128fb54
.word 0x43412c25
.word 0xc11372d3
.word 0x8c922f29
.word 0x16cdca42
.word 0x601306cc
.word 0x28f555ca
.word 0x6e4fe256
.word 0x570e36e2
.word 0xb7a0ca49
.word 0xa011824f
.word 0xe7d0a7c4
.word 0x3fe98980
.word 0x4a76e414
.word 0x79249d33
.word 0x9bb06b8e
.word 0x5c2e462f
.word 0x4400b686
.word 0x71dc9fb3
.word 0x694058ad
.word 0xec6f91a5
.word 0x0f158123
.word 0x064b75fb
.word 0xe4915c49
.word 0x41ea1283
.word 0xc5a99028
.word 0xb72ba9a0
.word 0x4c032b0a
.word 0xac36110a
.word 0x70783da1
.word 0x4b49bd72
.word 0x8ec62b34
.word 0xa2ef6446
.word 0x5db9867c
.word 0x312a822c
.word 0x5b379974
.word 0x4d73df29
.word 0xb88427c8
.word 0x9b24b5b7
.word 0xc93b216f
.word 0x21a031d8
.word 0x378d8303
.word 0x95981ab9
.word 0x9440f4ed
.word 0x608217e8
.word 0x0866615e
.word 0x3e5d4cb0
.word 0x2717ce52
.word 0x06c4639c
.word 0xc857a5de
.word 0x07750c25
.word 0x75316e3b
.word 0x08cd7a80
.word 0xb2f08ba8
.word 0xa771f697
.word 0xa0b7a54c
.word 0xaaa96063
.word 0x5770d237
.word 0x5fbe0949
.word 0xc6728605
.word 0x34100334
.word 0x7913bb73
.word 0x30bccbb5
.word 0xca74ab18
.word 0x1c671151
.word 0xd0b0476b
.word 0x4f3210bc
.word 0x96915985
.word 0xa358c5d2
.word 0x3fe845c1
.word 0x6f1eda72
.word 0xd06ac8fa
.word 0x0e262080
.word 0xc4a98762
.word 0xd0e33fd8
.word 0x10c2cebf
.word 0x853a62a1
.word 0xd1bb8793
.word 0x45a05115
.word 0x26be55d0
.word 0x1a812643
.word 0x9a3120be
.word 0x7e6021d3
.word 0x87994156
.word 0x282625be
.word 0x42a2b710
.word 0x6265cbe7
.word 0xc0d71d8b
.word 0x8289d8f4
.word 0x45066515
.word 0x3d5c3614
.word 0xaf7bb474
.word 0x43ae4b4a
.word 0x96a54a9d
.word 0x172af9b0
.word 0x14bc8b70
.word 0x5dc7d51b
.word 0xd971eba5
.word 0xbc8e3002
.word 0x83861734
.word 0x0063f15a
.word 0xc804ba34
.word 0x28e6bba7
.word 0x998b212a
.word 0xf2111862
.word 0x26c57963
.word 0xaf6081f4
.word 0x5a95b399
.word 0xbb88bb37
.word 0x0982ba4e
.word 0xc2589877
.word 0x800b2abf
.word 0xad26fc70
.word 0x791461da
.word 0x7ecabe65
.word 0xefb2e2f2
.word 0xe3561f9a
.word 0x4de5ce3e
.word 0x371c774c
.word 0xa45a9582
.word 0x51390c55
.word 0x1d3a0852
.word 0xec039a20
.word 0x6c06a205
.word 0x09692b0c
.word 0xf8099f78
.word 0x86151cc1
.word 0xc00751e4
.word 0xb5f538a1
.word 0x44c1d479
.word 0xb17699ce
.word 0x25cdc7f1
.word 0x1851545d
.word 0x1d61da3a
.word 0x07df76c1
.word 0x3d55e86b
.word 0x1c7b0514
.word 0x8b7ac01b
.word 0x9fe7093f
.word 0xaa2828ce
.word 0x59057ab4
.word 0xa1c49100
.word 0xe506f8b7
.word 0xe19013d5
.word 0x97366389
.word 0x0453b90d
.word 0xa4eca84b
.word 0x7ea9c817
.word 0x5e61c1ff
.word 0x0c2567d4
.word 0xb7b54356
.word 0x556780c5
.word 0xb62195f8
.word 0xb40b0740
.word 0xa56d549c
.word 0xd6e38562
.word 0x1f17cbb7
.word 0x5b84a648
.word 0x1314b550
.word 0x4243b754
.word 0xa4a5dc51
.word 0x253f3692
.word 0x8b6ba740
.word 0xa560e3f7
.word 0x061a877b
.word 0x4674ff8a
.word 0xf59d7783
.word 0x8978be6c
.word 0xc9767656
.word 0x54a5e76c
.word 0xbb3d5be0
.word 0x2a1c8491
.word 0x60558933
.word 0x47832060
.word 0xbd93235c
.word 0xb713b99b
.word 0x6fe0ae52
.word 0x39d8efab
.word 0x4d5728e0
.word 0x71c42b3c
.word 0x20614aee
.word 0x04ad5789
.word 0x04073906

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
