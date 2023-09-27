close all;
clear all;
clc;


imuData = importdata("RegStream_2023-09-24T21-58-14_0000.csv");
LSBtoms2 = 2.45e-3/(2^16);
LSBtorads = deg2rad(0.025)/(2^16);

accel(:, 1) = imuData.data(:, 7) * LSBtoms2;
accel(:, 2) = imuData.data(:, 9) * LSBtoms2;
accel(:, 3) = imuData.data(:, 11) * LSBtoms2;

gyro(:, 1) = imuData.data(:, 1) * LSBtorads;
gyro(:, 2) = imuData.data(:, 3) * LSBtorads;
gyro(:, 3) = imuData.data(:, 5) * LSBtorads;


f = insfilterMARG;
f.IMUSampleRate = 1994; %Hz sample rate
f.ReferenceLocation = [49.223920 16.588313 250];
% f.AccelerometerBiasNoise = 2e-4;
% f.AccelerometerNoise = 2;
% f.GyroscopeBiasNoise = 1e-16;
% f.GyroscopeNoise = 1e-5;
% f.MagnetometerBiasNoise = 1e-10;
% f.GeomagneticVectorNoise = 1e-12;
% f.StateCovariance = 1e-9*ones(22);
% f.State = initstate;
 

N = size(accel,1);
p = zeros(N,3);
q = zeros(N,1,'quaternion');

for ii = 1:size(accel,1)               % Fuse IMU
   f.predict(accel(ii,:), gyro(ii,:));


       
 
   [p(ii,:),q(ii)] = pose(f);           %Log estimated pose
end

plot3(p(:, 1), p(:, 2), p(:, 3))
