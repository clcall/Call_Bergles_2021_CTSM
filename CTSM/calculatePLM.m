% Calculates percent length myelination for all cell types
% Requires the following functions:
%   - parseXML.m
%   - calculatePathsXML.m

% edited 20180306 CLC
function PLM = calculatePLM
%     clear variables;
%     clc;
    directory = 'D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces';
    addpath(genpath('D:\Call_Bergles_2021_CTSM'))
    files = dir(directory);
    files(1:2) = [];
    dirFlags = [files.isdir];
    folders = files(dirFlags);
    PLMfile = fullfile(directory, 'PLM.mat');
%     if exist(PLMfile,'file')
%         load(PLMfile);
% %         return
%     else
        PLM = struct;
%     end
    for j = 1:length(folders)
        currFolder = fullfile(directory, folders(j).name);
        contents = dir(currFolder);
        contents(1:2) = [];
        aClass = folders(j).name; 
        fprintf('Started processing for %s.\n',aClass);
        if isfield(PLM, aClass)
            str = ['Data already exists for ' aClass '. Do you want to overwrite it? (1=yes / 0=no)\n'];
            a = input(str);
            if a==0
                continue
            elseif a==1
                PLM.(aClass) = [];
            end
        else
            PLM.(aClass) = [];
        end
        for k = 1:length(contents)
            if contains(contents(k).name,'.mat')
                continue
            end
            varname = matlab.lang.makeValidName(contents(k).name);
            currXmlstruct = fullfile(contents(1).folder,[varname '.mat']);
            if exist(currXmlstruct,'file')
                load(currXmlstruct)
                PLM.(aClass).(varname) = calculatePathsXML_CTSM(xmlstruct);
            else
                tracesFile = fullfile(directory,aClass,contents(k).name);                
                fprintf('Parsing %s traces file %s...\n',aClass,num2str(k));
                xmlstruct = parseXML_SingleCell(tracesFile);
                PLM.(aClass).(varname) = calculatePathsXML_CTSM(xmlstruct);
                save(fullfile(directory,aClass,[varname '.mat']),'xmlstruct');
                fprintf('Done.\n');
            end
%             unmyelData = calcUnmyelSegs(xmlstruct);
        end
        fields = fieldnames(PLM.(aClass));
        PLM.(aClass).cmbdData = [];
        PLM.(aClass).cmbdAxData = [];
        PLM.(aClass).cmbdIntData = [];
        for m = 1:length(fields)
            %ReRun just this part of analysis
            PLM.(aClass).cmbdData = [PLM.(aClass).cmbdData; PLM.(aClass).(fields{m}).percentMyelin];
            PLM.(aClass).cmbdAxData = [PLM.(aClass).cmbdAxData; PLM.(aClass).(fields{m}).totalAxonLength];
            PLM.(aClass).cmbdIntData = [PLM.(aClass).cmbdIntData; PLM.(aClass).(fields{m}).avgInternodeLength];
        end
        fprintf('Finished processing all %s traces.\n', aClass);
        save([directory 'PLM.mat'],'PLM');
    end
end