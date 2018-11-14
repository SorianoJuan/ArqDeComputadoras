import sys
import serial
import time

command = bytearray()
command.append(0x04)
command.append(0x02)
command.append(0x20)
# command = b'\x07\x02\x20'

ser = serial.Serial('/dev/ttyUSB1', 9600)


ser.flushOutput()
ser.flushInput()

print("Escribiendo en puerto...")

print('Envio')
ser.write(command)
# print(bin(int.from_bytes(val1, byteorder=sys.byteorder)))
# ser.write(val1)
# time.sleep(5)
# print('Envio')
# ser.write(val2)
# time.sleep(5)
# print('Envio')
# ser.write(op)
# time.sleep(5)

print("Esperando respuesta...")
res = ser.read()

print(">> Obtenido:")
print(int.from_bytes(res, byteorder=sys.byteorder))
