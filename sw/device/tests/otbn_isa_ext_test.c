// Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
// Modified by phamhnh.

#include "sw/device/lib/dif/dif_otbn.h"
#include "sw/device/lib/testing/entropy_testutils.h"
#include "sw/device/lib/testing/otbn_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

enum {
  /**
   * Data width of big number subset, in bytes.
   */
  kOtbnWlenBytes = 256 / 8,
};

OTTF_DEFINE_TEST_CONFIG();


// Testcase for bn.addv and bn.subv
OTBN_DECLARE_APP_SYMBOLS(bnaddsubv_test);
OTBN_DECLARE_SYMBOL_ADDR(bnaddsubv_test, operand1);
OTBN_DECLARE_SYMBOL_ADDR(bnaddsubv_test, result);
static const otbn_app_t kAppBnAddSubVTest = OTBN_APP_T_INIT(bnaddsubv_test);
static const otbn_addr_t kBnAddSubVOperands = OTBN_ADDR_T_INIT(bnaddsubv_test, operand1);
static const otbn_addr_t kBnAddSubVResult = OTBN_ADDR_T_INIT(bnaddsubv_test, result);

// Testcase for bn.addvm and bn.subvm
OTBN_DECLARE_APP_SYMBOLS(bnaddsubvm_test);
OTBN_DECLARE_SYMBOL_ADDR(bnaddsubvm_test, operand1);
OTBN_DECLARE_SYMBOL_ADDR(bnaddsubvm_test, result);
static const otbn_app_t kAppBnAddSubVMTest = OTBN_APP_T_INIT(bnaddsubvm_test);
static const otbn_addr_t kBnAddSubVMOperands = OTBN_ADDR_T_INIT(bnaddsubvm_test, operand1);
static const otbn_addr_t kBnAddSubVMResult = OTBN_ADDR_T_INIT(bnaddsubvm_test, result);

// Testcase for bn.mulv
OTBN_DECLARE_APP_SYMBOLS(bnmulv_test);
OTBN_DECLARE_SYMBOL_ADDR(bnmulv_test, operand1);
OTBN_DECLARE_SYMBOL_ADDR(bnmulv_test, result);
static const otbn_app_t kAppBnMulVTest = OTBN_APP_T_INIT(bnmulv_test);
static const otbn_addr_t kBnMulVOperands = OTBN_ADDR_T_INIT(bnmulv_test, operand1);
static const otbn_addr_t kBnMulVResult = OTBN_ADDR_T_INIT(bnmulv_test, result);

// Testcase for bn.mulv.l
OTBN_DECLARE_APP_SYMBOLS(bnmulvl_test);
OTBN_DECLARE_SYMBOL_ADDR(bnmulvl_test, operand1);
OTBN_DECLARE_SYMBOL_ADDR(bnmulvl_test, result);
static const otbn_app_t kAppBnMulVLTest = OTBN_APP_T_INIT(bnmulvl_test);
static const otbn_addr_t kBnMulVLOperands = OTBN_ADDR_T_INIT(bnmulvl_test, operand1);
static const otbn_addr_t kBnMulVLResult = OTBN_ADDR_T_INIT(bnmulvl_test, result);

// Testcase for bn.mulvm
OTBN_DECLARE_APP_SYMBOLS(bnmulvm_test);
OTBN_DECLARE_SYMBOL_ADDR(bnmulvm_test, operand1);
OTBN_DECLARE_SYMBOL_ADDR(bnmulvm_test, result);
static const otbn_app_t kAppBnMulVMTest = OTBN_APP_T_INIT(bnmulvm_test);
static const otbn_addr_t kBnMulVMOperands = OTBN_ADDR_T_INIT(bnmulvm_test, operand1);
static const otbn_addr_t kBnMulVMResult = OTBN_ADDR_T_INIT(bnmulvm_test, result);

// Testcase for bn.mulvm.l
OTBN_DECLARE_APP_SYMBOLS(bnmulvml_test);
OTBN_DECLARE_SYMBOL_ADDR(bnmulvml_test, operand1);
OTBN_DECLARE_SYMBOL_ADDR(bnmulvml_test, result);
static const otbn_app_t kAppBnMulVMLTest = OTBN_APP_T_INIT(bnmulvml_test);
static const otbn_addr_t kBnMulVMLOperands = OTBN_ADDR_T_INIT(bnmulvml_test, operand1);
static const otbn_addr_t kBnMulVMLResult = OTBN_ADDR_T_INIT(bnmulvml_test, result);

#define M32 0xFFFFFFFF
#define M16 0x0000FFFF
#define QINV_K 3327 // -q^-1 mod 2^16, q = 3329
#define QINV_D 4236238847 // -q^-1 mod 2^32, q = 8380417

uint16_t montgomery_reduce_16(uint32_t a, uint16_t q, uint32_t qinv)
{
  uint16_t t;

  t = (uint16_t)((a & M16) * qinv);
  t = (a + (uint32_t)t * q) >> 16;
  if (t >= q)
    t -= q;
  return t;
}

uint32_t montgomery_reduce_32(uint64_t a, uint32_t q, uint64_t qinv) {
  uint32_t t;

  t = (uint32_t)((uint64_t)(a & M32) * qinv);
  t = (a + (uint64_t)t * q) >> 32;
  if (t >= q)
    t -= q;
  return t;
}

// Testvectors
static const uint32_t kExpectedBnAddSubV[] = {
    0x0, 
    0x0, 
    0x0, 
    0x0, 
    0x0, 
    0x0, 
    0x0, 
    0x0,
    0x2, 
    0x4, 
    0x6, 
    0x8, 
    0xa, 
    0xc, 
    0xe, 
    0x10, 
    0xfffffffe, 
    0xfffffffd, 
    0xfffffffc, 
    0xfffffffb, 
    0xfffffffa, 
    0xfffffff9, 
    0xfffffff8, 
    0xfffffff7, 
    0x0, 
    0x1, 
    0x2, 
    0x3, 
    0x4, 
    0x5, 
    0x6, 
    0x7, 
    0x0, 
    0x0, 
    0x0, 
    0x0, 
    0x0, 
    0x0, 
    0x0, 
    0x0,
    0x00040002, 
    0x00080006, 
    0x000c000a, 
    0x0010000e, 
    0x00140012, 
    0x00180016, 
    0x001c001a, 
    0x0020001e,
    0xfffdfffe, 
    0xfffbfffc, 
    0xfff9fffa, 
    0xfff7fff8, 
    0xfff5fff6, 
    0xfff3fff4, 
    0xfff1fff2, 
    0xffeffff0, 
    0x00010000, 
    0x00030002, 
    0x00050004, 
    0x00070006, 
    0x00090008, 
    0x000b000a, 
    0x000d000c, 
    0x000f000e
};

static const uint32_t kExpectedBnAddSubVM[] = {
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000002,  
    0x00000004,  
    0x00000006,  
    0x00000008,  
    0x0000000A,  
    0x0000000C,  
    0x0000000E,  
    0x00000010,  
    0x007FDFFF,  
    0x007FDFFE,  
    0x007FDFFD,  
    0x007FDFFC,  
    0x007FDFFB,  
    0x007FDFFA,  
    0x007FDFF9,  
    0x007FDFF8,  
    0x00000000,  
    0x00000001,  
    0x00000002,  
    0x00000003,  
    0x00000004,  
    0x00000005,  
    0x00000006,  
    0x00000007,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00000000,  
    0x00040002,  
    0x00080006,  
    0x000c000a,  
    0x0010000e,  
    0x00140012,  
    0x00180016,  
    0x001c001a,  
    0x0020001e,  
    0x0CFE0CFF,  
    0x0CFC0CFD,  
    0x0CFA0CFB,  
    0x0CF80CF9,  
    0x0CF60CF7,  
    0x0CF40CF5,  
    0x0CF20CF3,  
    0x0CF00CF1,  
    0x00010000,  
    0x00030002,  
    0x00050004,  
    0x00070006,  
    0x00090008,  
    0x000b000a,  
    0x000d000c,  
    0x000f000e   
};

static const uint32_t kOperandsBnAddSubV[] = {
    0x00000001, 
    0x00000002,
    0x00000003, 
    0x00000004,
    0x00000005, 
    0x00000006,
    0x00000007, 
    0x00000008,
    0x00000001, 
    0x00000002,
    0x00000003, 
    0x00000004,
    0x00000005, 
    0x00000006,
    0x00000007, 
    0x00000008,
    0xffffffff, 
    0xffffffff,
    0xffffffff, 
    0xffffffff,
    0xffffffff, 
    0xffffffff,
    0xffffffff, 
    0xffffffff,
    0x00020001, 
    0x00040003, 
    0x00060005, 
    0x00080007,
    0x000a0009, 
    0x000c000b, 
    0x000e000d, 
    0x0010000f, 
    0x00020001, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000a0009, 
    0x000c000b, 
    0x000e000d, 
    0x0010000f,
    0xffffffff, 
    0xffffffff,
    0xffffffff, 
    0xffffffff,
    0xffffffff, 
    0xffffffff,
    0xffffffff, 
    0xffffffff,
};

static const uint32_t kOperandsBnAddSubVM[] = {
    0x00000001, 
    0x00000002,
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008, 
    0x00000001, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008,     
    0x007fe000, 
    0x007fe000, 
    0x007fe000, 
    0x007fe000, 
    0x007fe000, 
    0x007fe000, 
    0x007fe000, 
    0x007fe000, 
    0x00020001, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000a0009, 
    0x000c000b, 
    0x000e000d, 
    0x0010000f, 
    0x00020001, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000a0009, 
    0x000c000b, 
    0x000e000d, 
    0x0010000f, 
    0x0D000D00, 
    0x0D000D00, 
    0x0D000D00, 
    0x0D000D00, 
    0x0D000D00, 
    0x0D000D00, 
    0x0D000D00, 
    0x0D000D00, 
};

static const uint32_t kOperandsBnMulV[] = {
    0x00000001, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008,     
    0x007fe000, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008,     
    0x00020001, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000A0009, 
    0x000C000B, 
    0x000E000D, 
    0x0010000F,     
    0x0D000D00, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000A0009, 
    0x000C000B, 
    0x000E000D, 
    0x0010000F, 
};

static const uint32_t kOperandsBnMulVL[] = {
    0x00000001, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008,    
    0x007fe000, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008, 
    0x00020001, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000A0009, 
    0x000C000B, 
    0x000E000D, 
    0x0010000F,     
    0x0D000D00, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000A0009, 
    0x000C000B, 
    0x000E000D, 
    0x0010000F, 
};

static const uint32_t kOperandsBnMulVM[] = {
    0x00000001, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008,     
    0x007fe000, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008, 
    0x00020001, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000A0009, 
    0x000C000B, 
    0x000E000D, 
    0x0010000F,     
    0x0D000D00, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000A0009, 
    0x000C000B, 
    0x000E000D, 
    0x0010000F, 
};

static const uint32_t kOperandsBnMulVML[] = {
    0x00000001, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008,     
    0x007fe000, 
    0x00000002, 
    0x00000003, 
    0x00000004, 
    0x00000005, 
    0x00000006, 
    0x00000007, 
    0x00000008,     
    0x00020001, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000A0009, 
    0x000C000B, 
    0x000E000D, 
    0x0010000F,     
    0x0D000D00, 
    0x00040003, 
    0x00060005, 
    0x00080007, 
    0x000A0009, 
    0x000C000B, 
    0x000E000D, 
    0x0010000F, 
};

// Testcase for bn.addv and bn.subv
static void test_bnaddsubv(dif_otbn_t *otbn){
  // Load the Smoke Test App
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppBnAddSubVTest));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(kOperandsBnAddSubV), &kOperandsBnAddSubV, kBnAddSubVOperands)); 
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  for (uint32_t i = 0; i < 32 * 8; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnAddSubVResult + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);
    for (uint32_t j = 0; j < 8; j++) {
      CHECK(data[j] == kExpectedBnAddSubV[j + (i / kOtbnWlenBytes * 8)],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], kExpectedBnAddSubV[j + (i / kOtbnWlenBytes * 8)]);
    }
  }
}

// Testcase for bn.addvm and bn.subvm
static void test_bnaddsubvm(dif_otbn_t *otbn){
  // Load the Smoke Test App
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppBnAddSubVMTest));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(kOperandsBnAddSubVM), &kOperandsBnAddSubVM, kBnAddSubVMOperands)); 
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  for (uint32_t i = 0; i < 32 * 8; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnAddSubVMResult + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);
    for (uint32_t j = 0; j < 8; j++) {
      CHECK(data[j] == kExpectedBnAddSubVM[j+(i/kOtbnWlenBytes*8)],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], kExpectedBnAddSubVM[j + (i / kOtbnWlenBytes * 8)]);
    }
  }
}

// Testcase for bn.mulv
static void test_bnmulv(dif_otbn_t *otbn){
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppBnMulVTest));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(kOperandsBnMulV), &kOperandsBnMulV, kBnMulVOperands)); 
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));
  
  uint32_t result[8];
  uint32_t lo, hi;

  LOG_INFO("Check bn.mulv.8S");
  for (uint32_t i = 0; i < 32; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnMulVResult + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);
    for (uint32_t j = 0; j < 8; j++) {
      result[j] = kOperandsBnMulV[0 + j] * kOperandsBnMulV[8 + j];
      CHECK(data[j] == result[j],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], result[j]);
    }
  }

  LOG_INFO("Check bn.mulv.16H");
  for (uint32_t i = 0; i < 32; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnMulVResult + 32 + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);
    for (uint32_t j = 0; j < 8; j++) {
      lo = ((kOperandsBnMulV[16 + j] & M16) * (kOperandsBnMulV[24 + j] & M16)) & M16;
      hi = ((kOperandsBnMulV[16 + j] >> 16) * (kOperandsBnMulV[24 + j] >> 16)) & M16;
      result[j] = lo | (hi << 16);
      CHECK(data[j] == result[j],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], result[j]);
    }
  }
}

// Testcase for bn.mulv.l
static void test_bnmulvl(dif_otbn_t *otbn){
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppBnMulVLTest));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(kOperandsBnMulVL), &kOperandsBnMulVL, kBnMulVLOperands)); 
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));
  
  uint32_t result[8];
  uint32_t op16, lo, hi;
  int idx = 0;

  LOG_INFO("Check bn.mulv.l.8S");
  for (uint32_t i = 0; i < 32*8; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnMulVLResult + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);
    for (uint32_t j = 0; j < 8; j++) {
      result[j] = kOperandsBnMulVL[0 + j] * kOperandsBnMulVL[8 + (i/kOtbnWlenBytes)];
      CHECK(data[j] == result[j],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], result[j]);
    }
  }

  LOG_INFO("Check bn.mulv.l.16H");
  for (uint32_t i = 0; i < 32*16; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnMulVLResult + 32*8 + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);

    op16 = kOperandsBnMulVML[24 + (idx / 2)];
    if (idx & 1)
      op16 >>= 16;
    op16 &= M16;
    idx += 1;

    for (uint32_t j = 0; j < 8; j++) {
      lo = ((kOperandsBnMulVL[16 + j] & M16) * op16) & M16;
      hi = ((kOperandsBnMulVL[16 + j] >> 16) * op16) & M16;
      result[j] = lo | (hi << 16);
      CHECK(data[j] == result[j],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], result[j]);
    }
  }
}

// Testcase for bn.mulvm
static void test_bnmulvm(dif_otbn_t *otbn){
  // Load the Smoke Test App
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppBnMulVMTest));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(kOperandsBnMulVM), &kOperandsBnMulVM, kBnMulVMOperands)); 
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));
  
  uint32_t result[8];
  uint32_t lo, hi;

  LOG_INFO("Check bn.mulvm.8S");
  for (uint32_t i = 0; i < 32; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnMulVMResult + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);
    for (uint32_t j = 0; j < 8; j++) {
      uint64_t prod = (uint64_t)kOperandsBnMulVM[0 + j] * kOperandsBnMulVM[8 + j];
      result[j] = montgomery_reduce_32(prod, 8380417, QINV_D);
      CHECK(data[j] == result[j],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], result[j]);
    }
  }

  LOG_INFO("Check bn.mulvm.16H");
  for (uint32_t i = 0; i < 32; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnMulVMResult + 32 + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);

    uint32_t prod;
    for (uint32_t j = 0; j < 8; j++) {
      prod = (kOperandsBnMulVM[16 + j] & M16) * (kOperandsBnMulVM[24 + j] & M16);
      lo = (uint32_t)montgomery_reduce_16(prod, 3329, QINV_K);
      prod = (kOperandsBnMulVM[16 + j] >> 16) * (kOperandsBnMulVM[24 + j] >> 16);
      hi = (uint32_t)montgomery_reduce_16(prod, 3329, QINV_K);
      result[j] = lo | (hi << 16);
      CHECK(data[j] == result[j],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], result[j]);
    }
  }
}

// Testcase for bn.mulvm.l
static void test_bnmulvml(dif_otbn_t *otbn){
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppBnMulVMLTest));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(kOperandsBnMulVML), &kOperandsBnMulVML, kBnMulVMLOperands)); 
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));
  
  uint32_t result[8];
  uint32_t op16, lo, hi;
  int idx = 0;

  LOG_INFO("Check bn.mulvm.l.8S");
  for (uint32_t i = 0; i < 32*8; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnMulVMLResult + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);
    for (uint32_t j = 0; j < 8; j++) {
      uint64_t prod = (uint64_t)kOperandsBnMulVML[0 + j] * kOperandsBnMulVML[8 + (i/kOtbnWlenBytes)];
      result[j] = montgomery_reduce_32(prod, 8380417, QINV_D);
      CHECK(data[j] == result[j],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], result[j]);
    }
  }

  LOG_INFO("Check bn.mulvm.l.16H");
  for (uint32_t i = 0; i < 32*16; i += kOtbnWlenBytes) {
    uint32_t data[kOtbnWlenBytes / sizeof(uint32_t)];
    CHECK_DIF_OK(dif_otbn_dmem_read(otbn, kBnMulVMLResult + 32*8 + i, data, kOtbnWlenBytes));
    LOG_INFO("DMEM @%04d: 0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
             i / kOtbnWlenBytes, data[7], data[6], data[5], data[4], data[3],
             data[2], data[1], data[0]);

    op16 = kOperandsBnMulVML[24 + (idx / 2)];
    if (idx & 1)
      op16 >>= 16;
    op16 &= M16;
    idx += 1;
    
    uint32_t prod;
    for (uint32_t j = 0; j < 8; j++) {
      prod = (kOperandsBnMulVML[16 + j] & M16) * op16;
      lo = (uint32_t)montgomery_reduce_16(prod, 3329, QINV_K);
      prod = (kOperandsBnMulVML[16 + j] >> 16) * op16;
      hi = (uint32_t)montgomery_reduce_16(prod, 3329, QINV_K);
      result[j] = lo | (hi << 16);
      CHECK(data[j] == result[j],
            "Unexpected data at index %d: 0x%08x (actual) != 0x%08x (expected)",
            j + (i / kOtbnWlenBytes * 8), data[j], result[j]);
    }
  }
}

bool test_main(void) {
  // Initialise the entropy source and OTBN
  dif_otbn_t otbn;
  CHECK_STATUS_OK(entropy_testutils_auto_mode_init());
  CHECK_DIF_OK(
      dif_otbn_init(mmio_region_from_addr(TOP_EARLGREY_OTBN_BASE_ADDR), &otbn));

  // Test bn.addv and bn.subv
  test_bnaddsubv(&otbn);

  // Test bn.addvm and bn.subvm
  test_bnaddsubvm(&otbn);

  // Test bn.mulv
  test_bnmulv(&otbn);

  // Test bn.mulv.l
  test_bnmulvl(&otbn);

  // Test bn.mulvm
  test_bnmulvm(&otbn);

  // Test bn.mulvm.l
  test_bnmulvml(&otbn);

  return true;
}
