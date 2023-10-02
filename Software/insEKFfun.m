close all;
clear all;
clc;
clf


imuData = importdata("RegStream_2023-09-30T17-57-50_0000.csv");

LSBtoms2 = 2.45e-3/(2^16);
LSBtorads = deg2rad(0.025)/(2^16);

accel(:, 1) = imuData.data(:, 7) * LSBtoms2;
accel(:, 2) = imuData.data(:, 9) * LSBtoms2;
accel(:, 3) = imuData.data(:, 11) * LSBtoms2;

gyro(:, 1) = imuData.data(:, 1) * LSBtorads;
gyro(:, 2) = imuData.data(:, 3) * LSBtorads;
gyro(:, 3) = imuData.data(:, 5) * LSBtorads;

model = insMotionPose;
accelSensor = insAccelerometer;
gyroSensor = insGyroscope;


filt = insEKF(accelSensor,gyroSensor, model);
accNoise = 10;
gyroNoise = 2;


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
    % Extract the orientation state estimate using the stateparts object
    % function.
   % [p(ii,:),q(ii)] = pose(filt); 
   estOrient(ii) = quaternion(stateparts(filt,"Orientation"));
   estPos(ii, :) = stateparts(filt,"Position");
end




% f = insEKF(accelSensor, gyroSensor, model);
% f.MotionModel = "insMotionPose";
% f.IMUSampleRate = 1994; %Hz sample rate
% f.ReferenceLocation = [49.223920 16.588313 250];
% % f.AccelerometerBiasNoise = 2e-4;
% % f.AccelerometerNoise = 2;
% % f.GyroscopeBiasNoise = 1e-16;
% % f.GyroscopeNoise = 1e-5;
% % f.MagnetometerBiasNo   ise = 1e-10;
% % f.GeomagneticVectorNoise = 1e-12;
% % f.StateCovariance = 1e-9*ones(22);
% % f.State = initstate;
% 
% 
% N = size(accel,1);
% p = zeros(N,3);
% q = zeros(N,1,'quaternion');
% 
% for ii = 1:size(accel,1)               % Fuse IMU
%    f.predict(accel(ii,:), gyro(ii,:));  
% 
% 
%    [p(ii,:),q(ii)] = pose(f);           %Log estimated pose
% end
% 
figure();
plot3(estPos(:, 1), estPos(:, 2), estPos(:, 3));
figure();
plot(rad2deg(quat2eul(estOrient())))
