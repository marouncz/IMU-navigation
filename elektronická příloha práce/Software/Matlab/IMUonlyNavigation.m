clear all
close all
clc
data = readtable('ctverecChuze.csv');

% load data
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
title("Naměřená úhlová rychlost")
legend('X', 'Y', 'Z');
xlabel("Číslo vzorku")
ylabel("Úhlová rychlost (rad \cdot s^{-1})")
figure(2);
plot(accel);
title("Naměřené lineární zrychlení")
legend('X', 'Y', 'Z');
xlabel("Číslo vzorku (-)")
ylabel("Lineární zrychlení (m \cdot s^{-2})")

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
title("Naměřené lineární zrychlení otočené do e-frame, včetně tíhového zrychlení")
legend('X', 'Y', 'Z');
xlabel("Číslo vzorku (-)")
ylabel("Lineární zrychlení (m \cdot s^{-2})")
figure(4);
plot(rotatedAccelWithoutGravity);
title("Naměřené lineární zrychlení otočené do e-frame, bez tíhového zrychlení")
legend('X', 'Y', 'Z');
xlabel("Číslo vzorku (-)")
ylabel("Lineární zrychlení (m \cdot s^{-2})")
ylim([-10 10])

figure(5);
plot3(trajectory(:, 1), trajectory(:, 2), trajectory(:, 3))
title("Vypočtený odhad trajektorie")
xlabel("Osa X (m)")
ylabel("Osa Y (m)")
zlabel("Osa Z (m)")

figure(6);
plot(rad2deg(gyroRotation));
title('Odhad natočení');
legend('X rotace', 'Y rotace', 'Z rotace');
ylabel('Natočení kolem osy (°)');
xlabel("Číslo vzorku (-)")