% Different models are trained here, with respect to the TrainingData :
function model = trainSillyWalkSvmClassifier(XTrain, YTrain)
% For this trivial example, no model is required. 

    %% Preprocessing the input data :
    
    YTrain = categorical(YTrain);
    %Extract Features for SVM model
    XTrainFeat = extractFeaturesSVM(XTrain);
    selidx =  [3; 4; 5; 6; 8; 9; 12];
    XTrainFeat = XTrainFeat(:, selidx);
    
    %Select most significant features with the neighborhood component analysis for classification
    %mdl = fscnca(XTrainFeat,YTrain,'Solver','sgd','Verbose',1);
    %tol = 0.5;
    %selidx = find(mdl.FeatureWeights > tol*max(1,max(mdl.FeatureWeights)));
    %XTrainFeat = XTrainFeat(:, selidx);
    %% SVM:
    
    % Specify options regarding Support Vector machine model:
    svm_model = fitcsvm(XTrainFeat,YTrain,'KernelFunction','rbf',...
    'Standardize',true,'BoxConstraint',Inf,'Solver','ISDA');

    model = svm_model;

    save(fullfile(fileparts(mfilename('fullpath')), 'Model.mat'), 'model'); % do not change this line 
end