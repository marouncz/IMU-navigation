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

# Define the serial port and baud rate
port = 'COM27'
baud_rate = 9600

# Open the serial port
ser = serial.Serial(port, baud_rate, timeout=1)





import clr
from time import sleep
import os
import System
import csv
import datetime;

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

regs_py = ['MSC_CTRL','DATA_CNTR','X_GYRO_OUT','Y_GYRO_OUT','Z_GYRO_OUT','X_ACCL_OUT','Y_ACCL_OUT','Z_ACCL_OUT']
csvHeader = regs_py + ["LATITUDE", "LONGITUDE", "ALTITUDE"]
writer.writerow(csvHeader)
regs = Array[String](regs_py)
data = []
previousData = [0, 0]
Dut.StartBufferedStream(regs, System.UInt32(1), System.UInt32(20000), System.Int32(10))
for i in range(1, 100):
    # data = Dut.ReadSigned(regs, System.UInt32(10), System.UInt32(10))
    sleep(0.1)
    buffer = Dut.GetBufferedStreamDataPacket()
    
    while buffer is not None:
        data = Dut.ConvertBufferDataToU32(buffer)
        if data[1] != previousData[1]:
            writer.writerow(data)
            #print(data[1])
            previousData = data
        buffer = Dut.GetBufferedStreamDataPacket()
    #Dut.StartBufferedStream(regs, System.UInt32(1), System.UInt32(2000), System.Int32(10))
    

    # Read a line from the serial port
    line = ser.readline().decode('utf-8').strip()

    # Check if the line contains GPS data
    if line.startswith('$GNGGA'):
        data = line.split(',')
        if len(data) >= 10:
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