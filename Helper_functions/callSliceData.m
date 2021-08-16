
% This is a call function for the function sliceData, which is implemented
% to slice the pre-defined beginning and end of the measurement data in
% order to obtain a data without much noise regarding the phone movement in
% the beginning and at the end of each measurement :

clear 
clc

% give the name of the file that you want to open :
% filename = 'Group8_Walk9_N_A.mat'; %% as an example
filename = '';

% define the path of the file that you want to open :
% path = 'C:\Users\Onat Inak\MATLAB Drive\DataAcquisition\Samples\Signals\'; %% as an example 
path = '';

% define the objective folder, that you want to save as :
% obj_folder = 'C:\Users\Onat Inak\MATLAB Drive\DataAcquisition\Samples\SlicedSignals\'; %% as an example
obj_folder = '';

file = strcat(path, filename);
obj_file = strcat(obj_folder, filename);

% define the the intervall (in seconds), that you want to have :
time_beginning = [];
time_end = [];

% save the file content to the variable signalContent :
signalContent = open(file);

% call sliceData function :
newSignalContent = sliceData(signalContent, time_beginning, time_end);

time = newSignalContent.time;
data = newSignalContent.data;
    
% Plot the new signal :
subplot(1,2,1)
plot(time, data)
legend('X', 'Y', 'Z');
xlabel('Relative time (s)');
ylabel('Acceleration (m/s^2)');
    
subplot(1,2,2)
x = data(:,1);
y = data(:,2);
z = data(:,3);
mag = sqrt(sum(x.^2 + y.^2 + z.^2, 2));
magNoG = mag - mean(mag);
plot(time,magNoG);
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');

% save the sliced signal to the defined file :
save(obj_file, 'time', 'data')
