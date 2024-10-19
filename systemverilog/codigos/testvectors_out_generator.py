class RegisterFile:
    DATA_WIDTH  = 8
    NUM_REGS    = 4
    
    def __init__(self):
        self.registers = [0] * self.NUM_REGS

    def run(self, reset, wr_en, add_rd0, add_rd1, add_wr, wr_data):
        if reset: self.registers = [0] * self.NUM_REGS
        elif not wr_en: self.registers[add_wr] = wr_data
        rd0 = self.registers[add_rd0]
        rd1 = self.registers[add_rd1]
        return rd0, rd1

def bin_conversion(num, width = 8):
    return bin(num)[2:].zfill(width)

def get_info(reset, wr_en, add_rd0, add_rd1, add_wr, wr_data):
    b_add_rd0, b_add_rd1, b_add_wr = map(bin_conversion, [add_rd0, add_rd1, add_wr])
    b_wr_data = bin_conversion(wr_data, RegisterFile.DATA_WIDTH)
    return f'{reset}_{wr_en}_{b_add_rd0}_{b_add_rd1}_{b_add_wr}_{b_wr_data}'

def main():
    testvectors = []
    register_file = RegisterFile()
    with open('testvectors_in.txt') as file_in:
        for row in file_in:
            reset, wr_en, add_rd0, add_rd1, add_wr, wr_data = map(
                lambda x: int(x, base = 2),
                row.split('_')
            )
            rd_values = register_file.run(reset, wr_en, add_rd0, add_rd1, add_wr, wr_data)
            testvectors.append('_'.join(map(bin_conversion, rd_values)))

    with open('testvectors_out.txt', 'w') as file:
        file.write('\n'.join(testvectors))

if __name__ == '__main__':
    main()
