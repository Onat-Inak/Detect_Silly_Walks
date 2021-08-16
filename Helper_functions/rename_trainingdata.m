%Group 8 Monty Matlab SS2021, Leonie Freisinger, Onat Inak, Adam Misik, Robert Jacumet
%Helper function that is additionally implemented due to the extra naming convention of group 8

%changes filenames of training data in convention of group8 to the naming convention specified for the MM project

%simply put this script in the folder containing the training samples with group8 naming convention
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If the last Walk in the common pool has Nr X, choose shift_Walk_idx=X
shift_Walk_idx=0;

%% Create new Folder for renamed Data
%check if Folder "Renamed_Traing_Data" exists, if not create it and copy
%data with old naming convention there
if ~exist("Renamed_Traing_Data", 'dir')
       mkdir("Renamed_Traing_Data")
       copyfile *.mat Renamed_Traing_Data
       cd Renamed_Traing_Data
end


%% Rename Training Data (Cnvention Group8--> Project Convention
% Get all training files data with the
% naming convention we made for group 8
files = dir('*.mat');
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the .mat)
    [~, f] = fileparts(files(id).name);
     %f is of from 'Group8_Walk<#walk>_<S/N>_<cat>'
     Walk_cat=f(end-2); %gives either S or N
         
     %find k in filename since it is right before the walknumber
     pos_of_k_from_end=5; %at least 5 from the end
     while(f(end-pos_of_k_from_end)~='k')
         pos_of_k_from_end=pos_of_k_from_end+1;
     end
     prev_Walk_number=f(end-pos_of_k_from_end+1:end-4); % gives walk number the walk had before
     f_cut=f(1:end-pos_of_k_from_end);
     
     %construct new name
     newWalkNr=str2double(prev_Walk_number)+shift_Walk_idx;
     New_Name= strcat(f_cut,string(newWalkNr),"_",Walk_cat,".mat");
     
     movefile(files(id).name,New_Name);
      
 end