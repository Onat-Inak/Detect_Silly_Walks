%Group 8 Monty Matlab SoSe2021, Leonie Freisinger, Onat Inak, Adam Misik, Robert Jacumet
%Helper function that is additionally implemented due to the extra naming convention of group 8
%This class implements the GUI data definition from the provided ".mat"-file.
classdef GUI_data < handle
    %Initialize properties
    properties (SetAccess=public, SetObservable, AbortSet) 
        TimeVector
        DataMatrix 
        filename
    end
    
    methods
        %Method to load data from provided ".mat"-file 
        function importData(obj,fileName)
            data = load(fileName);
            obj.TimeVector = data.time;
            obj.DataMatrix = data.data; 
            obj.filename = fileName;
        end
        %Method to get filename of the inspected signal and load the data 
        function cbImport(obj)
            display('Please select file to be imported: ')
            fileName = uigetfile('.mat')
            importData(obj, fileName)
        end
        
        function cbUpdate(obj)
                % Update table data
                data = obj.Data.DataMatrix;
                columnNames = {'Data1', 'Data2'};
                rownames = obj.Data.TimeVector;
                columnEditable = [true,true]; 
                rowEditable = false;
                obj.Table = uitable('Data', data, 'ColumnName',columnNames,'RowName',rownames,'ColumnEditable',...
                    columnEditable);

                % Update axis
                plot(obj.Axis,rownames,obj.Table.Data(:,1))
                hold on 
                plot(obj.Axis,rownames,obj.Table.Data(:,2)) 
         end 
    end
end

