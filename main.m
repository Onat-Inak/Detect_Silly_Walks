%% Main for Monty Matlab Project in SS21
% Leonie Freisinger, Adam Misik, Onat Inak, Robert Jacumet
% Monty Matlab Project SoSe21, Group 8

% Goal of the Project: Detect if a user walked "Normal" or "Silly".
% Therefore the user can select acceleration data that is measured by the
% IMU of a standard smartphone. First Data is preprocessed using the
% function extractData, explained in the next section. Afterwards an LSTM
% is trained and the trained model is returned by the function
% trainSillyWalkClassifier. Afterwards the function classifyWalk is
% used to predict which class a walk belongs to. 

%Functions used are (Detailed explanations can be found in the respective .m files):
% [windowedData, labels] = extractData(matFileContent, matFileName, targetSamplingRateHZ, windowLengthSeconds)
% model = trainSillyWalkClassifier(XTrain, YTrain)
% YPred = classifyWalk(model, XTest)


clear 
close all
clc

addpath(fullfile(fileparts(mfilename('fullpath')), 'Helper_functions'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
targetSamplingRateHZ=50;    %specify the target samlping rate of the walking-sequences to be classified [Hz]
windowLengthSeconds=3.4;    %Specify length of walking-sequences to be classified [s]

%% Data Extraction
% Call the function extractData with all the the Data given in the folders
% "TrainingData" and "TestData". All Data stored in these folders will be
% resampled at sampling rate targetSamplingRateHZ and cut to windows of
% length windowLengthSeconds with 50% overlap, before beeing stored in the
% cell arrays XTrain, YTrain, XTest, YTest. 

%Takes in targetSamplingRateHZ, windowLengthSeconds, Training and Test Data in Folders "TrainingData" and "TestData", respectively
%Returns XTrain, YTrain, XTest, YTest (cell arrays with #slices x 1, where
%each entry is a  x targetSamplingRateHZ*windowLengthSeconds double array)

% TRAINING DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TrainFileNames={dir(fullfile('TrainingData','*.mat')).name}; %cell array of all training data file names

% Iterate over all TrainData Files to get XTrain/ YTrain, the cell arrays
% containing the train data of correct sampling rate and length
XTrain={};
YTrain={};
for i=1:length(TrainFileNames)
    matFileContent=load(fullfile('TrainingData',TrainFileNames{i}));
    %Call extractData
    [windowedData, labels] = extractData(matFileContent, TrainFileNames{i}, targetSamplingRateHZ, windowLengthSeconds);
    XTrain=[XTrain;windowedData];
    YTrain=[YTrain;labels];
end

% Test DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TestFileNames={dir(fullfile('TestData','*.mat')).name}; %cell array of all Test data file names

% Iterate over all TrainData Files to get XTrain/ YTrain, the cell arrays
% containing the train data of correct sampling rate and length
XTest={};
YTest={};
for i=1:length(TestFileNames)
    matFileContent=load(fullfile('TestData',TestFileNames{i}));
    %has to be transposed to make up for different definition in our functions and the project specification
    %Call extractData
    [windowedData, labels] = extractData(matFileContent, TestFileNames{i}, targetSamplingRateHZ, windowLengthSeconds);
    XTest=[XTest;windowedData];
    YTest=[YTest;labels];
end

%% Optimize the parameters for LSTM network :

% In this function the hyperparameter optimization is done and thus the
% optimal parameters for the LSTM network are determined. In the
% hyperparameter optimization, all the possible values for all the
% parameters are chosen individually. Then the Trainingdata are splitted
% into TrainSplit and ValidationData with the function splitTrainData.m.
% This functions randomly splits the data in every iteration step.
% TrainSplit is used to train the LSTM model with the corresponding
% parameters regarding the current iteration and the trained model is validated 
% with the ValidationData. Then the model with the best accuracy is chosen
% and is then tested with the TestData at the end :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You can uncomment the line below, if you want to run the optimization and 
% find the optimal parameters. You must also uncomment the line 8 in the
% function splitTrainData.m from the folder Helper_functions :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [optimal_LSTM_parameters, results] = optimize_LSTM_network(XTrain, YTrain);

% plot and save the results, which are obtained from the hyperparameter
% optimization. Do not forget to change the names of the before starting
% the optimization :

% plotResults(results);

% Optimization must be done just once. The optimal parameters are then
% declared here and then the optimization line is commented out :
% optimal_LSTM_parameters.number_of_inputs = 3;
% optimal_LSTM_parameters.number_of_hidden_layers = 60;
% optimal_LSTM_parameters.number_of_classes = 2;
% optimal_LSTM_parameters.maximum_number_of_epochs = 45;
% optimal_LSTM_parameters.mini_batch_size = 6;

%% Training of the Model
%Call the function trainSillyWalkClassifier with the Training Data, to get
%the trained classification model for recognizing styles of walking. 

%The training can take several minutes!
LSTM_training = tic;
model = trainSillyWalkClassifier(XTrain, YTrain);
LSTM_train_duration = toc(LSTM_training)

%Optionally call the function trainSillyWalkClassifierKnn with the Training Data, to get
%an alternative classification model and the relevant feature indices based on a Knn approach.
% [model,selidx] = trainSillyWalkClassifierKnn(XTrain, YTrain);

%% Classification for the Walk
%Call the function classifyWalk with the Test Data, to get
%predictions on the walking style based on the previously trained model
tic
predictions = classifyWalk(model, XTest);

accuracy = (sum(predictions == YTest) / numel(YTest)) * 100;
prediction_duration = toc;
%Optionally call the function classifyWalkKnn with the Test Data, to get the
%predictions based on the alternative Knn model.
% tic
% predictions = classifyWalkKnn(model, XTest, selidx);
% 
% accuracy = (sum(predictions == YTest) / numel(YTest)) * 100;
% prediction_duration = toc;    
%print the confusion matrix    
confusionchart(YTest, predictions);



