import serial
import csv

def dmm_to_dd(dmm_str, direction):
    # Convert degrees, minutes, and decimal minutes (DMM) to decimal degrees (DD)
    dmm = float(dmm_str)
    degrees = int(dmm // 100)
    minutes = dmm - (degrees * 100)
    dd = degrees + minutes / 60
    if direction == 'S' or direction == 'W':
        dd = -dd
    return dd

def twos_complement_to_int(value):
    # Check if the most significant bit (sign bit) is set
    if value & 0x80000000:
        # Negative value
        # Extract the magnitude (least significant 31 bits) and subtract it from 2^31
        magnitude = value & 0x7FFFFFFF
        integer_value = -(2**31 - magnitude)
    else:
        # Positive value, use the magnitude as is
        integer_value = value

    return integer_value

# Define the serial port and baud rate
port = 'COM19'
baud_rate = 9600

# Open the serial port
ser = serial.Serial(port, baud_rate, timeout=1)





import clr
from time import sleep
import os
import System
import csv
import datetime;
import math

# open the file in the write mode
f = open('boardsLoggerData.csv', 'w')

# create the csv writer
writer = csv.writer(f)

#get path to resources folder and dll
topDir = os.getcwd()

#Load FX3 API Wrapper DLL
clr.AddReference(topDir + '\\resources\\FX3ApiWrapper.dll')

#Allows wrapper to be treated like standard python library
from FX3ApiWrapper import *
from System import Array
from System import String

#Create FX3 Wrapper and load ADIS1650x regmap
Dut = Wrapper(topDir + '\\resources\\', topDir + '\\regmaps\\ADIS1650x_Regmap.csv', 0)

print(Dut.FX3.GetFirmwareVersion)
#Blink user LED at 5Hz
Dut.UserLEDBlink(5.0)


#reset DUT
Dut.ResetDut()
sleep(0.5)



#Create reg list

regs_py = ['MSC_CTRL','DATA_CNTR','X_GYRO_LOW','Y_GYRO_LOW','Z_GYRO_LOW','X_ACCL_LOW','Y_ACCL_LOW','Z_ACCL_LOW']

LSBtoms2 = 2.45e-3/(2**16)
LSBtorads = math.radians(0.025/(2**16))


gpsRegs = ["LATITUDE", "LONGITUDE", "ALTITUDE"]
csvHeader = regs_py + gpsRegs
writer.writerow(csvHeader)
regs = Array[String](regs_py)
data = []
previousData = [0, 0]
Dut.StartBufferedStream(regs, System.UInt32(1), System.UInt32(20000), System.Int32(10))
for i in range(1, 500):
    # data = Dut.ReadSigned(regs, System.UInt32(10), System.UInt32(10))
    sleep(0.1)
    buffer = Dut.GetBufferedStreamDataPacket()
    
    while buffer is not None:
        data = Dut.ConvertBufferDataToU32(buffer)
        if data[1] != previousData[1]:
            intData = [int(value) for value in data]
            # writer.writerow(data)
            intData[2] = twos_complement_to_int(intData[2])*LSBtorads
            intData[3] = twos_complement_to_int(intData[3])*LSBtorads
            intData[4] = twos_complement_to_int(intData[4])*LSBtorads
            intData[5] = twos_complement_to_int(intData[5])*LSBtoms2
            intData[6] = twos_complement_to_int(intData[6])*LSBtoms2
            intData[7] = twos_complement_to_int(intData[7])*LSBtoms2

            writer.writerow(intData + ['']*len(gpsRegs))
            # print(data[1])
            previousData = data
        buffer = Dut.GetBufferedStreamDataPacket()
    #Dut.StartBufferedStream(regs, System.UInt32(1), System.UInt32(2000), System.Int32(10))
    

    # Read a line from the serial port
    line = ser.readline().decode('utf-8').strip()

    # Check if the line contains GPS data
    if line.startswith('$GNGGA'):
        data = line.split(',')
        if len(data) >= 10 and not(data[2] == ''):
            latitude = dmm_to_dd(data[2], data[3])
            longitude = dmm_to_dd(data[4], data[5])
            altitude = data[9]

            data = ['']*len(regs_py)
            data.append(latitude)
            data.append(longitude)
            data.append(altitude)
            writer.writerow(data)
            print(data)

            
            

f.close()

# while True:
#     data = Dut.ReadSigned(regs)
#     for i in (data): 
#         print(i, end =" ") 
#     print()
#     # sleep(0.5)