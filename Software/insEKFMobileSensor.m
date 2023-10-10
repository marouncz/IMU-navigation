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
% LSBtoms2 = 2.45e-3/(2^16);
% LSBtorads = deg2rad(0.025/(2^16));
% 
% accel(:, 1) = imuData.data(:, 7) * LSBtoms2;
% accel(:, 2) = imuData.data(:, 9) * LSBtoms2;
% accel(:, 3) = imuData.data(:, 11) * LSBtoms2;
% 
% gyro(:, 1) = imuData.data(:, 1) * LSBtorads;
% gyro(:, 2) = imuData.data(:, 3) * LSBtorads;
% gyro(:, 3) = imuData.data(:, 5) * LSBtorads;


model = insMotionPose;
accelSensor = insAccelerometer;
gyroSensor = insGyroscope;
options = insOptions(ReferenceFrame ="NED");
measureNoise = struct("AccelerometerNoise", 1000, "GyroscopeNoise", 1000, "MagnetometerNoise", 1000, "GPSNoise", 1000);

filt = insEKF(accelSensor,gyroSensor, insMagnetometer, insGPS, model, options);

[estimates,smoothEstimates] = estimateStates(filt,sensorData, measureNoise);
% accNoise = 100000;
% gyroNoise = 10000;
% 
% 
% N = size(accel,1);
% estPos = zeros(N,3);
% estOrient = quaternion.zeros(N,1);
% dt = 1/1994;
% for ii = 1:N
%     if ii ~= 1
%         % Step forward in time.
%         predict(filt,dt);
%     end
%     % Fuse accelerometer data.
%     fuse(filt,accelSensor,accel(ii,:),accNoise);
%     % Fuse gyroscope data.
%     fuse(filt,gyroSensor,gyro(ii,:),gyroNoise);
% 
%    estOrient(ii) = quaternion(stateparts(filt,"Orientation"));
%    estPos(ii, :) = stateparts(filt,"Position");
% end




plot3(estimates.Position(:, 1), estimates.Position(:, 2), estimates.Position(:, 3))
xlabel('X')
ylabel('Y')
zlabel('Z')
axis("equal")
figure();
plot(rad2deg(quat2eul(estimates.Orientation)))
