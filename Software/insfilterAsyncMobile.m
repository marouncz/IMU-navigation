close all;
clear all;
clc;

load("C:\Users\marou\MATLAB Drive\MobileSensorData\sensorlog_cestaAutobus.mat");

accelerationMatrix = [Acceleration.X, Acceleration.Y, Acceleration.Z];
simpleAcceleration = timetable(Acceleration.Timestamp, accelerationMatrix, VariableNames="Accelerometer");

gyroscopeMatrix = [AngularVelocity.X, AngularVelocity.Y, AngularVelocity.Z];
simpleGyroscope = timetable(AngularVelocity.Timestamp, gyroscopeMatrix, VariableNames="Gyroscope");

magnetometerMatrix = [MagneticField.X, MagneticField.Y, MagneticField.Z];
simpleMagnetometer = timetable(MagneticField.Timestamp, magnetometerMatrix, VariableNames="Magnetometer");

positionMatrix = [Position.latitude, Position.longitude, Position.altitude];
simplePosition = timetable(Position.Timestamp, positionMatrix, VariableNames="GPS");

sensorData = synchronize(simpleAcceleration, simpleGyroscope, simpleMagnetometer, simplePosition);



model = insMotionPose;
accelSensor = insAccelerometer;
magSensor = insMagnetometer;
gpsSensor = insGPS;
gyroSensor = insGyroscope;
options = insOptions(ReferenceFrame ="NED");
% measureNoise = struct("AccelerometerNoise", 1000, "GyroscopeNoise", 1000, "MagnetometerNoise", 1000, "GPSNoise", 1000);

filt = insfilterAsync();

accNoise = 100000;
gyroNoise = 10000;
magNoise = 10000;
gpsNoise = 10000;


N = size(sensorData.Properties.RowTimes,1);
p = zeros(N,3);
q = quaternion.zeros(N,1);
dt = seconds(diff(sensorData.Properties.RowTimes));
for ii = 1:3000
    if ii ~= 1
        % Step forward in time.
        filt.predict(dt(ii-1));
    end

    if(~isnan(sensorData.Accelerometer(ii)))
        fuseaccel(filt,sensorData.Accelerometer(ii,:),accNoise);
    end

    if(~isnan(sensorData.Magnetometer(ii)))
        fusemag(filt,sensorData.Magnetometer(ii,:),magNoise);
    end

    if(~isnan(sensorData.Gyroscope(ii)))
        fusegyro(filt,sensorData.Gyroscope(ii,:),gyroNoise);
    end

    if(~isnan(sensorData.GPS(ii)))
        fusegps(filt,sensorData.GPS(ii,:),gpsNoise);
    end
   

    [p(ii,:),q(ii)] = pose(filt);
end


plot3(p(:, 1), p(:, 2), p(:, 3));
xlabel('X')
ylabel('Y')
zlabel('Z')
axis("equal")
figure();
plot(rad2deg(quat2eul(q())))

