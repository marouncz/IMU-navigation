clc
clear all
close all

data = readtable('output.csv');
data = table2struct(data);

plot([data.adisAccelX])
hold on;
plot([data.adisAccelY])
hold on;
plot([data.adisAccelZ])
hold on;


plot([data.mpuAccelX])
hold on;
plot([data.mpuAccelY])
hold on;
plot([data.mpuAccelZ])
hold on;
