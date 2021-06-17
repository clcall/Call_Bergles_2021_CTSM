function [ numsegs, totlnth ] = calculatePathsXML_score( xmlstruct )
    traceData = parseData(xmlstruct);
    traceMatData = cell2mat(traceData(:,2:end));
         if sum(cellfun(@isempty,traceData(:,2))) > 0
             warning('Format error. Something is mistyped.')
             return
         end
    numsegs = size(traceMatData,1); 
    totlnth = sum(traceMatData(:,1));
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
        traceLength{i,1} = xmlstruct.paths(i).attribs.reallength;%_smoothed;
        traceSWC{i,1} = str2double(xmlstruct.paths(i).attribs.swctype);
    end
    %create array to send main function name & length info
    parsedData = [traceName,traceLength,traceSWC,traceColor];
end