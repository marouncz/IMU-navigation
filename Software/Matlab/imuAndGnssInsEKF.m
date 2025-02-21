clear all
close all
clc
data = readtable('koleckoKolemFEKTU.csv');
% data.adisAccelY = -data.adisAccelY;
% data.adisAccelZ = -data.adisAccelZ;
% data.adisGyroY = -data.adisGyroY;
% data.adisGyroZ = -data.adisGyroZ;


% GyroscopeNoise and AccelerometerNoise is determined from the datasheet.
GyroscopeNoiseADIS16505 = 3.0462e-06; % GyroscopeNoise (variance) in units of rad/s
AccelerometerNoiseADIS16505 = 0.0061; % AccelerometerNoise (variance) in units of m/s^2

accel = [data.adisAccelX data.adisAccelY data.adisAccelZ];
gyro = [data.adisGyroX data.adisGyroY data.adisGyroZ];
gnssLLA = [data.fLat data.fLon data.height./1000];
mag = [data.lsmMagX data.lsmMagY data.lsmMagZ];

latitude = rmmissing(data.fLat);
longitude = rmmissing(data.fLon);

accelModel = insAccelerometer;
gyroModel = insGyroscope;
option = insOptions(ReferenceFrame="ENU");
imuFs = 400;
f = insEKF(insAccelerometer,insGyroscope,insMotionPose, option);
stateparts(f, "Position", )
f.IMUSampleRate = imuFs;
f.ReferenceLocation = gnssLLA(find(~isnan(data.fLat), 1), :);
% f.AccelerometerBiasNoise = 2e-4;
% f.AccelerometerNoise = AccelerometerNoiseADIS16505;
% f.GyroscopeBiasNoise = 1e-16;
% f.GyroscopeNoise = GyroscopeNoiseADIS16505;
% f.MagnetometerBiasNoise = 1e-10;
% f.GeomagneticVectorNoise = 1e-12;
f.StateCovariance = 1e-9*ones(22);
% % f.State = initstate;
 
gpsidx = 1;
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
       f.fusegps(gnssLLA(ii,:),diag([1 1 1]));

   end
 
   [p(ii,:),q(ii)] = pose(f);           %Log estimated pose
end


[fusedLat, fusedLon, fusedAlt] = local2latlon(p(:,1), p(:,2), p(:,3), f.ReferenceLocation);


figure(1)
plot3(p(:, 1), p(:, 2), p(:, 3));
figure(2)
geoplot(latitude, longitude);
title("Unprocessed GNSS data")
figure(3)
geoplot(fusedLat, fusedLon);
title("Fused GNSS data")