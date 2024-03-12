close all;
clear all;
clc;



load("C:\Users\marou\MATLAB Drive\MobileSensorData\sensorlog_20231009_225924.mat");

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

filt = insEKF(accelSensor,gyroSensor, magSensor, gpsSensor, model, options);

accNoise = 100000;
gyroNoise = 100000;
magNoise = 100000;
gpsNoise = 1000;


N = size(sensorData.Properties.RowTimes,1);
estPos = zeros(N,3);
estOrient = quaternion.zeros(N,1);
dt = seconds(diff(sensorData.Properties.RowTimes));
for ii = 1:N
    if ii ~= 1
        % Step forward in time.
        predict(filt,dt(ii-1));
    end

    if(~isnan(sensorData.Accelerometer(ii)))
        fuse(filt,accelSensor,sensorData.Accelerometer(ii,:),accNoise);
    end

    if(~isnan(sensorData.Magnetometer(ii)))
        fuse(filt,magSensor,sensorData.Magnetometer(ii,:),magNoise);
    end

    if(~isnan(sensorData.Gyroscope(ii)))
        fuse(filt,gyroSensor,sensorData.Gyroscope(ii,:),gyroNoise);
    end

    if(~isnan(sensorData.GPS(ii)))
        fuse(filt,gpsSensor,sensorData.GPS(ii,:),gpsNoise);
    end
   

   estOrient(ii) = quaternion(stateparts(filt,"Orientation"));
   estPos(ii, :) = stateparts(filt,"Position");
end


plot3(estPos(:, 1), estPos(:, 2), estPos(:, 3));
xlabel('X')
ylabel('Y')
zlabel('Z')
axis("equal")
figure();
plot(rad2deg(quat2eul(estOrient())))

% 
% plot3(estimates.Position(:, 1), estimates.Position(:, 2), estimates.Position(:, 3))
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% axis("equal")
% figure();
% plot(rad2deg(quat2eul(estimates.Orientation)))
