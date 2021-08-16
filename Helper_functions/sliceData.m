% slice the corresponding data with respect to the defined beginning and
% end time :

function newSignalContent = sliceData(signalContent, time_beginning, time_end)

    data = signalContent.data;
    time = signalContent.time;
    
    [numSamples, ~] = size(data);
    sample_rate = round(numSamples / time(end));
    
    newSignalContent.data = [];
    newSignalContent.time = [];

    startingSample = round(time_beginning * sample_rate);
    endingSample = round(time_end * sample_rate);
    window = startingSample : endingSample;
    
    newSignalContent.data = data(window, :);
    newSignalContent.time = (window - startingSample)' ./ sample_rate;
    
end