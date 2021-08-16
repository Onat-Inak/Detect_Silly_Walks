function YPred = classifyWalkKnn(model, XTest, selidx)
% Group 8 Monty Matlab SoSe2021, Leonie Freisinger, Onat Inak, Adam Misik, Robert Jacumet
%% classifyWalkKnn 
% classifyWalkKnn takes in the trained model, the XTest and the selidx which are the
% relevant features for training and predicts the class of the sequences contained in
% XTest and returns them in the array YPred.
%
% Function takes in:
% model          % 
% XTest          % struct with time series (K x 1 or 1xK double) and collected Data in x,y,z-axis of IMU (K x 3  or 1xK double)
% selidx         % array (nx1) that contains the selected features that where used in training 

%
% Function outputs:
% YPred                        % Zx1 categorial array, filled with either 'Silly walk' or 'Normal walk', depending on matFileName
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % Features only need to be extracted when using kNN. Else predict with XTest!
    XTestFeat = extractFeature(XTest);
    % Select only the features that have been chosen from the NCA
    XTestFeat = XTestFeat(:, selidx);
    predictions = predict(model, XTestFeat);
    % Predicted Classes
    YPred = categorical(predictions);
  
end