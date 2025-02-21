clear all
close all
clc
data = readtable('koleckoKolemFEKTUCALB.csv');


% GyroscopeNoise and AccelerometerNoise is determined from the datasheet.
GyroscopeNoiseADIS16505 = [deg2rad(0.082) deg2rad(0.082) deg2rad(0.116)]; 
GyroscopeBiasNoiseADIS16505 = [deg2rad(2.2/3600) deg2rad(2.7/3600) deg2rad(1.6/3600)];
AccelerometerNoiseADIS16505 = [0.0048 0.0048 0.00607]; 
AccelerometerBiasNoiseADIS16505 = [26.5e-6 26.5e-6 43.1e-6];

accel = [data.adisAccelX data.adisAccelY data.adisAccelZ];
gyro = [data.adisGyroX data.adisGyroY data.adisGyroZ];
gnssLLA = [ data.fLat data.fLon data.height./1000];
mag = [data.lsmMagX data.lsmMagY data.lsmMagZ];

latitude = rmmissing(data.fLat);
longitude = rmmissing(data.fLon);

imuFs = 400;
f = insfilterMARG('ReferenceFrame','ENU');
f.IMUSampleRate = imuFs;
f.ReferenceLocation = gnssLLA(find(~isnan(data.fLat), 1), :);
% f.AccelerometerBiasNoise = AccelerometerBiasNoiseADIS16505;
% f.AccelerometerNoise = AccelerometerNoiseADIS16505;
% f.GyroscopeBiasNoise = GyroscopeBiasNoiseADIS16505;
% f.GyroscopeNoise = GyroscopeNoiseADIS16505;
% f.MagnetometerBiasNoise = 1e-10;
% f.GeomagneticVectorNoise = 1e-12;
f.StateCovariance = 1e-9*ones(22);
% f.State = initstate;
 

N = size(accel,1);
p = zeros(N,3);
q = zeros(N,1,'quaternion');

for ii = 1:size(accel,1)               % Fuse IMU
   f.predict(accel(ii,:), gyro(ii,:));
        
   % if ~isnan(data.lsmMagX(ii))                    % Fuse  magnetometer
   %     f.fusemag(mag(ii,:),diag([1 1 1]));
   % 
   % end

   if ~isnan(data.fLat(ii))                    % Fuse GPS 
       f.fusegps(gnssLLA(ii,:),diag([10 10 10]));

   end
    
   [p(ii,:),q(ii)] = pose(f);           %Log estimated pose
   stateinfos(ii, :) = f.State;
   
end


[fusedLat, fusedLon, fusedAlt] = local2latlon(p(:,1), p(:,2), p(:,3), f.ReferenceLocation);


figure(1)
plot3(p(:, 1), p(:, 2), p(:, 3));
title("Vypočtený odhad trajektorie")
xlabel("Osa X (m)")
ylabel("Osa Y (m)")
zlabel("Osa Z (m)")
figure(2)
geoplot(latitude, longitude);
title("Originální GNSS data")

figure(3)
geoplot(fusedLat, fusedLon);
title("Fúze GNSS + IMU")
