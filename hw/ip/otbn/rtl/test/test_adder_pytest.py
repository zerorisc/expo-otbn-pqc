import random
import pytest
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import ReadOnly
from cocotb.triggers import Timer
import os

from hw_model import reference_sum


@cocotb.test()
async def run_adder_test(dut):
  for i in range(16):
    A = random.getrandbits(256)
    B = random.getrandbits(256)

    data_type = int(os.environ.get("DATA_TYPE"))

    if os.environ.get("TEST_CIN") == "yes":
      cin = random.randint(0, 1) if data_type == 0 else 0
    else:
      cin = 0

    # Assign inputs
    dut.A.value = A
    dut.B.value = B
    dut.data_type.value = data_type
    dut.cin.value = cin

    await Timer(1, units="ns")  # allow evaluation

    # Get result
    sum_expected, cout_expected = reference_sum(A, B, data_type, cin)

    sum_out = dut.sum.value.integer
    cout_out = dut.cout.value.integer

    print(f"\nsum out:  {bin(sum_out)}\nexpected: {bin(sum_expected)}")
    print(f"\nsum out:  {hex(sum_out)}\nexpected: {hex(sum_expected)}")

    assert sum_out == sum_expected, f"sum mismatch: data_type={data_type} A={hex(A)} B={hex(B)} cin={cin}"
    if data_type == 0:
        assert cout_out == cout_expected, f"cout mismatch in scalar data_type"
    else:
        assert cout_out == 0, f"cout must be 0 in vector data_type"

# === Pytest hook ===

@pytest.mark.parametrize(
    "variant,data_type,test_cin",
    [("ref_add", 0, "yes")] +
    [("ref_vec_add", 0, "yes")] +
    [("brent_kung_adder_256_mode0_only", 0, "yes")] +
    [("brent_kung_adder_256", i, "yes") for i in range(3)] +
    [("sklansky_adder_256_mode0_only", 0, "yes")] +
    [("sklansky_adder_256", i, "yes") for i in range(3)] +
    [("csa_adder_256", i, "yes") for i in range(3)]
)
def test_adder_sim(variant, data_type, test_cin):
    run(
        toplevel=variant,
        module="test_adder_pytest",
        toplevel_lang="verilog",
        testcase="run_adder_test",
        simulator="verilator",
        sim_build=f"sim_build/{variant}",
        verilog_sources=[f"bn_vec_core/{variant}.sv"],
        extra_env={
            "DATA_TYPE": str(data_type),
            "TEST_CIN": test_cin,
        },
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )

