TrainFileNames={dir('*.mat').name}; %cell array of all training data file names

for i=1:length(TrainFileNames)
    matFileContent=load(TrainFileNames{i});
    matFileContent.time=matFileContent.time';
     matFileContent.data=matFileContent.data';
    data=matFileContent.data;
    time=matFileContent.time;
    save(TrainFileNames{i},'data','time');
end