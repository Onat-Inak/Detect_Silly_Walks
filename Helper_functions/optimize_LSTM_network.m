
% optimization is done for the parameters num_hid_layers, max_num_epoch
% and mini_batch_sz and the results are saved in different arrays. Then
% the parameters, which gave the best accuracy result are given to the
% model, to test the accuracy with the ValidationData.

function [optimal_LSTM_parameters, results] = optimize_LSTM_network(XTrain, YTrain)

    number_of_inputs = 3;
    number_of_classes = 2;
    
    iter = 1
    
    for num_hid_layers = 60 : 10 : 60
        for max_num_epoch = 45 : 10 : 45
            for mini_batch_sz = 200 : 10 : 220
                
                parameters.number_of_inputs = number_of_inputs;
                parameters.number_of_hidden_layers = num_hid_layers;
                parameters.number_of_classes = number_of_classes;
                parameters.maximum_number_of_epochs = max_num_epoch;
                parameters.mini_batch_size = mini_batch_sz;
                
                % Split the Trainingsdata into training and validation
                % data:
                [XTrainSplit, YTrainSplit, XValidation, YValidation] = splitTrainData(XTrain, YTrain);
                
                % Specify the network layers and options :
                [layers, options] = specify_LSTM_network(parameters, XValidation, YValidation);
    
                % Train the LSTM Network :
                LSTM_network = trainNetwork(XTrainSplit, YTrainSplit, layers, options);
                
%               LSTM_network = trainSillyWalkClassifier(XTrain, YTrain, parameters);
                predictions = classifyWalk(LSTM_network, XValidation);
                accuracy = (sum(predictions == YValidation) / numel(YValidation)) * 100
                
                accuracy_arr(iter) = accuracy;
                number_of_inputs_arr(iter) = number_of_inputs;
                number_of_hidden_layers_arr(iter) = num_hid_layers;
                number_of_classes_arr(iter) =  number_of_classes;
                maximum_number_of_epochs_arr(iter) = max_num_epoch;
                mini_batch_size_arr(iter) = mini_batch_sz;
                
                iter = iter + 1
                
            end
        end
    end

    results = zeros(length(accuracy_arr), 6);
    results(:,1) = accuracy_arr;
    results(:,2) = number_of_inputs_arr;
    results(:,3) = number_of_hidden_layers_arr;
    results(:,4) = number_of_classes_arr;
    results(:,5) = maximum_number_of_epochs_arr;
    results(:,6) = mini_batch_size_arr;
    
    [max_accuracy, index] = max(accuracy_arr)
    optimal_LSTM_parameters.number_of_inputs = number_of_inputs_arr(index);
    optimal_LSTM_parameters.number_of_hidden_layers = number_of_hidden_layers_arr(index);
    optimal_LSTM_parameters.number_of_classes = number_of_classes_arr(index);
    optimal_LSTM_parameters.maximum_number_of_epochs = maximum_number_of_epochs_arr(index);
    optimal_LSTM_parameters.mini_batch_size = mini_batch_size_arr(index);
    
end



















