
function [XTrainSplit, YTrainSplit, XValidation, YValidation] = splitTrainData(XTrain, YTrain)

    % Split into Validation and Train Data :
    percent_ValData = 0; % give the percentage of Data you want to have as Validation Data
    
    % If you want to run optimize_LSTM_network.m function, then set :
%     percent_ValData = 10
    
    XTrainSplit = XTrain;
    YTrainSplit = YTrain;
    
    idx = randperm(length(XTrainSplit),round(length(XTrainSplit)*percent_ValData/100));
    XValidation = XTrainSplit(idx);
    XTrainSplit(idx) = [];
    YValidation = YTrainSplit(idx);
    YTrainSplit(idx) = [];
    
end