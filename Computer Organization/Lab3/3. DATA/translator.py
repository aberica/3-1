# There might be some bugs. If NOP show up, it is probably due to bug.
# Copy and paste machine code below. Lab2 fibo machine code is hard coded.
bin = """00000000000000000000000010010011
00000000000000000000000100010011
00000000000000000000000110010011
00000000000000000000001000010011
00000000000000000000001010010011
00000000000000000000001100010011
00000000000000000000001110010011
00000000000000000000010000010011
00000000000000000000010010010011
00000000000000000000010100010011
00000000000000000000010110010011
00000000000000000000011000010011
00000000000000000000011010010011
00000000000000000000011100010011
00000000000000000000011110010011
00000000000000000000100000010011
00000000000000000000100010010011
00000000000000000000100100010011
00000000000000000000100110010011
00000000000000000000101000010011
00000000000000000000101010010011
00000000000000000000101100010011
00000000000000000000101110010011
00000000000000000000110000010011
00000000000000000000110010010011
00000000000000000000110100010011
00000000000000000000110110010011
00000000000000000000111000010011
00000000000000000000111010010011
00000000000000000000111100010011
00000000000000000000111110010011
00000000000000000110000100010111
01011110010000010000000100010011
00111000100000000000000011101111
00111001100000000000000001101111
11111011000000010000000100010011
00000011010000010010110000100011
00000011010100010010101000100011
00000011011000010010100000100011
00000011011100010010011000100011
00000100000100010010011000100011
00000100100000010010010000100011
00000100100100010010001000100011
00000101001000010010000000100011
00000011001100010010111000100011
00000011100000010010010000100011
00000011100100010010001000100011
00000011101000010010000000100011
00000001101100010010111000100011
00000000101100010010001000100011
00000000000001010000101010010011
00000000110000010010011000100011
00000000000000000000101000010011
00000000000000010010010000100011
00000011000001011000101110010011
00000011111000000000101100010011
00000000100000010010011110000011
00000000000010101000110000010011
00000000110000010010110110000011
00000000000101111000011110010011
00000000111100010010010000100011
00010000000010101000101010010011
00000000000000000000110100010011
00000000000000000000100100010011
00000001010000000000000001101111
00000000000110100000101000010011
00000000010011011000110110010011
00000000010011010000110100010011
00000111011010010000011001100011
00000000000011011010000000100011
00000001101010101000011110110011
00000000010001111010011110000011
00000000000110010000100100010011
11111110000001111000000011100011
00000000010000010010011110000011
00000001100011010000100110110011
00000000110001111000110010010011
11111111010011001000010000010011
00000000000010011000010010010011
00000000000001000010010100000011
00000000010001000000010000010011
00000000000001010000110001100011
00000000000001001010010110000011
00101001110000000000000011101111
00000000000011011010011110000011
00000000101001111000011110110011
00000000111111011010000000100011
00000000010001001000010010010011
11111101100101000001111011100011
00000000110011001000110010010011
00010000000010011000100110010011
11111101011111001001010011100011
00000000010011011000110110010011
00000000010011010000110100010011
11111001011010010001111011100011
00000000110000010010011110000011
00001111100001111000011110010011
00000000111100010010011000100011
00000000100000010010011110000011
11110101001001111001101011100011
00000100110000010010000010000011
00000100100000010010010000000011
00000100010000010010010010000011
00000100000000010010100100000011
00000011110000010010100110000011
00000011010000010010101010000011
00000011000000010010101100000011
00000010110000010010101110000011
00000010100000010010110000000011
00000010010000010010110010000011
00000010000000010010110100000011
00000001110000010010110110000011
00000000000010100000010100010011
00000011100000010010101000000011
00000101000000010000000100010011
00000000000000001000000001100111
00000000000000001000000001100111
00000000101101010110011110110011
00000000110001111110011110110011
00000000001101111111011110010011
00000000110001010000011010110011
00000010000001111000010001100011
00000000110001011000011000110011
00000000000001010000011110010011
00000010110101010111111001100011
00000000000001011100011100000011
00000000000101011000010110010011
00000000000101111000011110010011
11111110111001111000111110100011
11111110110001011001100011100011
00000000000000001000000001100111
11111110110101010111111011100011
00000000000001010000011110010011
00000000000001011010011100000011
00000000010001111000011110010011
00000000010001011000010110010011
11111110111001111010111000100011
11111110110101111110100011100011
00000000000000001000000001100111
00000000000000001000000001100111
11111111000000010000000100010011
00000000110001010110011110110011
00000000100000010010010000100011
00000000000100010010011000100011
00000000001101111111011110010011
00000000000001010000010000010011
00000000110001010000011100110011
00000010000001111000001001100011
00000000111001010111011001100011
00001111111101011111010110010011
11111101100111111111000011101111
00000000110000010010000010000011
00000000000001000000010100010011
00000000100000010010010000000011
00000001000000010000000100010011
00000000000000001000000001100111
00001111111101011111010110010011
00000000100001011001011010010011
00000000101101101000011010110011
00000001000001101001011110010011
00000000111101101000011010110011
11111100111001010111110011100011
00000000000001010000011110010011
00000000010001111000011110010011
11111110110101111010111000100011
11111110111001111110110011100011
00000000110000010010000010000011
00000000000001000000010100010011
00000000100000010010010000000011
00000001000000010000000100010011
00000000000000001000000001100111
00000000000001010100011110000011
00000000000001111000111001100011
00000000000001010000011110010011
00000000000101111100011100000011
00000000000101111000011110010011
11111110000001110001110011100011
01000000101001111000010100110011
00000000000000001000000001100111
00000000000000000000010100010011
00000000000000001000000001100111
00000000101101010000011010110011
00000000000001010000011110010011
00000000000001011001100001100011
00000010010000000000000001101111
00000000000101111000011110010011
00000000111101101000101001100011
00000000000001111100011100000011
11111110000001110001101011100011
01000000101001111000010100110011
00000000000000001000000001100111
01000000101001101000010100110011
00000000000000001000000001100111
00000000000000000000010100010011
00000000000000001000000001100111
00000000000001010100011110000011
00000000000101011000010110010011
00000000000101010000010100010011
11111111111101011100011100000011
00000000000001111000100001100011
11111110111001111000011011100011
01000000111001111000010100110011
00000000000000001000000001100111
00000000000000000000011110010011
11111111010111111111000001101111
00000000000001010000011110010011
00000000000001011100011100000011
00000000000101111000011110010011
00000000000101011000010110010011
11111110111001111000111110100011
11111110000001110001100011100011
00000000000000001000000001100111
00000000000001010100011100000011
00000010000000000000011010010011
00000000000001010000011110010011
00000000110101110001100001100011
00000000000101111100011100000011
00000000000101111000011110010011
11111110110101110000110011100011
00000010110100000000011010010011
00000110110101110000000001100011
00000010101100000000011010010011
00000100110101110000000001100011
00000000000001111100011010000011
00000000000000000000010110010011
00000100000001101000001001100011
00000000000000000000010100010011
00000000000101111000011110010011
00000000001001010001011100010011
11111101000001101000011000010011
00000000000001111100011010000011
00000000101001110000011100110011
00000000000101110001011100010011
00000000111001100000010100110011
11111110000001101001001011100011
00000010000001011000000001100011
01000000101000000000010100110011
00000000000000001000000001100111
00000000000101111100011010000011
00000000000000000000010110010011
00000000000101111000011110010011
11111100000001101001001011100011
00000000000000000000010100010011
00000000000000001000000001100111
00000000000101111100011010000011
00000000000100000000010110010011
00000000000101111000011110010011
11111010000001101001011011100011
00000000000000000000010100010011
11111110100111111111000001101111
00000000000001010000011000010011
00000000000000000000010100010011
00000000000101011111011010010011
00000000000001101000010001100011
00000000110001010000010100110011
00000000000101011101010110010011
00000000000101100001011000010011
11111110000001011001011011100011
00000000000000001000000001100111
00000000000000000110011000010111
00100101010001100000011000010011
01010011110000000000010110010011
01010110000000000000010100010011
11000111000111111111000001101111
00000000000000000000000000010011
00000000000000000000000000010011
00000000000000000000000000010011
00000000000000000000000000010011
00000000000000000000000000010011
00000000000000000000000000010011
11111110100111111111000001101111"""

bin_stripped = bin.replace('_','')
binLine = bin_stripped.splitlines()

def decompile(line):
    opcode = line[25:32]
    funct3 = line[17:20]
    funct7 = line[0:7]
    assembly = []

    if opcode == "0110011":     # R-type
        rd = 'x'+str(int(line[20:25],2))
        rs1 = 'x'+str(int(line[12:17],2))
        rs2 = 'x'+str(int(line[7:12],2))

        if funct3 == "000":
            if funct7 == "0000000":
               inst = "ADD"
            elif funct7 == "0100000":
                inst = "SUB"
            else:
                inst= "NOP"
        elif funct3 == "100":
            inst = "XOR"
        elif funct3 == "110":
            inst = "OR"
        elif funct3 == "111":
            inst = "AND"
        elif funct3 == "101":
            if funct7 == "0000000":
                inst = "SRL"
            elif funct7 == "0100000":
                inst = "SRA"
            else:
                inst = "NOP"
        elif funct3 == "010":
            inst = "SLT"
        elif funct3 == "011":
            inst = "SLTU"
        else:
            inst = "NOP"
        assembly = [inst, rd, rs1, rs2]

    elif opcode == "0010011":   # I-type
        rd = 'x'+str(int(line[20:25],2))
        rs1 = 'x'+str(int(line[12:17],2))
        imm = str(int(line[0:12],2) if int(line[0:12],2) < 2048 else int(line[0:12],2)-4096)

        if funct3 == "000":
            inst = "ADDI"
        elif funct3 == "100":
            inst = "XORI"
        elif funct3 == "110":
            inst = "ORI"
        elif funct3 == "111":
            inst = "ANDI"
        elif funct3 == "001":
            inst = "SLLI"
        elif funct3 == "101":
            if funct7 == "0000000":
                inst = "SRLI"
            elif funct7 == "0100000":
                inst = "SRAI"
            else:
                inst = "NOP"
        elif funct3 == "010":
            inst = "SLTI"
        elif funct3 == "011":
            inst = "SLTIU"
        else:
            inst = "NOP"
        assembly = [inst, rd, rs1, imm]
    
    elif opcode == "0000011":   # Load
        rd = 'x'+str(int(line[20:25],2))
        rs1 = 'x'+str(int(line[12:17],2))
        imm = str(int(line[0:12],2) if int(line[0:12],2) < 2048 else int(line[0:12],2)-4096)

        if funct3 == "000":
            inst = "LB"
        elif funct3 == "001":
            inst = "LH"
        elif funct3 == "010":
            inst = "LW"
        elif funct3 == "100":
            inst = "LBU"
        elif funct3 == "101":
            inst = "LHU"
        else:
            inst = "NOP"
        assembly = [inst, rd, imm+'('+rs1+')']
    
    elif opcode == "0100011":   # Store
        rs1 = 'x'+str(int(line[12:17],2))
        rs2 = 'x'+str(int(line[7:12],2))
        imm = str(int(line[0:7]+line[20:25],2) if int(line[0:7]+line[20:25],2) < 2048 else int(line[0:7]+line[20:25],2)-4096)
        
        if funct3 == "000":
            inst = "SB"
        elif funct3 == "001":
            inst = "SH"
        elif funct3 == "010":
            inst = "SW"
        else:
            inst = "NOP"
        assembly = [inst, rs2, imm+'('+rs1+')']
    
    elif opcode == "1100011":   # Branch
        rs1 = 'x'+str(int(line[12:17],2))
        rs2 = 'x'+str(int(line[7:12],2))
        imm = str(int(line[0]+line[24]+line[1:7]+line[20:24]+'0',2) if int(line[0]+line[24]+line[1:7]+line[20:24]+'0',2) < 4096 else int(line[0]+line[24]+line[1:7]+line[20:24]+'0',2)-8192)

        if funct3 == "000":
            inst = "BEQ"
        elif funct3 == "001":
            inst = "BNE"
        elif funct3 == "100":
            inst = "BLT"
        elif funct3 == "101":
            inst = "BGE"
        elif funct3 == "110":
            inst = "BLTU"
        elif funct3 == "111":
            inst = "BGEU"
        else:
            inst = "NOP"
        assembly = [inst, rs1, rs2, imm]
    
    elif opcode == "1101111":   # Jump and Link
        inst = "JAL"
        rd = 'x'+str(int(line[20:25],2))
        imm = str(int(line[0]+line[12:20]+line[11]+line[1:11]+'0',2) if int(line[0]+line[12:20]+line[11]+line[1:11]+'0',2) < 1048576 else int(line[0]+line[12:20]+line[11]+line[1:11]+'0',2)-2097152)
        assembly = [inst, rd, imm]
    elif opcode == "1100111":   # Jump and Link Reg
        rd = 'x'+str(int(line[20:25],2))
        rs1 = 'x'+str(int(line[12:17],2))
        imm = str(int(line[0:12],2) if int(line[0:12],2) < 2048 else int(line[0:12],2)-4096)
        
        if funct3 == "000":
            inst = "JALR"
        else:
            inst = "NOP"
        assembly = [inst, rd, rs1, imm]
    elif opcode == "0110111":
        inst = "LUI"
        rd = 'x'+str(int(line[20:25],2))
        imm = str(int(line[0:20],2)*2^12 if int(line[0:20],2) < 2^19 else (int(line[0:12],2)-2^20)*2^12)
        assembly = [inst, rd, imm]
    elif opcode == "0010111":
        inst = "AUIPC"
        rd = 'x'+str(int(line[20:25],2))
        imm = str(int(line[0:20],2)*2^12 if int(line[0:20],2) < 2^19 else (int(line[0:12],2)-2^20)*2^12)
        assembly = [inst, rd, imm]
    else:
        assembly = ["NOP"]
    

    return assembly

i=0
for line in binLine:
    print(str(i), end='\t')
    for element in decompile(line):
        print(element, end='\t')
    print()
    i += 4