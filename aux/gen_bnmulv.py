from random import randint, seed
from pathlib import Path

path = Path('../Documents/git/private/expo-otbn-pqc/sw/otbn/crypto/tests/bnmulv_test.exp2')

N2 = 16
N = 8
ADDR = 64
WSIZE = 32
HSIZE = 16
MASK16 = ((1 << HSIZE) - 1)
MASK32 = ((1 << WSIZE) - 1)
MASK64 = ((1 << 2*WSIZE) - 1)

seed(0)

a = [randint(0, 2**WSIZE-1) for _ in range(N)]
b = [randint(0, 2**WSIZE-1) for _ in range(N)]

def print_input(a, b):
    print("operand1:")
    for i in range(0, N, 2):
        print(f"  .dword 0x{format(a[i+1], '08x')}{format(a[i], '08x')}")
        
    print("operand2:")
    for i in range(0, N, 2):
        print(f"  .dword 0x{format(b[i+1], '08x')}{format(b[i], '08x')}")


def write_64(input, data, addr):
  n = len(input)
  for i in range(n):
    line = f'{addr}-{addr+3} = 0x{format(input[i] & MASK32, '08x')}\n'
    line += f'{addr+4}-{addr+7} = 0x{format((input[i] >> WSIZE) & MASK32, '08x')}\n'
    addr += 8
    data += line
  return data, addr


def write_32(input, data, addr):
    n = len(input)
    for i in range(n):
        line = f'{addr}-{addr+3} = 0x{format(input[i] & MASK32, '08x')}\n'
        addr += 4
        data += line
    return data, addr

def write_16(input, data, addr):
    n = len(input)
    for i in range(0, n, 2):
        line = f'{addr}-{addr+3} = 0x{format(input[i + 1] & MASK16, '04x')}{format(input[i] & MASK16, '04x')}\n'
        addr += 4
        data += line
    return data, addr


def split_hilo_32(input):
    n = len(input)
    output = [0] * 2 * n
    idx = 0
    for i in range(0, 2 * n, 2):
        output[i] = input[idx] & MASK32
        output[i + 1] = (input[idx] >> WSIZE) & MASK32
        idx += 1
    
    return output

def split_hilo_16(input):
    n = len(input)
    output = [0] * 2 * n
    idx = 0
    for i in range(0, 2 * n, 2):
        output[i] = input[idx] & MASK16
        output[i + 1] = (input[idx] >> HSIZE) & MASK16
        idx += 1
    
    return output

def assign_acc(input, acc, odd):
    if odd:
        acc[1] += input[0]
        acc[3] += input[1]
        acc[5] += input[2]
        acc[7] += input[3]
        res = [acc[1], acc[3], acc[5], acc[7]]
    else:
        acc[0] += input[0]
        acc[2] += input[1]
        acc[4] += input[2]
        acc[6] += input[3]
        res = [acc[0], acc[2], acc[4], acc[6]]

    return acc, res

def assign_acc_16(input, acc, odd, whole = 0):
    if whole:
        for i in range(N2):
            acc[i] += input[i]
        res = acc
    else:
        if odd:
            acc[1] += input[0]
            acc[3] += input[1]
            acc[5] += input[2]
            acc[7] += input[3]
            acc[9] += input[4]
            acc[11] += input[5]
            acc[13] += input[6]
            acc[15] += input[7]
            res = [acc[1], acc[3], acc[5], acc[7], acc[9], acc[11], acc[13], acc[15]]
        else:
            acc[0] += input[0]
            acc[2] += input[1]
            acc[4] += input[2]
            acc[6] += input[3]
            acc[8] += input[4]
            acc[10] += input[5]
            acc[12] += input[6]
            acc[14] += input[7]
            res = [acc[0], acc[2], acc[4], acc[6], acc[8], acc[10], acc[12], acc[14]]

    return acc, res

def assign_res(input, res, odd):
    n = len(res)
    if odd:
        num_range = range(1, n, 2)
    else:
        num_range = range(0, n, 2)
    
    for i in num_range:
        res[i] = input[i]
    
    return res


def empty_acc(acc):
    acc = [0] * len(acc)
    return acc


def test_bnmulv_8S(data, addr):
    tmp_even = [a[i] * b[i] for i in range(0, N, 2)]
    tmp_even_lo = [tmp_even[i] & MASK32 for i in range(N // 2)]
    tmp_even_hi = [(tmp_even[i] >> WSIZE) & MASK32 for i in range(N // 2)]

    tmp_odd = [a[i] * b[i] for i in range(1, N, 2)]
    tmp_odd_lo = [(tmp_odd[i] & MASK32) << WSIZE for i in range(N // 2)]
    tmp_odd_hi = [((tmp_odd[i] >> WSIZE) & MASK32) << WSIZE for i in range(N // 2)]

    acc = [0] * N
    res = [0] * N

    # bn.mulv.8S.even
    res_tmp = split_hilo_32(tmp_even)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.8S.odd
    res_tmp = split_hilo_32(tmp_odd)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.8S.even.lo
    res = a.copy()
    res_tmp = split_hilo_32(tmp_even_lo)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)

    # bn.mulv.8S.odd.lo
    res = a.copy()
    res_tmp = split_hilo_32(tmp_odd_lo)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.8S.even.hi
    res = a.copy()
    res_tmp = split_hilo_32(tmp_even_hi)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)

    # bn.mulv.8S.odd.hi
    res = a.copy()
    res_tmp = split_hilo_32(tmp_odd_hi)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.8S.even.hi.cond
    res = a.copy()
    res_tmp = split_hilo_32(tmp_even_hi)
    for i in range(0, N, 2):
        if res_tmp[i] >= b[i]:
            res_tmp[i] -= b[i]

    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)

    # bn.mulv.8S.odd.hi.cond
    res = a.copy()
    res_tmp = split_hilo_32(tmp_odd_hi)
    for i in range(1, N, 2):
        if res_tmp[i] >= b[i]:
            res_tmp[i] -= b[i]

    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.8S.even.acc
    acc, acc_res = assign_acc(tmp_even, acc, 0)

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.odd.acc
    acc, acc_res = assign_acc(tmp_odd, acc, 1)

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.even.acc.lo
    res = a.copy()
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [xi & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.odd.acc.lo
    res = a.copy()
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [(xi & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.even.acc.hi
    res = a.copy()
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [(xi >> WSIZE) & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.odd.acc.hi
    res = a.copy()
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [((xi >> WSIZE) & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.even.acc.hi.cond
    res = a.copy()
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [(xi >> WSIZE) & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    for i in range(0, N, 2):
        if res_tmp[i] >= b[i]:
            res_tmp[i] -= b[i]

    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.odd.acc.hi.cond
    res = a.copy()
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [((xi >> WSIZE) & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    for i in range(1, N, 2):
        if res_tmp[i] >= b[i]:
            res_tmp[i] -= b[i]

    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.even.acc.z
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_even, acc, 0)

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.odd.acc.z
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_odd, acc, 1)

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.even.acc.z.lo
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [xi & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.odd.acc.z.lo
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [(xi & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.even.acc.z.hi
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [(xi >> WSIZE) & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.odd.acc.z.hi
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [((xi >> WSIZE) & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.even.acc.z.hi.cond
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [(xi >> WSIZE) & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    for i in range(0, N, 2):
        if res_tmp[i] >= b[i]:
             res_tmp[i] -= b[i]

    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.8S.odd.acc.z.hi.cond
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [((xi >> WSIZE) & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    for i in range(1, N, 2):
        if res_tmp[i] >= b[i]:
             res_tmp[i] -= b[i]

    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    return data, addr


def test_bnmulvl_8S(data, addr):
    tmp_even = [a[i] * b[5] for i in range(0, N, 2)]
    tmp_even_lo = [tmp_even[i] & MASK32 for i in range(N // 2)]
    tmp_even_hi = [(tmp_even[i] >> WSIZE) & MASK32 for i in range(N // 2)]

    tmp_odd = [a[i] * b[5] for i in range(1, N, 2)]
    tmp_odd_lo = [(tmp_odd[i] & MASK32) << WSIZE for i in range(N // 2)]
    tmp_odd_hi = [((tmp_odd[i] >> WSIZE) & MASK32) << WSIZE for i in range(N // 2)]

    acc = [0] * N
    res = [0] * N

    # bn.mulv.l.8S.even
    res_tmp = split_hilo_32(tmp_even)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.l.8S.odd
    res_tmp = split_hilo_32(tmp_odd)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.l.8S.even.lo
    res = a.copy()
    res_tmp = split_hilo_32(tmp_even_lo)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)

    # bn.mulv.l.8S.odd.lo
    res = a.copy()
    res_tmp = split_hilo_32(tmp_odd_lo)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.l.8S.even.hi
    res = a.copy()
    res_tmp = split_hilo_32(tmp_even_hi)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)

    # bn.mulv.l.8S.odd.hi
    res = a.copy()
    res_tmp = split_hilo_32(tmp_odd_hi)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.l.8S.even.hi.cond
    res = a.copy()
    res_tmp = split_hilo_32(tmp_even_hi)
    for i in range(0, N, 2):
        if res_tmp[i] >= b[5]:
            res_tmp[i] -= b[5]

    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)

    # bn.mulv.l.8S.odd.hi.cond
    res = a.copy()
    res_tmp = split_hilo_32(tmp_odd_hi)
    for i in range(1, N, 2):
        if res_tmp[i] >= b[5]:
            res_tmp[i] -= b[5]

    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)

    # bn.mulv.l.8S.even.acc
    acc, acc_res = assign_acc(tmp_even, acc, 0)

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.odd.acc
    acc, acc_res = assign_acc(tmp_odd, acc, 1)

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.even.acc.lo
    res = a.copy()
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [xi & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.odd.acc.lo
    res = a.copy()
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [(xi & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.even.acc.hi
    res = a.copy()
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [(xi >> WSIZE) & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.odd.acc.hi
    res = a.copy()
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [((xi >> WSIZE) & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.even.acc.hi.cond
    res = a.copy()
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [(xi >> WSIZE) & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    for i in range(0, N, 2):
        if res_tmp[i] >= b[5]:
            res_tmp[i] -= b[5]

    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.odd.acc.hi.cond
    res = a.copy()
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [((xi >> WSIZE) & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    for i in range(1, N, 2):
        if res_tmp[i] >= b[5]:
            res_tmp[i] -= b[5]

    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.even.acc.z
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_even, acc, 0)

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.odd.acc.z
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_odd, acc, 1)

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.even.acc.z.lo
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [xi & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.odd.acc.z.lo
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [(xi & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.even.acc.z.hi
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [(xi >> WSIZE) & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.odd.acc.z.hi
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [((xi >> WSIZE) & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.even.acc.z.hi.cond
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_even, acc, 0)
    acc_res = [(xi >> WSIZE) & MASK32 for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    for i in range(0, N, 2):
        if res_tmp[i] >= b[5]:
             res_tmp[i] -= b[5]

    res = assign_res(res_tmp, res, 0)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    # bn.mulv.l.8S.odd.acc.z.hi.cond
    res = a.copy()
    acc = empty_acc(acc)
    acc, acc_res = assign_acc(tmp_odd, acc, 1)
    acc_res = [((xi >> WSIZE) & MASK32) << WSIZE for xi in acc_res]

    res_tmp = split_hilo_32(acc_res)
    for i in range(1, N, 2):
        if res_tmp[i] >= b[5]:
             res_tmp[i] -= b[5]

    res = assign_res(res_tmp, res, 1)
    data, addr = write_32(res, data, addr)
    data, addr = write_64(acc, data, addr)

    return data, addr


def test_bnmulv_16H(data, addr):
    tmp = [a[i] * b[i] for i in range(N2)]
    tmp_lo = [tmp[i] & MASK16 for i in range(N2)]
    tmp_hi = [(tmp[i] >> HSIZE) & MASK16 for i in range(N2)]

    tmp_even = [tmp[i] for i in range(0, N2, 2)]
    tmp_odd = [tmp[i] for i in range(1, N2, 2)]

    acc = [0] * N2
    res = [0] * N2

    # bn.mulv.16H.even
    res = split_hilo_16(tmp_even)
    data, addr = write_16(res, data, addr)

    # bn.mulv.16H.odd
    res = split_hilo_16(tmp_odd)
    data, addr = write_16(res, data, addr)

    # bn.mulv.16H.lo
    res = tmp_lo
    data, addr = write_16(res, data, addr)

    # bn.mulv.16H.hi
    res = tmp_hi
    data, addr = write_16(res, data, addr)

    # bn.mulv.16H.hi.cond
    res = tmp_hi
    for i in range(N2):
        if res[i] >= b[i]:
            res[i] -= b[i]
    data, addr = write_16(res, data, addr)

    # bn.mulv.16H.even.acc
    acc, acc_res = assign_acc_16(tmp_even, acc, 0)
    res = split_hilo_16(acc_res)
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.odd.acc
    acc, acc_res = assign_acc_16(tmp_odd, acc, 1)
    res = split_hilo_16(acc_res)
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.acc.lo
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [xi & MASK16 for xi in acc_res]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.acc.hi
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [(xi >> HSIZE) & MASK16 for xi in acc_res]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.acc.hi.cond
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [(xi >> HSIZE) & MASK16 for xi in acc_res]
    for i in range(N2):
        if res[i] >= b[i]:
            res[i] -= b[i]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.even.acc.z
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp_even, acc, 0)
    res = split_hilo_16(acc_res)
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.odd.acc.z
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp_odd, acc, 1)
    res = split_hilo_16(acc_res)
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.acc.z.lo
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [xi & MASK16 for xi in acc_res]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.acc.z.hi
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [(xi >> HSIZE) & MASK16 for xi in acc_res]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.16H.acc.z.hi.cond
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [(xi >> HSIZE) & MASK16 for xi in acc_res]
    for i in range(N2):
        if res[i] >= b[i]:
            res[i] -= b[i]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    return data, addr


def test_bnmulvl_16H(data, addr):
    tmp = [a[i] * b[3] for i in range(N2)]
    tmp_lo = [tmp[i] & MASK16 for i in range(N2)]
    tmp_hi = [(tmp[i] >> HSIZE) & MASK16 for i in range(N2)]

    tmp_even = [tmp[i] for i in range(0, N2, 2)]
    tmp_odd = [tmp[i] for i in range(1, N2, 2)]

    acc = [0] * N2
    res = [0] * N2

    # bn.mulv.l.16H.even
    res = split_hilo_16(tmp_even)
    data, addr = write_16(res, data, addr)

    # bn.mulv.l.16H.odd
    res = split_hilo_16(tmp_odd)
    data, addr = write_16(res, data, addr)

    # bn.mulv.l.16H.lo
    res = tmp_lo
    data, addr = write_16(res, data, addr)

    # bn.mulv.l.16H.hi
    res = tmp_hi
    data, addr = write_16(res, data, addr)

    # bn.mulv.l.16H.hi.cond
    res = tmp_hi
    for i in range(N2):
        if res[i] >= b[3]:
            res[i] -= b[3]
    data, addr = write_16(res, data, addr)

    # bn.mulv.l.16H.even.acc
    acc, acc_res = assign_acc_16(tmp_even, acc, 0)
    res = split_hilo_16(acc_res)
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.odd.acc
    acc, acc_res = assign_acc_16(tmp_odd, acc, 1)
    res = split_hilo_16(acc_res)
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.acc.lo
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [xi & MASK16 for xi in acc_res]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.acc.hi
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [(xi >> HSIZE) & MASK16 for xi in acc_res]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.acc.hi.cond
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [(xi >> HSIZE) & MASK16 for xi in acc_res]
    for i in range(N2):
        if res[i] >= b[3]:
            res[i] -= b[3]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.even.acc.z
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp_even, acc, 0)
    res = split_hilo_16(acc_res)
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.odd.acc.z
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp_odd, acc, 1)
    res = split_hilo_16(acc_res)
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.acc.z.lo
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [xi & MASK16 for xi in acc_res]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.acc.z.hi
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [(xi >> HSIZE) & MASK16 for xi in acc_res]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    # bn.mulv.l.16H.acc.z.hi.cond
    acc = empty_acc(acc)
    acc, acc_res = assign_acc_16(tmp, acc, 0, 1)
    res = [(xi >> HSIZE) & MASK16 for xi in acc_res]
    for i in range(N2):
        if res[i] >= b[3]:
            res[i] -= b[3]
    data, addr = write_16(res, data, addr)
    data, addr = write_32(acc, data, addr)

    return data, addr



print_input(a, b)

data = '# dmem:\n'
addr = ADDR

data, addr = test_bnmulv_8S(data, addr)
data, addr = test_bnmulvl_8S(data, addr)

a = split_hilo_16(a)
b = split_hilo_16(b)

data, addr = test_bnmulv_16H(data, addr)
data, addr = test_bnmulvl_16H(data, addr)

path.write_text(data)






