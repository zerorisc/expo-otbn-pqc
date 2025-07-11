.text

.globl test_bnmulv_8S
test_bnmulv_8S:
  /* 0 -- 0: no acc -- standard */
  bn.mulv.8S.even w2, w0, w1
  bn.sid x6, 0(x7++)

  bn.mulv.8S.odd w2, w0, w1
  bn.sid x6, 0(x7++)

  /* 0 -- 1: no acc -- .lo */
  bn.mulv.8S.even.lo w2, w0, w1
  bn.sid x6, 0(x7++)

  bn.mulv.8S.odd.lo w2, w0, w1
  bn.sid x6, 0(x7++)

  /* 0 -- 2: no acc -- .hi */
  bn.mulv.8S.even.hi w2, w0, w1
  bn.sid x6, 0(x7++)

  bn.mulv.8S.odd.hi w2, w0, w1
  bn.sid x6, 0(x7++)

  /* 1 -- 0: acc -- standard */
  bn.mulv.8S.even.acc w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.8S.odd.acc w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 1 -- 1: acc -- .lo */
  bn.mulv.8S.even.acc.lo w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.8S.odd.acc.lo w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 1 -- 2: acc -- .hi */
  bn.mulv.8S.even.acc.hi w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.8S.odd.acc.hi w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 0: acc.z -- standard */
  bn.mulv.8S.even.acc.z w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.8S.odd.acc.z w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 1: acc.z -- .lo */
  bn.mulv.8S.even.acc.z.lo w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.8S.odd.acc.z.lo w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 2: acc.z -- .hi */
  bn.mulv.8S.even.acc.z.hi w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.8S.odd.acc.z.hi w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  ret

.globl test_bnmulv_16H
test_bnmulv_16H:
  /* 0 -- 0: no acc -- standard */
  bn.mulv.16H.even w2, w0, w1
  bn.sid x6, 0(x7++)

  bn.mulv.16H.odd w2, w0, w1
  bn.sid x6, 0(x7++)

  /* 0 -- 1: no acc -- .lo */
  bn.mulv.16H.lo w2, w0, w1
  bn.sid x6, 0(x7++)

  /* 0 -- 2: no acc -- .hi */
  bn.mulv.16H.hi w2, w0, w1
  bn.sid x6, 0(x7++)

  /* 1 -- 0: acc -- standard */
  bn.mulv.16H.even.acc w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.16H.odd.acc w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 1 -- 1: acc -- .lo */
  bn.mulv.16H.acc.lo w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 1 -- 2: acc -- .hi */
  bn.mulv.16H.acc.hi w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 0: acc.z -- standard */
  bn.mulv.16H.even.acc.z w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.16H.odd.acc.z w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 1: acc.z -- .lo */
  bn.mulv.16H.acc.z.lo w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 2: acc.z -- .hi */
  bn.mulv.16H.acc.z.hi w2, w0, w1
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  ret

.globl test_bnmulvl_8S
test_bnmulvl_8S:
/* 0 -- 0: no acc -- standard */
  bn.mulv.l.8S.even w2, w0, sw0.5
  bn.sid x6, 0(x7++)

  bn.mulv.l.8S.odd w2, w0, sw0.5
  bn.sid x6, 0(x7++)

  /* 0 -- 1: no acc -- .lo */
  bn.mulv.l.8S.even.lo w2, w0, sw0.5
  bn.sid x6, 0(x7++)

  bn.mulv.l.8S.odd.lo w2, w0, sw0.5
  bn.sid x6, 0(x7++)

  /* 0 -- 2: no acc -- .hi */
  bn.mulv.l.8S.even.hi w2, w0, sw0.5
  bn.sid x6, 0(x7++)

  bn.mulv.l.8S.odd.hi w2, w0, sw0.5
  bn.sid x6, 0(x7++)

  /* 1 -- 0: acc -- standard */
  bn.mulv.l.8S.even.acc w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.l.8S.odd.acc w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 1 -- 1: acc -- .lo */
  bn.mulv.l.8S.even.acc.lo w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.l.8S.odd.acc.lo w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 1 -- 2: acc -- .hi */
  bn.mulv.l.8S.even.acc.hi w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.l.8S.odd.acc.hi w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 0: acc.z -- standard */
  bn.mulv.l.8S.even.acc.z w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.l.8S.odd.acc.z w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 1: acc.z -- .lo */
  bn.mulv.l.8S.even.acc.z.lo w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.l.8S.odd.acc.z.lo w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 2: acc.z -- .hi */
  bn.mulv.l.8S.even.acc.z.hi w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.l.8S.odd.acc.z.hi w2, w0, sw0.5
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  ret

.globl test_bnmulvl_16H
test_bnmulvl_16H:
  /* 0 -- 0: no acc -- standard */
  bn.mulv.l.16H.even w2, w0, sw1.3
  bn.sid x6, 0(x7++)

  bn.mulv.l.16H.odd w2, w0, sw1.3
  bn.sid x6, 0(x7++)

  /* 0 -- 1: no acc -- .lo */
  bn.mulv.l.16H.lo w2, w0, sw1.3
  bn.sid x6, 0(x7++)

  /* 0 -- 2: no acc -- .hi */
  bn.mulv.l.16H.hi w2, w0, sw1.3
  bn.sid x6, 0(x7++)

  /* 1 -- 0: acc -- standard */
  bn.mulv.l.16H.even.acc w2, w0, sw1.3
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.l.16H.odd.acc w2, w0, sw1.3
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 1 -- 1: acc -- .lo */
  bn.mulv.l.16H.acc.lo w2, w0, sw1.3
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 1 -- 2: acc -- .hi */
  bn.mulv.l.16H.acc.hi w2, w0, sw1.3
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 0: acc.z -- standard */
  bn.mulv.l.16H.even.acc.z w2, w0, sw1.3
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  bn.mulv.l.16H.odd.acc.z w2, w0, sw1.3
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 1: acc.z -- .lo */
  bn.mulv.l.16H.acc.z.lo w2, w0, sw1.3
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  /* 2 -- 2: acc.z -- .hi */
  bn.mulv.l.16H.acc.z.hi w2, w0, sw1.3
  bn.sid x6, 0(x7++)
  bn.wsrr w3, 0x3
  bn.sid x8, 0(x7++)
  bn.wsrr w3, 0xb
  bn.sid x8, 0(x7++)

  ret
