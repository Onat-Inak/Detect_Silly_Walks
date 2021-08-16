function [model, selidx] = trainSillyWalkClassifierKnn(XTrain, YTrain)
%Group 8 Monty Matlab SoSe2021, Leonie Freisinger, Onat Inak, Adam Misik, Robert Jacumet
%% trainSillyWalkClassifier:
%The function trainSillyWalkClassifier is training the model based on and Knn approach to predict the two
%classes based on the training data and training labels. In this function NCA can be
%applied to select the relevant features for the Knn model. The function returns the
%trained model and the selected relevant features. 

% Input:
%XTrain:        %cell array containing n (number of samples) double matrices of size 3xM (3 refering to
%               the number of channels) 
%YTrain:        %array of type categorical containing the labels of each sample
%
% Output:
%model:         %the trained classification model
    
    %% Feature Extraction for knn:
    % The relevant features from the training data are extracted by calling the
    % extractFeature function.
    XTrainFeat = extractFeature(XTrain);
    
    % set training labels to Categorical
    YTrain = categorical(YTrain);

    %% Training of the Model
    %Select most significant features with the neighborhood component analysis for
    %classification by appling Nearest Neighborhood Component Analysis
    mdl = fscnca(XTrainFeat,YTrain,'Solver','sgd','Verbose',1, 'Standardize',true);
    save(fullfile(fileparts(mfilename('fullpath')), 'NCA_KNN.mat'), 'mdl'); % do not change this line 
    % Select the threshold for the most significant features from the NCA and extract
    % those features.
    tol = 0.5;
    selidx = find(mdl.FeatureWeights > tol*max(1,max(mdl.FeatureWeights)));
    %Set manually set the selidx after checking the results from the NCA. If you want
    %to run the NCA, you can comment the section below. 
    selidx =  [3; 4; 5; 6; 8; 9; 12];
    XTrainFeat = XTrainFeat(:, selidx);
    
    % Define the number of neighbors.
    k = 1;

    % Train the model with specified properties.
    knn_model = fitcknn(XTrainFeat , YTrain , ...
        'NumNeighbors',k, ...
         'Standardize',1);      
          
    % Export the model.
    model = knn_model;
    save(fullfile(fileparts(mfilename('fullpath')), '..', 'Model.mat'), 'model');% do not change this line
end