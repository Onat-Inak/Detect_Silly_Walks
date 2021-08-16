%Group 8 Monty Matlab SoS2e021, Leonie Freisinger, Onat Inak, Adam Misik, Robert Jacumet
%Helper function that is additionally implemented due to the extra naming convention of group 8
%This class implements the GUI figure creation and pulls signal data from the Data
%handle class. It contains features like data upload, acceleration signal
%visualization, and walk classification using the uploaded model. Based on
%the predicted walk class, a GIF will be generated.
classdef GUI_view_final < handle
    %Initialize GUI properties
    properties (Access = public)
        hp0
        hp1
        hp2
        hp3
        hp4
        Gui_fig
        Axis
        Table
        ImportButton1
        ImportButton2
        DropdownFolder
        ModelImportButton
        ClassifyButton
        DisplayButtons
        DisplayButton1
        DisplayButton2
        ConfusionMatrix
        WelcomeMSG
        TUM_Logo
        Monty_Logo
        SampleRate = 50;
        WindowLength = 3.4;
        Listener  
        filename
        fileNames
        XTest
        accuracy
        decision
        YPred
        YTest
        model
        classification_runtime
        FolderFlag
        folderName
        GIF
        ResultSummary
        ClearButton
    end   
    properties (Access = public, SetObservable, AbortSet)
        %Initialize class handle for data
        GUI_data
    end   
    %Define GUI methods
    methods (Access = public)
        %Constructor to create GUI figure and add Logo's
        function obj = GUI_view_final()
            %Add required paths to current path
%             current_folder = pwd;
%             temp_folders = split(current_folder, "\");
%             new_path = join(temp_folders(1 : end - 1), "\");
%             addpath(new_path{:});
            %Create GUI layout, add Logos in corners of GUI
            obj.createLayout();
            set(obj.Gui_fig, 'Visible', 'On');
            imshow("GUI/TUM_LOGO.png",'Parent',obj.TUM_Logo);
            imshow("GUI/Monty_Logo.jpg",'Parent',obj.Monty_Logo);
            %Construct Data storage class, and add Listener variable for
            %updates
            obj.GUI_data = GUI_data(); 
            obj.Listener = addlistener(obj.GUI_data, 'DataMatrix', 'PostSet', @obj.cbUpdate);
        end 
        
        %Method to import one walk from a given folder 
        function cbImport(obj, ~, ~)
            fileName = uigetfile('*.mat');
            
            %Replace _ string with -, so it can be used in a figure
            obj.filename = replace(fileName,'_','-');
            obj.GUI_data.importData(fileName);
            
            % matFileContent.time must be Kx1 and matFileContent.data must be Kx3
            if(size(obj.GUI_data.TimeVector,2)~=1)
                 obj.GUI_data.TimeVector = obj.GUI_data.TimeVector.';
            end
            if(size(obj.GUI_data.DataMatrix,2)~=3)
                obj.GUI_data.DataMatrix = obj.GUI_data.DataMatrix.';
            end

            
            %Update table and axis data, display GUI elements for viz and
            %classification
            obj.cbUpdate()
            obj.FolderFlag = 0;
            f = msgbox("Data loaded!")
            obj.hp2.Visible = 'On';
            obj.ImportButton2.Visible = 'Off';
            obj.DropdownFolder.Visible = 'Off';

        end
        
        %Method for the import of a folder with walks
        function folderImport(obj, ~, ~)
            obj.folderName = uigetdir();
            %Replace _ string with -, so it can be used in a figure
            obj.fileNames={dir(fullfile(obj.folderName,'*.mat')).name};
            obj.filename = obj.fileNames{randi([1,length(obj.fileNames)],1,1)};
            
            %Import signal data and update axis with a random signal
            %provided from the folder
            obj.GUI_data.importData(obj.filename);
            if(size(obj.GUI_data.TimeVector,2)~=1)
                 obj.GUI_data.TimeVector = obj.GUI_data.TimeVector.';
            end
            if(size(obj.GUI_data.DataMatrix,2)~=3)
                obj.GUI_data.DataMatrix = obj.GUI_data.DataMatrix.';
            end
            obj.filename = replace(obj.filename,'_','-');
            cla(obj.Axis)
            obj.cbUpdate()
            obj.FolderFlag = 1;
            obj.DropdownFolder.String = obj.fileNames;
            f = msgbox("Folder loaded!")
            obj.hp2.Visible = 'On';
            obj.ImportButton1.Visible = 'Off';
        end
        
        %Method that plots the signal selected from the pop-up menu
        function get_walk(obj, ~, ~)
            obj.filename = obj.fileNames{get(obj.DropdownFolder,'Value')};
            obj.GUI_data.importData(obj.filename); 
            if(size(obj.GUI_data.TimeVector,2)~=1)
                 obj.GUI_data.TimeVector = obj.GUI_data.TimeVector.';
            end
            if(size(obj.GUI_data.DataMatrix,2)~=3)
                obj.GUI_data.DataMatrix = obj.GUI_data.DataMatrix.';
            end
            obj.filename = replace(obj.filename,'_','-');
            cla(obj.Axis)
            obj.cbUpdate()
        end
        
        %Method for the import of a classification model
        function modelImport(obj,~,~)
            model_filename = uigetfile('*.mat');
            model = load(model_filename);
            obj.model = model.model;
            f = msgbox("Model loaded!")
            obj.hp3.Visible = 'On';
        end   
        
        %Method for editing the table data
        function cbEdit(obj, ~, ~)
            obj.GUI_data.DataMatrix = obj.Table.Data;
        end
        
        %Method for updating the table data and doing a visualisation of
        %the selected signal
        function cbUpdate(obj, ~, ~)
            obj.Table.Data = horzcat(obj.GUI_data.TimeVector, obj.GUI_data.DataMatrix);
            %Plot all three signal axes
            plot(obj.GUI_data.TimeVector, obj.Table.Data(:,2),'DisplayName','X','Parent',obj.Axis);
            hold on
            plot(obj.GUI_data.TimeVector, obj.Table.Data(:,3),'DisplayName','Y','Parent',obj.Axis);
            hold on 
            plot(obj.GUI_data.TimeVector, obj.Table.Data(:,4),'DisplayName','Z','Parent',obj.Axis);
            hold off
            legend(obj.Axis,'Location','northwest')
            xlabel(obj.Axis,'Time [s]');
            ylabel(obj.Axis,'Acceleration [m/s^2]');
            title(obj.Axis,obj.filename(1:end-4));
            grid(obj.Axis,'on');
        end
        %Method for the classification pipeline
        function classification(obj,~,~,~) 
            tic
            %Implement classification pipeline for a walk
            if(obj.FolderFlag == 0)
                obj.XTest={};
                obj.YTest={};
                obj.extractData()
                obj.classifyWalk()
                obj.classification_runtime = toc;
                obj.evaluate()
            %Implement classification pipeline for a folder with walks    
            else
                obj.XTest={};
                obj.YTest={};
                obj.extractData_f()
                obj.classifyWalk()
                obj.classification_runtime = toc;
                obj.evaluate_f()             
            end
        end
        %Method that takes raw signal data, resamples it at a given sample
        %rate, and cuts it to windows specified by the window length
        %parameter
        function extractData(obj, ~, ~)
            %Define sampling time vector with correct sampling rate targetSamplingRateHZ
            time_targetSamplingRate = 0:1/obj.SampleRate:obj.GUI_data.TimeVector(end);
            %data_target_samplingRate contains the data interpolated to fit the correct sampling rate
            data_target_samplingRate=interp1(obj.GUI_data.TimeVector,obj.GUI_data.DataMatrix,time_targetSamplingRate);
            %get correct window entry length (even length and rounded towards zero)
            windowLengthidx=round(obj.WindowLength*obj.SampleRate,-1);
            %find out max number of entries in windowedData we can get
            n_pre=floor(length(time_targetSamplingRate)/windowLengthidx*2)/2; 
            n_windowedData=2*n_pre-1;
            %create the windows of full length with 50% overlap
            windowedData=cell(1,n_windowedData);
            for i=1:n_windowedData
                windowedData{i}=data_target_samplingRate(...
                       (i-1)*windowLengthidx/2+1:...
                       (i-1)*windowLengthidx/2+windowLengthidx,:).';
            end
            %Set windowed signal data to GUI and visualize
            obj.GUI_data.DataMatrix = data_target_samplingRate;
            obj.GUI_data.TimeVector = time_targetSamplingRate.';
            %obj.cbUpdate()
            
            %Check if silly or normal, therefore just check the file name
            %and set label 
            Walk_cat=cell(n_windowedData,1);
            if(obj.filename(end-4)=='S') 
                [Walk_cat{:}] = deal('Silly walk');   
            else
                [Walk_cat{:}] = deal('Normal walk');
            end
            labels = categorical(Walk_cat);
            obj.XTest=[obj.XTest;windowedData];
            obj.YTest=[obj.YTest;labels];
        end    
        
       %Method that implements extractData iteratively on a whole folder of
       %walks
        function extractData_f(obj,~,~)
            for i=1:length(obj.fileNames)
                matFileContent=load(fullfile(obj.folderName,obj.fileNames{i}));
                %Call extractData
                [windowedData, labels] = extractData(matFileContent, obj.fileNames{i}, obj.SampleRate, obj.WindowLength);
                obj.XTest=[obj.XTest;windowedData];
                obj.YTest=[obj.YTest;labels];
            end
        end   
        
        %Method that uses the loaded model to classify a walk
        function classifyWalk(obj,~)
            predictions = classify(obj.model, obj.XTest);
            obj.YPred = categorical(predictions);
        end   
        
        %Method that evaluates the prediction results on one walk
        function evaluate(obj, ~)
            %Calculate accuracy, check what sort of walk by taking the
            %majority of predictions for the windowed signal, calculate
            %ConfusionMatrix and visualize 
            obj.accuracy = (sum(obj.YPred == obj.YTest) / numel(obj.YTest)) * 100;
            obj.decision = mode(obj.YPred);
            obj.ConfusionMatrix = uiaxes('Units','normalized',...
                'Position', [0.35 0.05 0.3 0.99],...
                'Parent', obj.hp3,'Visible','Off');         
            confusionchart(obj.YTest, obj.YPred,'Parent',obj.hp3); 
            obj.ResultSummary.String =  "This is a " + char(obj.decision) + ", with "+num2str(obj.accuracy)+"% accuracy! Classification runtime: " +num2str(obj.classification_runtime) + "s";
            obj.ResultSummary.Visible = 'On';
            obj.ClearButton.Visible = 'On';
            %Creates a GIF based on the decision on what sort of walk is
            %underlying
            if obj.decision=="Silly walk"
                obj.gifPlayerGUI("GUI/Silly.gif")
            else
                obj.gifPlayerGUI("GUI/Normal.gif")
            end
        end 
        
        %Method that evaluates the prediction results on a folder with
        %walks
        function evaluate_f(obj, ~)
            %Calculate accuracy, check what sort of walk by taking the
            %majority of predictions for the windowed signal, calculate
            %ConfusionMatrix and visualize
            obj.accuracy = (sum(obj.YPred == obj.YTest) / numel(obj.YTest)) * 100;
            obj.decision = mode(obj.YPred);
            obj.ConfusionMatrix = uiaxes('Units','normalized',...
                'Position', [0.35 0.05 0.3 0.99],...
                'Parent', obj.hp3,'Visible','Off');
            confusionchart(obj.YTest, obj.YPred,'Parent',obj.hp3);
            obj.ResultSummary.String = "Overall accuracy: "+num2str(obj.accuracy) + "%! Classification runtime: " +num2str(obj.classification_runtime) + "s";
            obj.ResultSummary.Visible = 'On';
            obj.ClearButton.Visible = 'On';
            %Creates a GIF based on the decision on what sort of walk is
            %underlying
            if obj.decision=="Silly walk"
                obj.gifPlayerGUI("Silly.gif")
            else
                obj.gifPlayerGUI("Normal.gif")
            end
        end
  
        %Method that calculates the signal magnitude
        function magfct(obj, ~, ~)
            legend(obj.Axis,'off')
            x = obj.GUI_data.DataMatrix(:,1);
            y = obj.GUI_data.DataMatrix(:,2);
            z = obj.GUI_data.DataMatrix(:,3);
            %Calculate magnitude, then subtract mean to have zero mean form
            mag = sqrt(sum(x.^2 + y.^2 + z.^2, 2));
            magNoG = mag - mean(mag);
            %Plot magnitude
            plot(obj.Axis, obj.GUI_data.TimeVector, magNoG)
            xlabel(obj.Axis,'Time in [s]');
            ylabel(obj.Axis,'Zero-Mean Acceleration magnitude in [m/s^2]');
            grid(obj.Axis,'on')           
        end
        
        %Method that generates a GIF player
        function gifPlayerGUI(obj, fname)
            %Read all GIF frames
            info = imfinfo(fname, 'gif');
            delay = ( info(1).DelayTime ) / 100;
            [img,map] = imread(fname, 'gif', 'frames','all');
            [imgH,imgW,~,numFrames] = size(img);

            %Prepare GUI, and show first frame
            hFig = figure();
            movegui(hFig,'center')
            hAx = axes('Parent',hFig, ...
            'Units','pixels', 'Position',[1 1 imgW imgH]);
            hImg = imshow(img(:,:,:,1), map, 'Parent',hAx);
            %Set title of GIF based on decision on sort of walk
            if obj.decision == "Silly walk"
                if obj.FolderFlag
                   title("These are mostly Silly walks!")
                else
                    title("This is a Silly walk!")
                end
            else
                if obj.FolderFlag
                    title("These are mostly Normal walks!")
                else
                    title("This is a Normal walk!")
                end
            end

            pause(delay)
            truesize(hFig)
            %Loop over frames continuously
            counter = 1;
            while ishandle(hImg)
                %Increment counter circularly
                counter = rem(counter, numFrames) + 1;

                %Update frame
                set(hImg, 'CData',img(:,:,:,counter))

                %Pause for the specified delay
                pause(delay)
            end
 
        end
        
        %Method that clears all GUI elements
        function clear_data(obj, ~, ~)
              clear
              GUI_view_final()     
        end
        %Method that sets the GUI layout
        function createLayout(obj)
                % GUI figure initialisation
                screen_sz = get(0,'ScreenSize');
                obj.Gui_fig = figure('Name', 'Final Project',...
                    'Position', [300 200 screen_sz(3) screen_sz(4)],...
                    'NumberTitle', 'off',...
                    'toolbar', 'none',...
                    'Menubar', 'none');
                %Welcome msg panel
                obj.hp0 = uipanel('Position', [0.05 0.8 0.9 0.15],...
                    'Parent', obj.Gui_fig);
                textmsg = 'Monty.AI - Check how you walk!';
                %Set Axes for logos and welcome msg 	
                obj.TUM_Logo = uiaxes('Units', 'normalized',...
                    'Position', [0.1 0.05 0.3 0.99],...
                    'Parent', obj.hp0);
                obj.WelcomeMSG = uicontrol('Style','text',...
                    'String',textmsg,...
                    'FontWeight','bold',...
                    'FontSize',12,...
                    'Units','normalized',...
                    'Position',[0.4 0.4 0.2 0.2],...
                    'Parent',obj.hp0);
                obj.Monty_Logo = uiaxes('Units', 'normalized',...
                    'Position', [0.6 0.05 0.3 0.99],...
                    'Parent', obj.hp0);
                %Import data import panel
                obj.hp1 = uipanel('Position', [0.05 0.75 0.9 0.05],...
                    'Title', 'Import Data',...
                    'Parent', obj.Gui_fig);
                %Import button for data and model import, and add holder for 
                %DropdownFolder
                obj.ImportButton1 = uicontrol('Style', 'pushbutton',...
                    'String', 'Import one walk',...
                    'Units', 'normalized',...
                    'Position', [0.15 0.05 0.15 0.9],...
                    'parent', obj.hp1,...
                    'Callback', @obj.cbImport,...
                    'FontWeight','bold',... 
                    'ForeGroundColor','#FFFFFF',...
                    'BackgroundColor','#0072BD');
                obj.ImportButton2 = uicontrol('Style', 'pushbutton',...
                    'String', 'Import folder with walks',...
                    'Units', 'normalized',...
                    'Position', [0.35 0.05 0.15 0.9],...
                    'parent', obj.hp1,...
                    'Callback', @obj.folderImport,...
                    'FontWeight','bold',... 
                    'ForeGroundColor','#FFFFFF',...
                    'BackgroundColor','#0072BD');
                obj.fileNames = ["Empty"];
                obj.DropdownFolder = uicontrol('Style','popupmenu',...
                                    'String',obj.fileNames,...
                                     'Units','normalized',...
                                    'Position',[0.55 0.05 0.15 0.9],...
                                    'BackgroundColor','white','Parent',obj.hp1,'Callback',@obj.get_walk);
                obj.ModelImportButton = uicontrol('Style', 'pushbutton',...
                    'String', 'Import classification model',...
                    'Units', 'normalized',...
                    'Position', [0.75 0.05 0.15 0.9],...
                    'parent', obj.hp1,...
                    'FontWeight','bold',... 
                    'ForeGroundColor','#FFFFFF',...
                    'BackgroundColor','#0072BD',...
                    'Callback',@obj.modelImport);
                %Data visualization panel
                obj.hp2 = uipanel('Position', [0.05 0.3 0.9 0.45],...
                    'Title', 'Acceleration Data Visualization',...
                    'Parent', obj.Gui_fig,'Visible','Off');
                %Add elements for table and visualization axis
                obj.Table = uitable('Units', 'normalized',...
                    'Data', obj.Table,...
                    'Position', [0.05 0.05 0.25 0.9],...
                    'ColumnEditable', true,...
                    'ColumnName',{'Time [s]';'X [m/s^2]';'Y [m/s^2]';'Z [m/s^2]'},...
                    'parent', obj.hp2,...
                    'CellEditCallback', @obj.cbEdit);
                 %Add figure axes
                 obj.Axis = uiaxes('Units', 'normalized',...
                    'Position', [0.375 0.05 0.6 0.9],...
                    'Parent', obj.hp2);
                %Add Radio button group for signal magnitude setting
                obj.DisplayButtons = uibuttongroup('Units','normalized',...
                    'Position',[0.8 0.9 0.4 0.3],'Parent',obj.hp2);
                %Add Radio button 1 for raw data selection
                obj.DisplayButton1 = uicontrol('Style','radiobutton',...
                    'Units','normalized',...
                    'String','Raw data',...
                    'Position',[0.1 0.1 0.15 0.15],'Parent',obj.DisplayButtons,...
                    'Callback',@obj.cbUpdate);
                %Add Radio button 2 for magnitude data selection
                obj.DisplayButton2 = uicontrol('Style','radiobutton',...
                    'Units','normalized',...
                    'String','Magnitude',...
                    'Position',[0.25 0.1 0.15 0.15],'Parent',obj.DisplayButtons,...
                    'Callback',@obj.magfct);
                % Add panel for classification      
                obj.hp3 = uipanel('Position', [0.05 0.15 0.9 0.15],...
                    'Title', 'Classification',...
                    'Parent', obj.Gui_fig,'Visible','Off');
                %Add button for walk classification
                obj.ClassifyButton = matlab.ui.control.UIControl('Style', 'pushbutton',...
                    'String', 'Classify',...
                    'Units', 'normalized',...
                    'Position', [0.1 0.3 0.1 0.5],...
                    'parent', obj.hp3,...
                    'FontWeight','bold',... 
                    'ForeGroundColor','#FFFFFF',...
                    'BackgroundColor','#0072BD',...
                    'Callback',@obj.classification);
                %Add button that summarizes results in text form
                obj.ResultSummary =   uicontrol('Style','text',...
                    'String',"Empty",...
                    'FontWeight','bold',...
                    'FontSize',10,...
                    'Units','normalized',...
                    'Position',[0.65 0.4 0.3 0.5],...
                    'Parent',obj.hp3,'Visible','Off');
                %Add button that resets GUI for new classifications
                obj.ClearButton  = matlab.ui.control.UIControl('Style', 'pushbutton',...
                    'String', 'Reset',...
                    'Units', 'normalized',...
                    'Position', [0.65 0.1 0.3 0.3],...
                    'parent', obj.hp3,...
                    'FontWeight','bold',... 
                    'ForeGroundColor','#FFFFFF',...
                    'BackgroundColor','#0072BD',...
                    'Callback',@obj.clear_data,'Visible','Off');
            end
    end
end
