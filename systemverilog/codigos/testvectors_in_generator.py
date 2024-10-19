import itertools
import random

DATA_WIDTH  = 8
NUM_REGS    = 4

def bin_conversion(num, width = 2):
    return bin(num)[2:].zfill(width)

def get_info(reset, wr_en, add_rd0, add_rd1, add_wr, wr_data):
    b_add_rd0, b_add_rd1, b_add_wr = map(bin_conversion, [add_rd0, add_rd1, add_wr])
    b_wr_data = bin_conversion(wr_data, DATA_WIDTH)
    return f'{reset}_{wr_en}_{b_add_rd0}_{b_add_rd1}_{b_add_wr}_{b_wr_data}'

def main():
    ranges = {
        'control': range(2),
        'address': range(NUM_REGS),
        'data': range(2 ** DATA_WIDTH)
    }
    
    product = itertools.product(
        ranges['control'], # reset
        ranges['control'], # wr_en
        ranges['address'], # add_rd0
        ranges['address'], # add_rd1
        ranges['address'], # add_wr 
        ranges['data']     # wr_data
    )

    testvectors = [get_info(*values) for values in product]
    with open('testvectors_in.txt', 'w') as file:
        file.write('\n'.join(random.sample(testvectors, 100)))

if __name__ == '__main__':
    main()
