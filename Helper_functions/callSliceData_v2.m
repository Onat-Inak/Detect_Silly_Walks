
% This is a call function for the function sliceData, which is implemented
% to slice the pre-defined beginning and end of the measurement data in
% order to obtain a data without much noise regarding the phone movement in
% the beginning and at the end of each measurement :

clear 
clc

% define the path of the file that you want to open :
folder = '/Users/adammisik/Documents/01_TUM/02_Master/02_Wahlmodule/Monty_Matlab/01_Coding/Final_Project/Template_Project/final/New_Data';

FileNames={dir(fullfile(folder,'*.mat')).name};

obj_folder = '/Users/adammisik/Documents/01_TUM/02_Master/02_Wahlmodule/Monty_Matlab/01_Coding/Final_Project/Template_Project/final/New_Data_v2';

for i=1:length(FileNames)
    try
        filename = FileNames{i}; 
        obj_file = obj_folder + "/" + filename;
        % define the the intervall, that you want to have :
        time_beginning = 3;

        % save the file content to the variable signalContent :
        signalContent = open(folder+"/"+filename);
        time_end = signalContent.time(end);

        % call sliceData function :
        newSignalContent = sliceData_v2(signalContent, obj_file, time_beginning, time_end)
    catch 
        display("Dim error at: %s", string(i))
        continue
    end
end
