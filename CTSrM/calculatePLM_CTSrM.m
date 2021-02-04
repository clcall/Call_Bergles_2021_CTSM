% Calculates percent length myelination for all cell types
% Requires the following functions:
%   - parseXML.m
%   - calculatePathsXML.m

% edited 20180306 CLC
function PLM = calculatePLM_CTSrM(directory, files)
    files(1:2) = [];
    dirFlags = [files.isdir];
    folders = files(dirFlags);
    PLMfile = fullfile(directory, 'PLM.mat');
%     if exist(PLMfile,'file')
%         load(PLMfile);
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
            a = 0;
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
                PLM.(aClass).(varname) = calculatePathsXML(xmlstruct);
            else
                tracesFile = fullfile(directory,aClass,contents(k).name);                
                fprintf('Parsing %s traces file %s...\n',aClass,num2str(k));
                xmlstruct = parseXML_SingleCell(tracesFile);
                PLM.(aClass).(varname) = calculatePathsXML(xmlstruct);
                save([directory aClass '\' varname '.mat'],'xmlstruct');
                save([directory aClass '\' varname '_PLM.mat'],'PLM');
                fprintf('Done.\n');
            end
        end
        fields = fieldnames(PLM.(aClass));
%         PLM.(aClass).deltaPLM = [];
%         PLM.(aClass).cmbdAxData = [];
%         PLM.(aClass).cmbdIntData = [];
        bslnAxs = PLM.(aClass).(fields{1}).axonName;
        rec5wkAxs = PLM.(aClass).(fields{2}).axonName;
        survIdx = NaN(length(rec5wkAxs),1);
        fprintf(aClass)
        survival = length(rec5wkAxs) ./ length(bslnAxs)
        for i=1:length(rec5wkAxs)
            survIdx(i) = find(~cellfun(@isempty,strfind(bslnAxs,rec5wkAxs{i})));
        end
        PLM.(aClass).deltaPLM = PLM.(aClass).(fields{2}).percentMyelin - PLM.(aClass).(fields{1}).percentMyelin(survIdx);
%             PLM.(aClass).cmbdAxData = [PLM.(aClass).cmbdAxData; PLM.(aClass).(fields{m}).totalAxonLength];
%             PLM.(aClass).cmbdIntData = [PLM.(aClass).cmbdIntData; PLM.(aClass).(fields{m}).totalScoreLength];
        fprintf('Finished processing all %s traces.\n', aClass);
        save([directory 'PLM.mat'],'PLM');
    end
end