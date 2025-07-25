/**
 * Standalone test for sampling the ML-DSA sparse schoolbook routine.
 */

.section .text.start

main:
  /* Init all-zero register. */
  bn.xor  w31, w31, w31

  /* MOD <= dmem[modulus] = DILITHIUM_Q */
  li      x5, 2
  la      x6, modulus
  bn.lid  x5, 0(x6)

  /* MOD 2nd word <= DILITHIUM_R */
  li      x5, 3
  la      x6, montg_R
  bn.lid  x5, 0(x6)
  bn.rshi w2, w3, w2 >> 224
  /* Write back MOD */
  bn.wsrw MOD, w2

  /* Load the representatives of the challenge polynomial. */
  li      x5, 28
  la      x6, cnz
  bn.lid  x5++, 0(x6)
  la      x6, csn
  bn.lid  x5, 0(x6)

  /* Compute the product. */
  la      x10, poly_b
  la      x11, poly_out
  jal     x1, poly_sparse_schoolbook

  ecall

.data

.balign 32
cnz:
  .word 0x80000244
  .word 0x40022848
  .word 0x010b0008
  .word 0x10940180
  .word 0x0882008c
  .word 0x00200810
  .word 0x06a08002
  .word 0x00003080

.balign 32
csn:
  .word 0x80000204
  .word 0x40002848
  .word 0x01010000
  .word 0x10800080
  .word 0x00800080
  .word 0x00200010
  .word 0x02208002
  .word 0x00000080

.balign 32
poly_out:
.zero 1024

.balign 32
poly_b:
  .word 0x00526eb6
  .word 0x004358f7
  .word 0x000ec604
  .word 0x0046c5d9
  .word 0x00669bc9
  .word 0x003d459a
  .word 0x0032ef95
  .word 0x0076875f
  .word 0x007510d8
  .word 0x007c97f9
  .word 0x0052291a
  .word 0x00117e73
  .word 0x00281c0e
  .word 0x006ee3ed
  .word 0x006a2c6b
  .word 0x005b0ddc
  .word 0x000b2e00
  .word 0x000ae921
  .word 0x0013dc54
  .word 0x00419c9e
  .word 0x00731afc
  .word 0x0010d17e
  .word 0x0010eb08
  .word 0x003200c6
  .word 0x0022655a
  .word 0x00728e50
  .word 0x0048be98
  .word 0x005a7850
  .word 0x006ca29a
  .word 0x000a2e7b
  .word 0x0060d155
  .word 0x0008bc98
  .word 0x000beff2
  .word 0x000159a2
  .word 0x0036ffb1
  .word 0x0005d60f
  .word 0x004bed64
  .word 0x002e6c98
  .word 0x000fe6b2
  .word 0x006ca17f
  .word 0x0070568e
  .word 0x00383a98
  .word 0x0077274c
  .word 0x0015a9c6
  .word 0x000bb3fb
  .word 0x007315d1
  .word 0x0064d856
  .word 0x002591f2
  .word 0x004ab4d9
  .word 0x0062095a
  .word 0x0059b200
  .word 0x002b5dd9
  .word 0x007c46e2
  .word 0x0000a4ad
  .word 0x00388165
  .word 0x0065535a
  .word 0x002bb319
  .word 0x005ae4cc
  .word 0x00132b82
  .word 0x00286e6f
  .word 0x0002293c
  .word 0x00736c85
  .word 0x00419879
  .word 0x00782f9f
  .word 0x005a8814
  .word 0x00368702
  .word 0x007c1855
  .word 0x006f1cce
  .word 0x00515c28
  .word 0x00553ea4
  .word 0x0012c0bf
  .word 0x004d6514
  .word 0x0061ec4e
  .word 0x002f6165
  .word 0x0001f994
  .word 0x001661c5
  .word 0x0019d59d
  .word 0x0055cd75
  .word 0x003e8dd4
  .word 0x00439048
  .word 0x00463b11
  .word 0x005815b5
  .word 0x004edc1f
  .word 0x00249667
  .word 0x0029abd6
  .word 0x006787b2
  .word 0x004d0501
  .word 0x0006a17f
  .word 0x00434e5b
  .word 0x0000cdec
  .word 0x003b9153
  .word 0x0063731d
  .word 0x000fea8e
  .word 0x004d4026
  .word 0x00273440
  .word 0x004bac6d
  .word 0x00150d54
  .word 0x0005aa69
  .word 0x006d4848
  .word 0x0013bc37
  .word 0x002c5a14
  .word 0x00002f4e
  .word 0x004b9f58
  .word 0x001888f9
  .word 0x00382c33
  .word 0x0000ad44
  .word 0x00147266
  .word 0x00602f9a
  .word 0x00110d63
  .word 0x001b1154
  .word 0x0002ee50
  .word 0x0037feca
  .word 0x001955cc
  .word 0x0035ca1f
  .word 0x005c2fa9
  .word 0x00421a2f
  .word 0x000145c2
  .word 0x0037d2c2
  .word 0x004b6539
  .word 0x000e79f5
  .word 0x0049394c
  .word 0x00387c92
  .word 0x007ea027
  .word 0x0019534f
  .word 0x00683143
  .word 0x001c68b6
  .word 0x00080711
  .word 0x005ea978
  .word 0x0069c13c
  .word 0x00569bec
  .word 0x0053caa1
  .word 0x0034b7ab
  .word 0x002b886e
  .word 0x0054e2d7
  .word 0x004cdaaa
  .word 0x007e0ab2
  .word 0x001cb518
  .word 0x00053ab2
  .word 0x001257b4
  .word 0x0043f86c
  .word 0x003a5410
  .word 0x00666dd1
  .word 0x005fd405
  .word 0x00420dd6
  .word 0x0067b356
  .word 0x006b7038
  .word 0x00716120
  .word 0x0076966c
  .word 0x006a1676
  .word 0x000e5822
  .word 0x00565072
  .word 0x00259ab7
  .word 0x007cc46a
  .word 0x0053816e
  .word 0x005a7cce
  .word 0x0059d2f7
  .word 0x00716cf9
  .word 0x004e5716
  .word 0x0013dd49
  .word 0x003f0f31
  .word 0x0035cbb5
  .word 0x0012ca09
  .word 0x001ad985
  .word 0x0032d9bb
  .word 0x0063f001
  .word 0x0069bfc5
  .word 0x006a8cd2
  .word 0x007d872c
  .word 0x000078f2
  .word 0x006023b4
  .word 0x000f146a
  .word 0x0034b9e9
  .word 0x004c0719
  .word 0x003edbc3
  .word 0x006224af
  .word 0x0076bbf7
  .word 0x001e14ad
  .word 0x001a6569
  .word 0x006f703b
  .word 0x003ab5a1
  .word 0x0024a6ad
  .word 0x00135811
  .word 0x0067e9e3
  .word 0x006b20e6
  .word 0x0030c797
  .word 0x003a2f9c
  .word 0x0045dee9
  .word 0x00796a29
  .word 0x000bd6c5
  .word 0x006b2e3d
  .word 0x003d8c3f
  .word 0x00637cf9
  .word 0x0065996b
  .word 0x006a6c84
  .word 0x002634cb
  .word 0x0027a5d3
  .word 0x00695ae7
  .word 0x007dcd84
  .word 0x006c3333
  .word 0x00729e74
  .word 0x003b6816
  .word 0x00749461
  .word 0x0024c3eb
  .word 0x00591975
  .word 0x0003b0b9
  .word 0x0052bfa3
  .word 0x0047c3bc
  .word 0x0022cce3
  .word 0x005607b6
  .word 0x0022c8c5
  .word 0x0033f43f
  .word 0x002d3080
  .word 0x00366744
  .word 0x0064ba46
  .word 0x00235576
  .word 0x0028fae1
  .word 0x0027b72c
  .word 0x002a813a
  .word 0x00484913
  .word 0x000615cd
  .word 0x00254f8b
  .word 0x001fc11d
  .word 0x007b8ea0
  .word 0x0011f567
  .word 0x003e6d9b
  .word 0x002c8c8d
  .word 0x00507fac
  .word 0x004b222b
  .word 0x00672783
  .word 0x00474cd7
  .word 0x0077cbce
  .word 0x0021b2c7
  .word 0x003d406f
  .word 0x0064cabe
  .word 0x0051f34f
  .word 0x005aca80
  .word 0x004fc191
  .word 0x003544aa
  .word 0x00407a80
  .word 0x000fda20
  .word 0x00539a96
  .word 0x005d8c70
  .word 0x0052f35f
  .word 0x007501a8
  .word 0x003e2b1a
  .word 0x00520f45
  .word 0x0051959f
  .word 0x0026667d
  .word 0x00034568
  .word 0x0057f287
  .word 0x0072624f
  .word 0x0071f630
  .word 0x0010553f
  .word 0x00685eb4
  .word 0x00126207
  .word 0x000bdac6

/* Modulus for reduction */
.global modulus
modulus:
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001

/* R for Montgomery multiplication */
.global montg_R
montg_R:
  .word 0xfc7fdfff
  .word 0xfc7fdfff
  .word 0xfc7fdfff
  .word 0xfc7fdfff
  .word 0xfc7fdfff
  .word 0xfc7fdfff
  .word 0xfc7fdfff
  .word 0xfc7fdfff
