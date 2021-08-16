%% RecordAcce.m :
% Capturing Acceleration Data from Your Mobile Device

% This example shows how to collect acceleration data from an Android™ or 
% iOS mobile device.

% This example requires Signal Processing Toolbox™.

clear 
close all
clc

%% Define all the parameters here :

% example naming: Group8_Walkn_<N,S>_WalkCategory
% categories:
% Walk on even surface (A)
% Walk on uneven surface (B)﻿
% Walk fast (C)﻿
% Walk slow (D)﻿
% Slightly up a hill (E)﻿
% Slightly down a hill (F)﻿
% HIIT (slow-fast-slow-fast) (G)

prename = 'Group8_Walk9_N_' % change the index after walk and choose N/S
category = 'A'            % chose the right index
recDur = 30;                  % set the duration of the sampling
sample_rate = 90;            % set the sampling rate (in Hz)

% For silly walks :

% 1) The first Silly Walk can be seen in the beginning of the sketch.
%    John Cleese extends his left leg in front of him in every second 
%    step while his right leg is trailing behind 
%    (0:18min - 1:06min in the video). 

% 2) The second Silly Walk ist performed by the left man in the video in 
%    1:05min - 1:07min. He is hunched forward while he hops on his left 
%    leg and pulls his right leg to his chest.

% 3) The third Silly Walk is a movement which looks like a combination of 
%    hopping forward with the left leg and leaving the right leg trailing
%    behind. It is performed by the left man in the video
%    in 1:07min - 1:11min.

%% Set Up Your Mobile Device :

% In order to receive data from a mobile device in MATLAB®, you will need 
% to install and set up the MATLAB Mobile™ app on your mobile device.
% Log in to the MathWorks® Cloud from the MATLAB Mobile Settings.

% Before starting with sampling, you must create the file
% 'DataAcquisition'. Under this file, you should create the file 
% 'SamplingFunctions' and add the 'RecordAcce_mobile.m' file into this
% folder. The rest is done automatically.

% Prepare for data logging in MATLAB Mobile. 
% - Go to Sensors >> Sensor Settings >> Stream to >> MATLAB
% - Go to Sensors >> Sensor Settings >> switch "Sensors" on
% - Go to Sensors >> Sensors >> switch "Acceleration" on

%% Set Up the Logging for Acceleration and record initial timestamp :

m = mobiledev
m.InitialTimestamp
m.AccelerationSensorEnabled = 1;
m.Acceleration;

%% Change the sample rate :

m.SampleRate = sample_rate;

%% Start Acquiring Data :

pause('on');
pause('query');
disp('------------------------------------------')
disp(['Put your phone in your pocket within the next 7 seconds!'])
disp('------------------------------------------')
pause(1);
pause(1);
pause(1);
pause(1);
pause(1);
pause(1);
pause(1);

% After enabling the sensor, the Sensors screen of MATLAB Mobile will show 
% the current data measured by the sensor. The Logging property allows you 
% to begin sending sensor data to mobiledev.
disp([num2str(recDur) ' s logging starts now!'])
m.Logging = 1;

% The device is now transmitting sensor data.
% During logging, the device is held or kept in a pocket while walking 
% around. This generates changes in acceleration across all three axes, 
% regardless of device orientation.
t0 = clock;

for n = 1 : recDur
    pause(1)
end

%% Stop Acquiring Data :

% The Logging property is used to again to have the device stop sending sensor data to mobiledev.
m.Logging = 0;

%% Retrieve Logged Data :

% accellog is used to retrieve the XYZ acceleration data and timestamps transmitted from the device to mobiledev.
[a,t] = accellog(m);

%% Plot Raw Sensor Data :

% The logged acceleration data for all three axes can be plotted together.
f1 = figure('Name', 'Raw Data');
plot(t, a);
legend('X', 'Y', 'Z');
xlabel('Relative time (s)');
ylabel('Acceleration (m/s^2)');

%% Process Raw Acceleration Data :

% To convert the XYZ acceleration vectors at each point in time into scalar values, the magnitude is calculated. This allows large changes in overall acceleration, such as steps taken while walking, to be detected regardless of device orientation.
x = a(:,1);
y = a(:,2);
z = a(:,3);
mag = sqrt(sum(x.^2 + y.^2 + z.^2, 2));

% % The magnitude is plotted to visualize the general changes in acceleration.
% figure('Name','Acceleration')
% plot(t,mag);
% xlabel('Time (s)');
% ylabel('Acceleration (m/s^2)');


% The plot shows that the acceleration magnitude is not zero-mean. 
% Subtracting the mean from the data will remove any constant effects, 
% such as gravity.
magNoG = mag - mean(mag);

f2=figure('Name','Acceleration (corrected)');
plot(t,magNoG);
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');

% The plotted data is now centered about zero, and clearly shows peaks in 
% acceleration magnitude. Each peak corresponds to a step being taken while
% walking.

%% Save Figures and matfile :

mainFolder = '/MATLAB Drive/DataAcquisition/Samples/';
folder1Name = 'SignalPlots/';
folder1 = append(mainFolder, folder1Name);
folder2Name = 'Signals/';
folder2 = append(mainFolder, folder2Name);

%% Create the folders if they do not exist :

if not(isfolder(mainFolder))
    mkdir MATLAB Drive/DataAcquisition Samples;
end

if not(isfolder(folder1))
    mkdir MATLAB Drive/DataAcquisition/Samples SignalPlots;
end

if not(isfolder(folder2))
    mkdir MATLAB Drive/DataAcquisition/Samples Signals;
end

% t = datetime(datestr(now));
% t.TimeZone = 'GMT';
% t.TimeZone ='Europe/Berlin'; % convert to local time
% filename = datestr(t,'yyyy-mm-dd-THHMMSS');

filename= strcat(prename, category);

exportgraphics(f1,[folder1 filename 'acce_rax.tif']);
exportgraphics(f2,[folder1 filename 'Acce_mag.tif']);

data = a;
time = t;

save(strcat(folder2, filename, '.mat'), 'time', 'data')

%% Clean Up, Save Pictures :

% Turn off the acceleration sensor and clear mobiledev.
% m.AccelerationSensorEnabled = 0;

clear all;

% Copyright 2014 The MathWorks, Inc.