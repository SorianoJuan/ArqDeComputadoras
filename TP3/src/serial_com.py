import sys
import serial
import time

ser = serial.Serial('/dev/ttyUSB1', 9600)


ser.flushOutput()
ser.flushInput()

print("Esperando respuesta...")
while(True):
    res = ser.read()

    print(">> Obtenido:")
    print(int.from_bytes(res, byteorder=sys.byteorder))
