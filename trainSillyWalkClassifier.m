% This functions gets the parameters needed for the training of the LSTM
% network and specifies its layers and options with the function
% specify_LSTM_network.m. The data is splitted into Train and Validation
% sets with the function splitTrainData.m. The Validation set is actually  
% thought for finding out the optimal parameters for the model (do not forget
% to uncomment the line 8 from the function splitTrainData.m if you want to 
% run the optimization from the main function), but it can
% be also used to determine, how the model is trained with a MATLAB intern
% visualization toolbox. For that you have to enable the corresponding
% option in the option section of the function specify_LSTM_network.m. The
% model is then trained with the Train set and the trained model is saved
% as Model.mat file, which we will use in the GUI.

function model = trainSillyWalkClassifier(XTrain, YTrain)
    %% Preprocessing the input data :
    
    YTrain = categorical(YTrain);
    
    %Split into Validation and Train Data :
    [XTrainSplit, YTrainSplit, XValidation, YValidation] = splitTrainData(XTrain, YTrain);
    
    %% LSTM Network :
    %optimal parameters that we found, these can be exchanged if you want
    %to try other parameters
    optimal_LSTM_parameters.number_of_inputs = 3;
    optimal_LSTM_parameters.number_of_hidden_layers = 60;
    optimal_LSTM_parameters.number_of_classes = 2;
    optimal_LSTM_parameters.maximum_number_of_epochs = 45;
    optimal_LSTM_parameters.mini_batch_size = 6;
    
    % Specify layers and options regarding optimal LSTM parameters :
    [layers, options] = specify_LSTM_network(optimal_LSTM_parameters, XValidation, YValidation);
    
    % LSTM network is trained :
    LSTM_network = trainNetwork(XTrainSplit, YTrainSplit, layers, options);

    model = LSTM_network;

    % model is saved as Model.mat file :
    save(fullfile(fileparts(mfilename('fullpath')), 'Model.mat'), 'model'); % do not change this line
    
end