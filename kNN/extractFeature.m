function [X_feat] = extractFeature(X_seq)
% Group 8 Monty Matlab SoSe2021, Leonie Freisinger, Onat Inak, Adam Misik, Robert Jacumet
%% extractFeature:
%The function extractFeature extract the defined features for the input data
%containing time sequence data. It returns teh extracted features.
% Input:
%X_seq:     % cell array containing n (number of samples) double matrices of size 3xM (3 refering to
%           the number of channels). The double matrices contain time sequence data 
%
% Output:
%X_feat:    %double array of size nxf (n for the number of samples, f for the
%           number of features.

% These Features will be extracted:
% Mean values of each acceleration axis
% Mean value of acceleration magnitude
% RMSE
% Variance of each acceleration axis
% Pearson Correlations of each acceleration axis
% Sum of magnitude under 25 percentile
% Sum of magnitude under 75 percentile
% Energy
% Number of peaks in spectrum above 5Hz
% (Sum of frequency components below 5Hz -->?)


    %% Feature Extraction
    for i=1:length(X_seq)
        % Mean values
        features.meanx(i,1) = mean(X_seq{i}(1,:));
        features.meany(i,1) = mean(X_seq{i}(2,:));
        features.meanz(i,1) = mean(X_seq{i}(3,:));
        features.mag_mean(i,1) = mean(vecnorm(X_seq{i},2,1));

        % Moving Mean Mean
        features.movmeanx(i,1) = mean(movmean((X_seq{i}(1,:)),5));
        features.movmeany(i,1) = mean(movmean((X_seq{i}(2,:)),5));
        features.movmeanz(i,1) = mean(movmean((X_seq{i}(3,:)),5));

            % RMSE
        features.rmsx(i,1) = sqrt(sum(X_seq{i}(1,:).^2)/length(X_seq{i}(1,:))- mean(X_seq{i}(1,:)));
        features.rmsy(i,1) = sqrt(sum(X_seq{i}(2,:).^2)/length(X_seq{i}(2,:))- mean(X_seq{i}(2,:)));
        features.rmsz(i,1) = sqrt(sum(X_seq{i}(3,:).^2)/length(X_seq{i}(3,:))- mean(X_seq{i}(3,:)));

        %Variance 
        features.var(i,1) = var(vecnorm(X_seq{i},2,1));

        %Pearson Correlations between axes
        corr_12 = corrcoef(X_seq{i}(1,:),X_seq{i}(2,:));
        features.corr_12(i,1) = corr_12(1,2);

        corr_13 = corrcoef(X_seq{i}(1,:),X_seq{i}(3,:));
        features.corr_13(i,1) = corr_13(1,2);

        corr_23 = corrcoef(X_seq{i}(2,:),X_seq{i}(3,:));
        features.corr_23(i,1) = corr_23(1,2);  

        % Magnitude 
        features.mag_perc25(i,1) = prctile(vecnorm(X_seq{i},2,1),25);
        features.mag_perc75(i,1) = prctile(vecnorm(X_seq{i},2,1),75);

        % FFT parameters
        L =length(X_seq{i}(1,:));
        Fs = 100;
        Ts = 1/Fs;
        t =(0:L-1)*Ts;
        f_full=linspace(0,Fs,L);
        f=Fs*(0:(L/2))/L;

        % Define the spectrum
        spectrum  = fft(vecnorm(X_seq{i},2,1))/L;

        % Energy
        features.energy(i,1) = sum(abs(spectrum).^2/L);
        [ampl,freq] = findpeaks(abs(spectrum),f_full);

        % Number of peaks in spectrum below 5Hz
        features.nr_peak_abv5(i,1) = length(freq(freq>5));

        i=i+1;
    end 

    %% Export Features
    % X_feat contrains the different feature in the first dimension and the samples in
    % the second dimension. Select the features that shall be regarded. 

    X_feat = [...
        features.meanx, features.meany, features.meanz, ...
        features.rmsx, features.rmsy, features.rmsz, ...
        features.corr_12, features.corr_13, features.corr_23, ... 
        features.energy, features.nr_peak_abv5, ...
        features.mag_perc25, features.mag_perc75... 
        features.var ...
        features.movmeanx, features.movmeany, features.movmeanz, ...
        ];
