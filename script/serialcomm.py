import serial
from prettytable import PrettyTable

regs_name = ['r0','r1','r2','r3','r4','r5','r6','r7','r8','r9','r10','r11','r12','r13','r14','r15']
addrs_name = ['0x00','0x01','0x02','0x03','0x04','0x05','0x06','0x07','0x08','0x09','0x10','0x11','0x12','0x13','0x14','0x15']

ser = serial.Serial(port='/dev/ttyUSB0',
                    baudrate=115200,
                    stopbits=serial.STOPBITS_ONE,
                    timeout=1)

while 1:
    data = input("Type the number of clks to execute or 'e' to exit: ")

    if data == 'e':
        break

    for j in range(0, int(data)):
        ser.write(b'q')
        regs_value = ser.read(16);
        ram_value = ser.read(16);

        t_regs = PrettyTable(regs_name)
        t_regs.add_row(regs_value)
        print("\nRegisters Content:")
        print(t_regs)

        t_ram = PrettyTable(addrs_name)
        t_ram.add_row(ram_value)
        print("\nRAM Memory Content:")
        print(t_ram)
        print()

ser.close()
