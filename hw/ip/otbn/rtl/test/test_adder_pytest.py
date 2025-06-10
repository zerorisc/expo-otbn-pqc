import random
import pytest
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import ReadOnly
from cocotb.triggers import Timer
import os

# === Testbench logic ===

# Correct reference function (keep this one)
def reference_sum(A, B, mode, cin):
    if mode == 0:
        full = (A + B + cin) & ((1 << 256) - 1)
        cout = (A + B + cin) >> 256
        return full, cout
    elif mode == 1:
        result = 0
        for i in range(8):
            mask = (1 << 32) - 1
            a = (A >> (32 * i)) & mask
            b = (B >> (32 * i)) & mask
            s = (a + b) & mask
            result |= (s << (32 * i))
        return result, 0
    elif mode == 2:
        result = 0
        for i in range(16):
            mask = (1 << 16) - 1
            a = (A >> (16 * i)) & mask
            b = (B >> (16 * i)) & mask
            s = (a + b) & mask
            result |= (s << (16 * i))
        return result, 0
    else:
        raise ValueError("Invalid mode")


# === Test driver (Cocotb) ===

@cocotb.test()
async def run_adder_test(dut):
  for i in range(16):
    A = random.getrandbits(256)
    B = random.getrandbits(256)

    mode = int(os.environ.get("MODE"))

    if os.environ.get("TEST_CIN") == "yes":
      cin = random.randint(0, 1) if mode == 0 else 0
    else:
      cin = 0

    # Assign inputs
    dut.A.value = A
    dut.B.value = B
    dut.mode.value = mode
    dut.cin.value = cin

    await Timer(1, units="ns")  # allow evaluation

    # Get result
    sum_expected, cout_expected = reference_sum(A, B, mode, cin)

    sum_out = dut.sum.value.integer
    cout_out = dut.cout.value.integer

    print(f"\nsum out:  {bin(sum_out)}\nexpected: {bin(sum_expected)}")
    print(f"\nsum out:  {hex(sum_out)}\nexpected: {hex(sum_expected)}")

    assert sum_out == sum_expected, f"sum mismatch: mode={mode} A={hex(A)} B={hex(B)} cin={cin}"
    if mode == 0:
        assert cout_out == cout_expected, f"cout mismatch in scalar mode"
    else:
        assert cout_out == 0, f"cout must be 0 in vector mode"

# === Pytest hook ===

@pytest.mark.parametrize(
    "variant,mode,test_cin",
    [("ref_add", 0, "yes")] +
    [("brent_kung_adder_256_mode0_only", 0, "yes")] +
    [("brent_kung_adder_256", i, "yes") for i in range(3)] +
    [("sklansky_adder_256_mode0_only", 0, "yes")] +
    [("sklansky_adder_256", i, "yes") for i in range(3)] +
    [("csa_adder_256", i, "yes") for i in range(3)]
)
def test_adder_sim(variant, mode, test_cin):
    run(
        toplevel=variant,
        module="test_adder_pytest",
        toplevel_lang="verilog",
        testcase="run_adder_test",
        simulator="verilator",
        sim_build=f"sim_build/{variant}",
        verilog_sources=[f"bn_vec_core/{variant}.sv"],
        extra_env={
            "MODE": str(mode),
            "TEST_CIN": test_cin,
        },
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )

