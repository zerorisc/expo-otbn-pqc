import random
import os
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
import cocotb_test.simulator
import pytest

# Parameter constants
WLEN = 256
DLEN = 64
SLEN = 32
HLEN = 16


@cocotb.test()
async def run_unified_test(dut):
    """Randomized test for unified multiplier in all modes."""

    for mode in [0b00, 0b01, 0b10]:
        for _ in range(32):
            A = random.getrandbits(WLEN)
            B = random.getrandbits(WLEN)

            dut.mode.value = mode
            dut.word_sel_A.value = random.randint(0, 3)
            dut.word_sel_B.value = random.randint(0, 3)
            dut.half_sel.value = random.randint(0, 1)
            dut.A.value = A
            dut.B.value = B

            await Timer(1, units="ns")  # allow evaluation

            result = int(dut.result.value)

            print("mode:", mode)

            if mode == 0b00:
                # 64x64 mode
                word_sel_A = int(dut.word_sel_A.value)
                word_sel_B = int(dut.word_sel_B.value)
                a = (A >> (word_sel_A * DLEN)) & ((1 << DLEN) - 1)
                b = (B >> (word_sel_B * DLEN)) & ((1 << DLEN) - 1)
                expected = a * b
                masked = result & ((1 << (2 * DLEN)) - 1)

                print(hex(a), hex(b), hex(expected), hex(masked))

                assert masked == expected, f"64x64 FAIL: a={a}, b={b}, got={masked}, expected={expected}"

            elif mode == 0b01:
                # 4x 32x32 mode
                for i in range(4):
                    idx = 2 * i + int(dut.half_sel.value)
                    a = (A >> (idx * SLEN)) & ((1 << SLEN) - 1)
                    b = (B >> (idx * SLEN)) & ((1 << SLEN) - 1)
                    expected = a * b
                    out = (result >> (64 * i)) & ((1 << 64) - 1)

                    print(a, b, hex(expected), hex(out))

                    assert out == expected, f"32x32 FAIL: i={i}, a={a}, b={b}, got={out}, expected={expected}"

            elif mode == 0b10:
                # 16x 16x16 mode
                for i in range(16):
                    a = (A >> (i * HLEN)) & ((1 << HLEN) - 1)
                    b = (B >> (i * HLEN)) & ((1 << HLEN) - 1)
                    expected = a * b
                    out = (result >> (32 * i)) & ((1 << 32) - 1)

                    print(i, a, b, hex(expected), hex(out))

                    assert out == expected, f"16x16 FAIL: i={i}, a={a}, b={b}, got={out}, expected={expected}"

            print("good")


def test_unified_mult_build():
    run(
        toplevel="unified_mul",
        module="test_unified_mul",
        toplevel_lang="verilog",
        testcase="run_unified_test",
        simulator="verilator",
        sim_build=f"sim_build/unified_mul",
        verilog_sources=["bn_vec_core/unified_mul.sv"],
        waves=False,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )

