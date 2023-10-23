

import clr
from time import sleep
import os
import System
import csv
import datetime;

# open the file in the write mode
f = open('data.csv', 'w')

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
Dut.UserLEDBlink(2.0)
sleep(0.5) #wait 500ms for the ADIS16505 to wake up

#Create reg list

regs_py = ['MSC_CTRL','DATA_CNTR','X_GYRO_OUT','Y_GYRO_OUT','Z_GYRO_OUT','X_ACCL_OUT','Y_ACCL_OUT','Z_ACCL_OUT']
writer.writerow(regs_py)
regs = Array[String](regs_py)
data = []

for i in range(1, 10000):
    data = Dut.ReadSigned(regs)
    writer.writerow(data)

f.close()

# while True:
#     data = Dut.ReadSigned(regs)
#     for i in (data): 
#         print(i, end =" ") 
#     print()
#     sleep(0.5)