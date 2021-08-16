
% This is a trivial example for a classifier. It classifies any input as a
% normal walk.

function YPred = classifyWalk(model, XTest)

    %predictions = classify(model, XTest);
    XTestFeat = extractFeaturesSVM(XTest);
    selidx =  [3; 4; 5; 6; 8; 9; 12];
    XTestFeat = XTestFeat(:, selidx);
    predictions = predict(model,XTestFeat)
    YPred = categorical(predictions);
    
%     YPred = categorical(repmat({'Normal walk'}, size(XTest)));

end