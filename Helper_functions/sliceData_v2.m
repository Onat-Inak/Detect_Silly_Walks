% slice the corresponding data with respect to the defined beginning and
% end time :

function newSignalContent = sliceData(signalContent, obj_file, time_beginning, time_end)

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
    
    time = newSignalContent.time;
    data = newSignalContent.data;
    
    subplot(1,2,1)
    plot(time, data)
    legend('X', 'Y', 'Z');
    xlabel('Relative time (s)');
    ylabel('Acceleration (m/s^2)');
    
    subplot(1,2,2)
    x = data(:,1);
    y = data(:,2);
    z = data(:,3);
    mag = sqrt(sum(x.^2 + y.^2 + z.^2, 2));
    magNoG = mag - mean(mag);
    plot(time,magNoG);
    xlabel('Time (s)');
    ylabel('Acceleration (m/s^2)');

    % save the file :
    save(obj_file, 'time', 'data')
    
end