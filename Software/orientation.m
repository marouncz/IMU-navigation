close all;
clear all;
clc;


imuData = importdata("RegStream_2023-09-25T22-43-27_0000.csv");
LSBtoms2 = 2.45e-3/(2^16);
LSBtorads = deg2rad(0.025)/(2^16);

accel(:, 1) = imuData.data(:, 7) * LSBtoms2;
accel(:, 2) = imuData.data(:, 9) * LSBtoms2;
accel(:, 3) = imuData.data(:, 11) * LSBtoms2;

gyro(:, 1) = imuData.data(:, 1) * LSBtorads;
gyro(:, 2) = imuData.data(:, 3) * LSBtorads;
gyro(:, 3) = imuData.data(:, 5) * LSBtorads;

numOfMes = size(accel, 1);
g = 9.81;

Fs  = 1994;  % Hz
decim = 1;    % 
fuse = imufilter('SampleRate', Fs, 'DecimationFactor', decim);

% Fuse accelerometer and gyroscope
q = fuse(accel, gyro); %calculated quaternion
R = quat2rotm(q); %calculate rotation matrixes for each quaternion
% R = fuse(accel, gyro); 

accelEarth = zeros([numOfMes 3]);
for i = 1:numOfMes
    accelEarth(i, :) = accel(i, :)*R(:,:,i); %rotate acceleration to reference by earth
end

accelEarthWithoutG = accelEarth;
accelEarthWithoutG(:, 3) = accelEarthWithoutG(:, 3) - g; %subtract gravitational acceleration

trajectoryX = cumtrapz(1/Fs, cumtrapz(1/Fs, accelEarthWithoutG(:, 1)));
trajectoryY = cumtrapz(1/Fs, cumtrapz(1/Fs, accelEarthWithoutG(:, 2)));
trajectoryZ = cumtrapz(1/Fs, cumtrapz(1/Fs, accelEarthWithoutG(:, 3)));

plot3(trajectoryX, trajectoryY, trajectoryZ);

eul =  eulerd( q, 'ZYX', 'frame');

% Plot Euler angles in degrees
plot(eul);
title('Orientation Estimate');
legend('Z-rotation', 'Y-rotation', 'X-rotation');
ylabel('Degrees');