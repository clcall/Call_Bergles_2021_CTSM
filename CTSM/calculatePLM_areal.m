% Calculates percent length myelination for all cell types
% Requires the following functions:
%   - parseXML.m
%   - calculatePathsXML.m

% edited 2018/03/01 CLC
function calculatePLM_areal
    clear variables;
    clc;
    directory = 'D:\Call_Bergles_2021_CTSM\CTSM\ArealComparison';
    cd(directory)
    addpath(genpath('D:\Call_Bergles_2021_CTSM'))
    files = dir(directory);
    files(1:2) = [];
    dirFlags = [files.isdir];
    folders = files(dirFlags);
    PLMfile = fullfile(directory, 'arealPLM.mat');
    if exist(PLMfile,'file')
        str = 'PLM file already exists. Overwrite? (1=yes / 0=no)\n';
        a = input(str);
        if a
            arealPLM = struct;
        else
            load(PLMfile);
        end
    else
        arealPLM = struct;
    end
    for j = 1:length(folders)
        currFolder = fullfile(directory, folders(j).name);
        contents = dir(currFolder);
        contents(1:2) = [];
        animNum = folders(j).name; 
        fprintf('Started processing for %s.\n',animNum);
        if isfield(arealPLM, animNum)
            str = ['Data already exists for ' animNum '. Do you want to overwrite it? (1=yes / 0=no)\n'];
            a = input(str);
            if a==0
                continue
            elseif a==1
                arealPLM.(animNum) = [];
            end
        else
            arealPLM.(animNum) = [];
        end
        for k = 1:length(contents)
            if contains(contents(k).name,'AUD') || contains(contents(k).name,'aud')
                varname = 'AUD';
            elseif contains(contents(k).name,'VIS') || contains(contents(k).name,'vis')
                varname = 'VIS';
            elseif contains(contents(k).name,'TEa') 
                varname = 'TEa';
            elseif contains(contents(k).name,'MOs') 
                varname = 'MOs';
            end
            currXmlstruct = fullfile(contents(1).folder,[varname '.mat']);
            if exist(currXmlstruct,'file')
                load(currXmlstruct)
                arealPLM.(animNum).(varname) = calculatePathsXML_CTSM(xmlstruct);
            else
                tracesFile = fullfile(directory,animNum,contents(k).name);
                fprintf('Parsing %s traces file %s...\n',animNum,num2str(k));
                xmlstruct = parseXML_SingleCell(tracesFile);
                arealPLM.(animNum).(varname) = calculatePathsXML_CTSM(xmlstruct);
                save(fullfile(directory,animNum,[varname '.mat']),'xmlstruct');
                fprintf('Done.\n');
            end
        end
        fprintf('Finished processing all %s traces.\n', animNum);
        save(fullfile(directory,'arealPLM.mat'),'arealPLM');
    end
end