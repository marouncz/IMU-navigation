clear all;
close all;

data = importdata("boardsLoggerData.csv");

f = insfilterMARG;
f.IMUSampleRate = 2000;
f.AccelerometerBiasNoise = 2e-4;
f.AccelerometerNoise = 2;
f.GyroscopeBiasNoise = 1e-16;
f.GyroscopeNoise = 1e-5;
f.MagnetometerBiasNoise = 1e-10;
f.GeomagneticVectorNoise = 1e-12;
f.StateCovariance = 1e-9*ones(22);
% f.State = initstate;
reflocIdx = find(~isnan(data.data(:, 9)), 1);
f.ReferenceLocation = data.data(reflocIdx,9:11);

gpsCovariance = [10 2 2; 2 10 2; 2 2 20];
N = size(data.data,1);
p = zeros(N,3);
q = zeros(N,1,'quaternion');


for ii = 1:N              % Fuse IMU
    if ~isnan(data.data(ii,1)) 
        f.predict(data.data(ii,6:8), data.data(ii,3:5));
    end
  
        
   if ~isnan(data.data(ii,9))              % Fuse GPS once per x samples

       f.fusegps(data.data(ii,9:11), gpsCovariance);
   end
 
   [p(ii,:),q(ii)] = pose(f);           %Log estimated pose
end

plot3(p(:, 1), p(:, 2), p(:, 3))
axis equal;
% plot3(truePos(:, 1), truePos(:, 2), truePos(:, 3))