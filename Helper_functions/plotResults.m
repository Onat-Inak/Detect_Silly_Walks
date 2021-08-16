% Plot the results and save them to the corresponding folders. Do not
% forget to change the names before you run the optimization algorithm :

function plotResults(results)
    
    % exctract parameters out of the results matrix :
    Accuracy = results(:,1);
    Number_of_inputs = results(:,2);
    Number_of_hidden_layers = results(:,3);
    Number_of_classes = results(:,4);
    Maximum_number_of_epochs = results(:,5);
    Mini_batch_size = results(:,6);
    
    figure1 = figure(1)
    plot(Accuracy, Number_of_hidden_layers, 'b*');
    xlabel('Accuracy in %');
    ylabel('Number of Hidden Layers');
    
    figure2 = figure(2)
    plot(Accuracy, Maximum_number_of_epochs, 'g*');
    xlabel('Accuracy in %');
    ylabel('Maximum Number of Epochs');
    
    figure3 = figure(3)
    plot(Accuracy, Mini_batch_size, 'r*');
    xlabel('Accuracy in %');
    ylabel('Mini Batch Size');
    
    folder_ParameterResults = 'OptimizationResults/ParameterResults';
    filename_ParameterResults = 'LSTM_Network_3_Param_Opt.mat';
%     save(fullfile(fileparts(mfilename('fullpath')), folder_ParameterResults, filename_ParameterResults), 'Accuracy', 'Number_of_inputs', 'Number_of_hidden_layers', 'Number_of_classes', 'Maximum_number_of_epochs', 'Mini_batch_size')
    
    folder_Plots = 'OptimizationResults/Plots';
    
    filename_ParameterResults = 'LSTM_Network_3_Param_Opt_figure_1.png';
%     saveas(figure1, fullfile(fileparts(mfilename('fullpath')), folder_Plots, filename_ParameterResults));
    
    filename_ParameterResults = 'LSTM_Network_3_Param_Opt_figure_2.png';
%     saveas(figure2, fullfile(fileparts(mfilename('fullpath')), folder_Plots, filename_ParameterResults));
    
    filename_ParameterResults = 'LSTM_Network_3_Param_Opt_figure_3.png';
%     saveas(figure3, fullfile(fileparts(mfilename('fullpath')), folder_Plots, filename_ParameterResults));
    
end