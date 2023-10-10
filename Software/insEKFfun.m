close all;
clear all;
clc;
clf


imuData = importdata("RegStream_2023-10-10T20-09-44_0000.csv");

LSBtoms2 = 2.45e-3/(2^16);
LSBtorads = deg2rad(0.025/(2^16));

accel(:, 1) = imuData.data(:, 7) * LSBtoms2;
accel(:, 2) = imuData.data(:, 9) * LSBtoms2;
accel(:, 3) = imuData.data(:, 11) * LSBtoms2;

gyro(:, 1) = imuData.data(:, 1) * LSBtorads;
gyro(:, 2) = imuData.data(:, 3) * LSBtorads;
gyro(:, 3) = imuData.data(:, 5) * LSBtorads;

model = insMotionPose;
accelSensor = insAccelerometer;
gyroSensor = insGyroscope;
options = insOptions(ReferenceFrame ="NED");


filt = insEKF(accelSensor,gyroSensor, model, options);

accNoise = 0.1739;
gyroNoise = 1.1129;
processNoise = diag([ ...
    2.8586 1.3718 0.8956 3.2148 4.3574 2.5411 3.2148 0.5465 0.2811 ...
    1.7149 0.1739 0.7752 0.1739 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1]);
filt.AdditiveProcessNoise = processNoise;


N = size(accel,1);
estPos = zeros(N,3);
estOrient = quaternion.zeros(N,1);
dt = 1/1994;
for ii = 1:N
    if ii ~= 1
        % Step forward in time.
        predict(filt,dt);
    end
    % Fuse accelerometer data.
    fuse(filt,accelSensor,accel(ii,:),accNoise);
    % Fuse gyroscope data.
    fuse(filt,gyroSensor,gyro(ii,:),gyroNoise);

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
