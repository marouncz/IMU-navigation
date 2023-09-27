close all;
clear all;
clc;

imuData = importdata("evalBoardLOG.csv");
%1 LSB = 2.45mms2 accl
LSBtoms2 = 2.45e-3;

acclX = imuData.data(:, 9) * LSBtoms2;
acclY = imuData.data(:, 11) * LSBtoms2;
acclZ = imuData.data(:, 13) * LSBtoms2;





trajectoryX = cumtrapz(acclX);
trajectoryY = cumtrapz(acclY);
trajectoryZ = cumtrapz(acclZ);

plot3(trajectoryX, trajectoryY, trajectoryZ);