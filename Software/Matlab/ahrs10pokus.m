clear all
close all
clc
data = readtable('output.csv');

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

accelData = accelReadings;
gyroData= gyroReadings;
magData = magnetReadings;

filt = ahrs10filter('IMUSampleRate',400);

Ralt = 0.24;
Rmag = 0.9;


numIMUSamples = size(accelData,1);
estHeight = zeros(numIMUSamples,3);
estOrient = zeros(numIMUSamples,1,'quaternion');


for ii = 1:numIMUSamples
    
    % Use predict to estimate the filter state based on the accelometer and
    % gyroscope data.
    predict(filt,accelData(ii,:),gyroData(ii,:));
    % fusemag(filt,magData(ii,:),Rmag);
    
    % Magnetometer data is collected at a lower rate than IMU data. Fuse
    % magnetometer data at the lower rate.
    % if ~mod(ii,imuSamplesPerMag)
    %     fusemag(filt,magData(ii,:),Rmag);
    % end
    
    % Altimeter data is collected at a lower rate than IMU data. Fuse
    % altimeter data at the lower rate.
    % if ~mod(ii, imuSamplesPerAlt)
    %     fusealtimeter(filt,altData(ii),Ralt);
    % end
    
    % Log the current height and orientation estimate.
    [estHeight(ii),estOrient(ii)] = pose(filt);
end

plot(eulerd( estOrient, 'ZYX', 'frame'));
title('Orientation Estimate');
legend('Z-rotation', 'Y-rotation', 'X-rotation');
ylabel('Degrees');

rotMatrix = quat2rotm(estOrient);

rotatedAccel = zeros(10000,3);

for i = 1:10000

    rotatedAccel(i, :) = rotMatrix(:,:,i) * transpose(accelData(i, :));
end

rotatedAccel(:, 3) = rotatedAccel(:, 3) - 9.82;

velocity = cumtrapz(1/400, rotatedAccel);
trajectory = cumtrapz(1/400, velocity);

figure(1);
plot(rotatedAccel);
figure(3);
plot3(trajectory(1:4000, 1), trajectory(1:4000, 2), trajectory(1:4000, 3))