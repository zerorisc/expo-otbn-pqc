
from dataclasses import dataclass


@dataclass
class mac_bignum_operation_t:
    operand_a: int
    operand_b: int
    operand_a_qw_sel: int
    operand_b_qw_sel: int
    wr_hw_sel_upper: int
    pre_acc_shift_imm: int
    zero_acc: int
    shift_acc: int

    def to_Logic(self) -> int:
        value = self.operand_a
        value = (value << 256) | self.operand_b
        value = (value << 2)   | self.operand_a_qw_sel
        value = (value << 2)   | self.operand_b_qw_sel
        value = (value << 1)   | self.wr_hw_sel_upper
        value = (value << 2)   | self.pre_acc_shift_imm
        value = (value << 1)   | self.zero_acc
        value = (value << 1)   | self.shift_acc
        return value

@dataclass
class mac_predec_bignum_t:
    op_en: int
    acc_rd_en: int

    def to_Logic(self) -> int:
        return (self.op_en << 1) | self.acc_rd_en


def mask(val, bits=256):
    return val & ((1 << bits) - 1)


def select_quarter_word(val: int, sel: int) -> int:
    """Select 64-bit quarter-word from 256-bit operand"""
    shift = sel * 64
    return (val >> shift) & 0xFFFFFFFFFFFFFFFF

acc = 0

def mac_acc():
  return acc

def mac_model(op: mac_bignum_operation_t, predec: mac_predec_bignum_t) -> int:
    """Python model of the MAC bignum hardware"""

    global acc

    a_qw = select_quarter_word(op.operand_a, op.operand_a_qw_sel)
    b_qw = select_quarter_word(op.operand_b, op.operand_b_qw_sel)
    mul_res = a_qw * b_qw

    mul_res = mask(mul_res << (op.pre_acc_shift_imm * 64))

    if op.zero_acc or not predec.acc_rd_en:
      acc = 0


    res = mask(acc + mul_res)

    if op.shift_acc:
      acc = res >> 128
    else:
      acc = res

    return res

