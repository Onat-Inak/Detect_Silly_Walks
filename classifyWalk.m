% This functions classifies the walk by giving the TestData into the
% trained LSTM model and the predictions are saved as a categorical array :

function YPred = classifyWalk(model, XTest)

    predictions = classify(model, XTest);
    YPred = categorical(predictions);
    
%     YPred = categorical(repmat({'Normal walk'}, size(XTest)));

end