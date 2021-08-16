% In this function the layers and the corresponding options of the LSTM
% network are determined. You can add different options for visualization
% purposes :

function [layers, options] = specify_LSTM_network(parameters, XValidation, YValidation)
        
    number_of_inputs = parameters.number_of_inputs;
    number_of_hidden_layers = parameters.number_of_hidden_layers;
    number_of_classes = parameters.number_of_classes;
    maximum_number_of_epochs = parameters.maximum_number_of_epochs;
    mini_batch_size = parameters.mini_batch_size;

    layers = [ ...
            sequenceInputLayer(number_of_inputs)
            lstmLayer(number_of_hidden_layers, 'OutputMode', 'last')
            dropoutLayer
            reluLayer
            fullyConnectedLayer(number_of_classes)
            softmaxLayer
            classificationLayer];
        
    % create options for the LSTM network:
    options = trainingOptions('adam', ...
        'MiniBatchSize', mini_batch_size, ...
        'MaxEpochs', maximum_number_of_epochs, ...
        'Verbose', false, ...
        'GradientThreshold', 1);

end