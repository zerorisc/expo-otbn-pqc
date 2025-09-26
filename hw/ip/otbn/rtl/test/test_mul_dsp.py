import os
from random import randint, getrandbits

import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import Timer
import pytest


@cocotb.test()
async def run_mul_dsp_test(dut):
    """Run reference_prod and the unified multiplier on same inputs and compare their results.
    """
    num_tests = int(os.environ.get("NUM_TESTS", 1024))
    for _ in range(num_tests):
      for mode in [0,1,2]:
        # Generate random inputs
        if mode == 0:
          a = getrandbits(64)
          b = getrandbits(64)

          dut.a64.value = a
          dut.b64.value = b

#          a = getrandbits(32)
#          b = getrandbits(32)
#
#          dut.a32.value = a
#          dut.b32.value = b

        if mode == 1:
          a = getrandbits(32*4)
          b = getrandbits(32*4)

          dut.a32.value = a
          dut.b32.value = b

        if mode == 2:
          a = getrandbits(16*16)
          b = getrandbits(16*16)
  
          dut.a16.value = a
          dut.b16.value = b


        # Assign inputs
        dut.mode.value = mode
        await Timer(1, units="ns")  # allow evaluation

        if mode == 0:
          # Get expected result
          prod_expected = [a * b]
  
          # Get actual result
          result = [int(dut.p64.value)]
          #result = int(dut.p32.value)
  
        if mode == 1:
          # Get expected result
          prod_expected = [((a >> i) & 0xffffffff) * ((b >> i) & 0xffffffff) for i in range(0, 4*32, 32)]
  
          # Get actual result
          result = int(dut.p32.value)
  
          result = [(result >> i) & 0xffffffffffffffff for i in range(0, 4*64, 64)]

        if mode == 2:
          # Get expected result
          prod_expected = [((a >> i) & 0xffff) * ((b >> i) & 0xffff) for i in range(0, 16*16, 16)]
  
          # Get actual result
          result = int(dut.p16.value)
  
          result = [(result >> i) & 0xffffffff for i in range(0, 32*16, 32)]

        print(f"a: {format(a, '064x')}")
        print(f"b: {format(b, '064x')}")

        print(hex(dut.dspA16[0].value), hex(dut.dspB16[0].value), hex(dut.P[0].value))
        print(hex(dut.dspA16[1].value), hex(dut.dspB16[1].value), hex(dut.P[1].value))
        print(hex(dut.dspA16[4].value), hex(dut.dspB16[4].value), hex(dut.P[4].value))
        print(hex(dut.dspA16[5].value), hex(dut.dspB16[5].value), hex(dut.P[5].value))

        #print([hex(v) for v in dut.dspA16.value])
        #print([hex(v) for v in dut.dspB16.value])
        #print([hex(v) for v in dut.dP.value])

#        print(hex(dut.A0.value))
#        print(hex(dut.A1.value))
#        print(hex(dut.B0.value))
#        print(hex(dut.B1.value))

        print(hex(dut.P[0].value), hex((a & 0xffff) * (b & 0xffff)))

#        d1_head = (a & 0xffff) * ((b >> 16) & 0xffff)
#
#        print(hex(dut.d1_head.value), hex(d1_head))
#        print(hex(dut.d1_tail.value), hex(((a >> 16) & 0xffff) * ((b >> 0) & 0xffff)))

        assert prod_expected == result, (
                f"ERROR PROD: mismatch\n{[hex(v) for v in prod_expected]}\n{[hex(v) for v in result]}"
            )

# === Pytest hook ===
def test_mul_dsp_sim():
    """Run different testcases on simulated design.
    """
    num_tests = 1024*8
    extra_args = ["--timing"]

    run(
        toplevel="mul_dsp",
        module="test_mul_dsp",
        toplevel_lang="verilog",
        testcase="run_mul_dsp_test",
        simulator="verilator",
        extra_args=extra_args,
        sim_build="sim_build/mul_dsp",
        verilog_sources=["bn_vec_core/DSP48E1.v", "bn_vec_core/mul_dsp.sv"],
        extra_env={
            "NUM_TESTS": str(num_tests)
        },
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )
