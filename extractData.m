function [windowedData, labels] = extractData(matFileContent, matFileName, targetSamplingRateHZ, windowLengthSeconds)
% Group 8 Monty Matlab SoSe2021, Leonie Freisinger, Onat Inak, Adam Misik, Robert Jacumet
% extractData takes in raw content measured by smartphone IMU, resamples it
% at correct sampling rate, cuts it into windows of correct length and 50%
% overlap and returns this data and the label for each window for training,
% testing and prediction purposes
%
% Function takes in:
% matFileContent                % struct with time series (K x 1 or 1xK double) and collected Data in x,y,z-axis of IMU (K x 3  or 1xK double)
% matFileName                   % char array, File name where matFileContent was taken from 
% targetSamplingRateHZ          % scalar, target sampling rate we interpolate our data to [Hz]
% windowLengthSeconds           % scalar, length of parts we cut out of matFileContent [s]
%
% Function outputs:
% windowedData                  % Zx1 cell array, each entry is 3 x targetSamplingRateHZ*windowLengthSeconds double array,
%                                  windowed Data of length windowLengthSeconds and sampling rate targetSamplingRateHZ
% labels                        % Zx1 categorial array, filled with either 'Silly walk' or 'Normal walk', depending on matFileName
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check if matFileContent contains Data in the correct format
% matFileContent.time must be Kx1 and matFileContent.data must be Kx3
if(size(matFileContent.time,2)~=1)
    matFileContent.time=matFileContent.time';
end
if(size(matFileContent.data,2)~=3)
    matFileContent.data=matFileContent.data';
end

%% Check if time vector of measurement is unique
%It can happen with Matlab mobile that entries of matFileContent.time are
%not unique, which is a problem, since interp1 needs unique interpolation points
if numel(matFileContent.time)~=numel(unique(matFileContent.time))
   %we have non unique entries: kick out one of the non unique entries
   [matFileContent.time,idx] = unique(matFileContent.time,'first');
   matFileContent.data=matFileContent.data(idx,:);
end


%% Correct sampling rate
%Define sampling time vector with correct sampling rate targetSamplingRateHZ
time_targetSamplingRate=(0:1/targetSamplingRateHZ:matFileContent.time(end))';

%data_target_samplingRate contains the data interpolated to fit the correct sampling rate
data_target_samplingRate=interp1(matFileContent.time,matFileContent.data,time_targetSamplingRate)';

%% Windowing
%get correct window entry length (even length and rounded towards zero)
windowLengthidx=round(windowLengthSeconds*targetSamplingRateHZ,-1);

%find out max number of entries in windowedData we can get
%logic behind this: end of window 1 is Windowlength(WL), end of second
%window is 1.5WL, end of third is 2WL etc. Find out max number of complete windows n_windowedData
n_pre=floor(length(time_targetSamplingRate)/windowLengthidx*2)/2; %floors to x.5 window lengths  
n_windowedData=2*n_pre-1; % e.g if 3.5*WL is last with <length(timevector) we can cut 6 windows

%create the windows of full length with 50% overlap
windowedData=cell(n_windowedData,1);
for i=1:n_windowedData
    windowedData{i}=data_target_samplingRate(:,...
        (i-1)*windowLengthidx/2+1:...
        (i-1)*windowLengthidx/2+windowLengthidx,:);
end

%% Construct categorial label array from filename
%Check if silly or normal, therefore just check the file name( naming
%convention Group8_walk<#walk>_<S or N>.mat
Walk_cat=cell(n_windowedData,1);
if(matFileName(end-4)=='S') %-4 with normal naming convention, -6 in ours
    [Walk_cat{:}] = deal('Silly walk');   
else
    [Walk_cat{:}] = deal('Normal walk');
end
labels=categorical(Walk_cat);
end