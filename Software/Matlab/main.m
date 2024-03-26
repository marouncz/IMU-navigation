clear all
close all
clc
data = readtable('output.csv');

% GyroscopeNoise and AccelerometerNoise is determined from the datasheet.
GyroscopeNoiseADIS16505 = 3.0462e-06; % GyroscopeNoise (variance) in units of rad/s
AccelerometerNoiseADIS16505 = 0.0061; % AccelerometerNoise (variance) in units of m/s^2

accelReadings = data(:, 1:3);
gyroReadings = data(:, 4:6);
magnetReadings = data(:, 10:12);


accelReadings = table2array(accelReadings);
gyroReadings = table2array(gyroReadings);
magnetReadings = table2array(magnetReadings);
gyroReadings(:, 2) = -1*gyroReadings(:, 2);
accelReadings(:, 2) = -1*accelReadings(:, 2);
% accelReadings(:, 3) = -1*accelReadings(:, 3);
% magnetReadings(:, 3) = -1*magnetReadings(:, 3);

accel = accelReadings;
gyro= gyroReadings;
mag = magnetReadings;

f = insfilterMARG;
f.IMUSampleRate = 400;

% f.ReferenceLocation = refloc;
f.AccelerometerBiasNoise = 2e-4;
f.AccelerometerNoise = 2;
f.GyroscopeBiasNoise = 1e-16;
f.GyroscopeNoise = 1e-5;
f.MagnetometerBiasNoise = 1e-10;
f.GeomagneticVectorNoise = 1e-12;
f.StateCovariance = 1e-9*ones(22);
% f.State = initstate;

N=10000;
% gpsidx = 1;
% N = size(accel,1);
% p = zeros(N,3);
% q = zeros(N,1,'quaternion');
% 
% for ii = 1:size(accel,1)               % Fuse IMU
%    f.predict(accel(ii,:), gyro(ii,:));
%    f.fusemag(mag(ii,:),diag([0.0000000002 0.0000000002 0.0000000002]));
% 
%    % if ~mod(ii,fix(imuFs/2))            % Fuse magnetometer at 1/2 the IMU rate
%    %     f.fusemag(mag(ii,:),Rmag);
%    % end
% 
%    % if ~mod(ii,imuFs)                   % Fuse GPS once per second
%    %     f.fusegps(lla(gpsidx,:),Rpos,gpsvel(gpsidx,:),Rvel);
%    %     gpsidx = gpsidx + 1;
%    % end
% 
%    [p(ii,:),q(ii)] = pose(f);           %Log estimated pose
% end
% position = p;




accelSensor = insAccelerometer;
gyroSensor = insGyroscope;
magnetometerSensor = insMagnetometer;
motionModel = insMotionPose;
insFilter = insEKF(accelSensor, gyroSensor, magnetometerSensor, motionModel);
Ts = 1/400;
N = 10000;
position = zeros(N, 3);

for i=1:N
    predict(insFilter,Ts); % Ts sample time
    fuse(insFilter, accelSensor, accelReadings(i,:), diag([0.0000000002 0.0000000002 0.0000000002]));
    fuse(insFilter, gyroSensor, gyroReadings(i,:), diag([0.0000000002 0.0000000002 0.0000000002]));
    % fuse(insFilter, magnetometerSensor, magnetReadings(i,:), diag([0.9 0.9 0.9]));
    position(i, :) = stateparts(insFilter, "Position");
end


plot3(position(:, 1), position(:, 2), position(:, 3));