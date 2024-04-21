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
% gyroReadings(:, 2) = -1*gyroReadings(:, 2);
% accelReadings(:, 2) = -1*accelReadings(:, 2);
% accelReadings(:, 3) = -1*accelReadings(:, 3);
% magnetReadings(:, 3) = -1*magnetReadings(:, 3);

accel = accelReadings;
gyro= gyroReadings;
mag = magnetReadings;

accelerometerReadings = accel;
gyroscopeReadings = gyro;
magnetometerReadings = mag;
plot(gyro);

% rotation matrix from ahrsfilter
decim = 1;
Fs = 400;
fuse = ahrsfilter('SampleRate',Fs,'DecimationFactor',decim, 'GyroscopeNoise', GyroscopeNoiseADIS16505, 'AccelerometerNoise', AccelerometerNoiseADIS16505, 'LinearAccelerationDecayFactor', 0.09, 'MagneticDisturbanceDecayFactor', 0.09);
q = fuse(accelerometerReadings,gyroscopeReadings,magnetometerReadings);
rotMatrix = quat2rotm(q);

% rotation matrix from gyro integration only
gyroRotation = cumtrapz(1/400, gyroscopeReadings);
gyroRotation = wrapToPi(gyroRotation);
rotMatrixGyro = eul2rotm(gyroRotation);




rotatedAccel = zeros(5729,3);

for i = 1:5729

    rotatedAccel(i, :) = rotMatrixGyro(:,:,i) * transpose(accel(i, :));
end



rotatedAccel(:, 3) = rotatedAccel(:, 3) - 9.82;
% rotatedAccel = highpass(rotatedAccel, 0.1, 400);


velocity = cumtrapz(1/400, rotatedAccel);
trajectory = cumtrapz(1/400, velocity);

figure(1);
plot(rotatedAccel);
figure(3);
plot3(trajectory(1:4000, 1), trajectory(1:4000, 2), trajectory(1:4000, 3))
% Fs  = 400;  % 
% fuse = complementaryFilter('SampleRate', Fs);
% 
% q = fuse(accel, gyro, mag);
figure(2);
plot(eulerd( q, 'ZYX', 'frame'));
title('Orientation Estimate');
legend('Z-rotation', 'Y-rotation', 'X-rotation');
ylabel('Degrees');

figure(4);
plot(rad2deg(gyroRotation));
title('Orientation Estimate');
legend('X-rotation', 'Y-rotation', 'Z-rotation');
ylabel('Degrees');