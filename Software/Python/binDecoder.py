import struct
import csv

# Define the format strings for unpacking the binary data
adis_format = "ddddddfHHfffI"  # Format for adisDataStruc (8 doubles, 1 float, 2 uint16_t)
lsm_format = ""         # Format for lsmDataStruc (3 floats)
print(struct.calcsize(adis_format))
print(struct.calcsize(lsm_format))

# Open the binary file for reading
with open('sample3.bin', 'rb') as f:
    data = f.read()

# Define the output CSV file name
csv_file = 'output.csv'

# Open the CSV file for writing
with open(csv_file, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)

    # Write the header row
    writer.writerow(['accelX', 'accelY', 'accelZ', 'gyroX', 'gyroY', 'gyroZ', 'temp', 'dataCNT', 'pad', 'magX', 'magY', 'magZ', 'pad'])

    # Unpack the binary data and write to CSV row by row
    for i in range(0, len(data), struct.calcsize(adis_format)):
        adis_data = struct.unpack(adis_format, data[i:i+struct.calcsize(adis_format)])
       

        # Convert data to strings and write to CSV
        writer.writerow([str(item) for item in adis_data])

print(f"CSV file '{csv_file}' has been created successfully.")