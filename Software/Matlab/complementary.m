clear all
close all
clc
data = readtable('ctverecChuze.csv');

% GyroscopeNoise and AccelerometerNoise is determined from the datasheet.
GyroscopeNoiseADIS16505 = 3.0462e-06; % GyroscopeNoise (variance) in units of rad/s
AccelerometerNoiseADIS16505 = 0.0061; % AccelerometerNoise (variance) in units of m/s^2

accel = [data.adisAccelX data.adisAccelY data.adisAccelZ];
gyro = [data.adisGyroX data.adisGyroY data.adisGyroZ];
gnssLLA = [ data.fLat data.fLon data.height./1000];
mag = [data.lsmMagX data.lsmMagY data.lsmMagZ];

%calculate initial Orientation based on gravity vector of the first sample
initAccel = accel(1, :);
initAccelNorm = initAccel/norm(initAccel);
gravity = [0 0 1];
initRotationAxis = cross(initAccelNorm, gravity);
initRotationAngle = acos(dot(initAccelNorm, gravity));
initRotationAxis = initRotationAxis/norm(initRotationAxis);
% convert axis and angle to rotation matrix
K = [0 -initRotationAxis(3) initRotationAxis(2); 
     initRotationAxis(3) 0 -initRotationAxis(1); 
     -initRotationAxis(2) initRotationAxis(1) 0];

R = eye(3) + sin(initRotationAngle) * K + (1 - cos(initRotationAngle)) * K^2;
init_euler_angles = rotm2eul(R, 'XYZ');


figure(1);
plot(gyro);
title("Raw gyro data")
figure(2);
plot(accel);
title("Raw accel data")

Fs = 400;

% rotation matrix from gyro integration only
gyroRotation = cumtrapz(1/Fs, gyro);
gyroRotation = gyroRotation + init_euler_angles;
gyroRotation = wrapToPi(gyroRotation);
rotMatrixGyro = eul2rotm(gyroRotation, "XYZ");

N = numel(accel(:,1));
rotatedAccel = zeros(N,3);


for i = 1:N

    rotatedAccel(i, :) = rotMatrixGyro(:,:,i) * transpose(accel(i, :));
end


rotatedAccelWithoutGravity = rotatedAccel;
rotatedAccelWithoutGravity(:, 3) = rotatedAccelWithoutGravity(:, 3) - 9.81275;
% rotatedAccelWithoutGravity = highpass(rotatedAccelWithoutGravity, 0.01, 400);

velocity = cumtrapz(1/Fs, rotatedAccelWithoutGravity);
trajectory = cumtrapz(1/Fs, velocity);

figure(3);
plot(rotatedAccel);
title("Acceleration vector with gravity with reference to earth");
figure(4);
plot(rotatedAccelWithoutGravity);
title("Acceleration vector without gravity with reference to earth");


figure(5);
plot3(trajectory(:, 1), trajectory(:, 2), trajectory(:, 3))
title("Calculated trajectory")

figure(6);
plot(rad2deg(gyroRotation));
title('Orientation Estimate');
legend('X-rotation', 'Y-rotation', 'Z-rotation');
ylabel('Degrees');