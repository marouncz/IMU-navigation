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
port = 'COM24'
baud_rate = 9600

# Open the serial port
ser = serial.Serial(port, baud_rate, timeout=1)

# Create a CSV file to save the GPS coordinates
csv_filename = 'gps_coordinates.csv'

with open(csv_filename, 'w', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(['Latitude', 'Longitude', 'Altitude'])

    try:
        while True:
            # Read a line from the serial port
            line = ser.readline().decode('utf-8').strip()

            # Check if the line contains GPS data
            if line.startswith('$GNGGA'):
                data = line.split(',')
                if len(data) >= 10:
                    latitude = dmm_to_dd(data[2], data[3])
                    longitude = dmm_to_dd(data[4], data[5])
                    altitude = data[9]

                    # Write the GPS data to the CSV file
                    csv_writer.writerow([latitude, longitude, altitude])
                    print(f"Latitude: {latitude:.7f}, Longitude: {longitude:.7f}, Altitude: {altitude}")
    
    except KeyboardInterrupt:
        print("GPS data collection stopped.")
    
    finally:
        ser.close()
