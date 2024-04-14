import struct
import csv

# Define the format strings for unpacking the binary data
adis_format = "ddddddfL"  # Format for adisDataStruc (6x double 1x float 1x uint32)
lsm_format = "fff"         # Format for lsmDataStruc (3x float)
mpu_format = "fffffff"         # Format for mpuDataStruc (7 x float)
gnss_format = "LLLLLLLffllLLllL"         # Format for gnssLoggedDataStruc (7x uint32 2x float 2x int32 2x uint32 2x int32 1xpadding)

allStrucFormat = adis_format + lsm_format + mpu_format + gnss_format


adis_header = ['adisAccelX', 'adisAccelY', 'adisAccelZ', 'adisGyroX', 'adisGyroY', 'adisGyroZ', 'adisTemp', 'adisDataCNT']
lsm_header = ['lsmMagX', 'lsmMagY', 'lsmMagZ']
mpu_header = ['mpuAccelX', 'mpuAccelY', 'mpuAccelZ', 'mpuGyroX', 'mpuGyroY', 'mpuGyroZ', 'mpuTemp']
gnss_header = [
    'year', 
    'month', 
    'day', 
    'hour', 
    'min', 
    'sec', 
    'fixType', 
    'fLon', 
    'fLat', 
    'height', 
    'hMSL', 
    'hAcc', 
    'vAcc', 
    'gSpeed', 
    'headMot',
    'padding'
]

allStrucHeader = adis_header + lsm_header + mpu_header + gnss_header


# Open the binary file for reading
with open('IMUDATA.BIN', 'rb') as f:
    data = f.read()

# Define the output CSV file name
csv_file = 'output.csv'

# Open the CSV file for writing
with open(csv_file, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)

    # Write the header row
    writer.writerow(allStrucHeader)

    # Unpack the binary data and write to CSV row by row
    for i in range(0, len(data), struct.calcsize(allStrucFormat)):
        unpackData = struct.unpack(allStrucFormat, data[i:i+struct.calcsize(allStrucFormat)])
       

        # Convert data to strings and write to CSV
        writer.writerow([str(item) for item in unpackData])

print(f"CSV file '{csv_file}' has been created successfully.")