% Updated 2/22/18 CLC - to include smoothed lengths, line 61

function [ myelinPercent ] = calculatePathsXML( xmlstruct )
    traceData = parseData(xmlstruct);
    traceNames = traceData(:,1);
    traceMatData = cell2mat(traceData(:,2:4));
         if sum(cellfun(@isempty,traceData(:,2))) > 0
             warning('Format error. Something is mistyped.')
             return
         end
    axon_num = max(traceMatData(:,1)); % pulls out the number of axons
    totalAxonLength = [];
    totalScoreLength = [];
    avgInternodeLength = [];
    axonName = [];
    
    for i = 1:axon_num
        axon_idx = find(traceMatData(:,1)==i & traceMatData(:,2)==0);
        temp = traceMatData(axon_idx,:);
        tempStr = traceNames(axon_idx);
        if isempty(tempStr)
           continue 
        end
        tempStr = tempStr(1);
        totalAxonLength = [totalAxonLength; sum(temp(:,3))];
        axonName = [axonName; tempStr];
        
        %TOTAL MYELINATED LENGTH
        score_idx = traceMatData(:,1)==i & traceMatData(:,2)~=0;
        score_segs = traceMatData(score_idx,:);
        totalScoreLength = [totalScoreLength; sum(score_segs(:,3))];
        
%         %AVG INTERNODE LENGTH
%         if any(traceMatData(:,5))
%             uncut_ints = internodes(internodes(:,5)~=1,:);
%             avgInternodeLength = [avgInternodeLength; mean(uncut_ints(:,3))];
%             allInternodes = [allInternodes; uncut_ints(:,1:3)];
%         else
%             if(size(internodes,1) >= 3)
%                 avgInternodeLength = [avgInternodeLength; mean(internodes(2:end-1,3))];
%             else
%                 avgInternodeLength = [avgInternodeLength; NaN];
%             end  
%         end
    end
    percentMyelin = (totalScoreLength ./ totalAxonLength)  * 100;
    myelinPercent = table(axonName,totalAxonLength,totalScoreLength,percentMyelin);
 end

%----Local Function----
function [ parsedData ] = parseData(xmlstruct)
    %get length of paths list
    numPaths = size(xmlstruct.paths,2); 
    traceName = cell(numPaths,1);
    traceLength = cell(numPaths,1);
    traceSWC = cell(numPaths,1);
    traceColor = cell(numPaths,1);
    for i = 1:numPaths
        traceName{i,1} = xmlstruct.paths(i).attribs.name;
        traceLength{i,1} = xmlstruct.paths(i).attribs.reallength_smoothed;
        traceSWC{i,1} = str2double(xmlstruct.paths(i).attribs.swctype);
    end
    %PARSE TRACE INFO
    %axon extraction
    axon_index = find(~contains(traceName,'s'));
    axonNames = traceName(axon_index);
    axonLengths = traceLength(axon_index);
%     axonSWCs = traceSWC(axon_index);
%     axonColors = traceColor(axon_index);
    %parse out axon number
    for i = 1:length(axonNames)
        s = axonNames{i,1};
        axonNames{i,2} = str2double(s(3:4));
        axonNames{i,3} = 0;
    end
    %sheath extraction
    sheath_index = find(contains(traceName,'s')); %finds all indices where 's' is in the name
    sheathNames = traceName(sheath_index);
    sheathLengths = traceLength(sheath_index);
%     sheathSWCs = traceSWC(sheath_index);
%     sheathColors = traceColor(sheath_index);
    sheath_indexPos = cell2mat(strfind(traceName,'s'));
    for i = 1:length(sheathNames)
        s = sheathNames{i,1};
        sheathNames{i,2} = str2double(s(3:4));
        sheathNames{i,3} = str2double(s(6:7));
    end
    %create array to send main function name & length info
    parsedData = [axonNames, axonLengths; sheathNames, sheathLengths];
end