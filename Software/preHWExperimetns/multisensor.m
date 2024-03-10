clear all
close all

gpsData = importdata("gps_coordinates.csv");
geoplot(gpsData.data(:, 1), gpsData.data(:, 2));
geobasemap streets