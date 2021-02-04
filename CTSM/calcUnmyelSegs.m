function [finalAxData] = calcUnmyelSegs(xmlstruct)
    %   For each axon, takes the _d coordinates from xmlstruct result of parseXML 
    %function and concatanates into a cell of axonNames_Coords.
    %   Next, concatanates all Axon0iSheaths coordinates into single cell in third
    %column of axonNames_Coords. 
    numPaths = size(xmlstruct.paths,2); 
    traceName = cell(numPaths,2);
    traceCoords = cell(numPaths,1);
    %Retrieve the xmlstruct trace data into a trace cell array
    for i = 1:numPaths
        traceNameCoords{i,1} = xmlstruct.paths(i).attribs.name;
        traceNameCoords{i,2} = NaN;
        traceNameCoords{i,3} = xmlstruct.paths(i).attribs.reallength_smoothed;
        traceNameCoords{i,4} = xmlstruct.paths(i).points.smoothed;
    end
    %   Parse out the axon names then refines the list of axon
    %names to only include the longest segment
    axonData = traceNameCoords(~contains(traceNameCoords(:,1),'Sheath'),:);
    sheathData = traceNameCoords(contains(traceNameCoords(:,1),'Sheath'),:);
    for i = 1:length(axonData)
        s = axonData{i,1};
        axonData{i,2} = str2double(s(5:6));
    end
    for i = 1:length(axonData)
        if ~contains(traceNameCoords(:,1),['Axon' num2str(axonData{i,2},'%02d') 'Sheath'])
            axonData(i,1) = {'delete'};
        end
    end
    axonData = axonData(~contains(axonData(:,1),'delete'),:);
    %Place concatanated coordinates in array next to corresponding axon name
    nums = unique(cell2mat(axonData(:,2)));
    finalAxData = [];
    for k = 1:length(nums)
        axon_index = [axonData{:,2}]==nums(k);
        currAxData = axonData(axon_index,:);
        currAxSheaths = sheathData(contains(sheathData(:,1),currAxData{1,1}(1:6)),4);
        if length(currAxSheaths) < 2
            finalAxData = [finalAxData; [{NaN} {NaN} {NaN} {NaN}]];
            continue
        end
        name = currAxData{1,1};
        figure
        hold on
        for i = 1:size(currAxData,1)
            if i==1
                c = 'r';
            elseif i==2
                c = [1 165/255 0];
            elseif i==3
                c = 'y';
            elseif i==4
                c = 'g';
            elseif i==5
                c = 'c';
            elseif i==6
                c = 'b';
            elseif i==7
                c = 'm';
            elseif i==8
                c = 'k';
            elseif i>8
                c = [rand rand rand];
            end
            plot3(currAxData{i,4}(:,1),currAxData{i,4}(:,2),currAxData{i,4}(:,3),'Color',c);
            scatter3(currAxData{i,4}(1,1),currAxData{i,4}(1,2),currAxData{i,4}(1,3),85,'o','k');
            scatter3(currAxData{i,4}(end,1),currAxData{i,4}(end,2),currAxData{i,4}(end,3),85,'s','k');
        end
        annotation('textbox','String',name,'FitBoxToText','on');
        hold off
        clc
        using = input('Do you want to use this axon?\n');
        currAx = [];
        if ~(using==1 || using==0)
            using = input('Input not recognized. Do you want to use this axon?\n');
        elseif using==0
            finalAxData = [finalAxData; [{NaN} {NaN} {NaN} {NaN}]];
            continue
        elseif using==1
            segs = input('Which segments should be used?\n','s');
            flip = input('Are there any segments that should be flipped?\n','s');
            pos = [];
            if contains(segs,'r')
                pos = [pos, regexp(segs, 'r', 'once')];
                currAx = [currAx; currAxData(1,:)];
            end
            if contains(segs,'o')
                pos = [pos, regexp(segs, 'o', 'once')];
                currAx = [currAx; currAxData(2,:)];
            end
            if contains(segs,'y')
                pos = [pos, regexp(segs, 'y', 'once')];
                currAx = [currAx; currAxData(3,:)];
            end
            if contains(segs,'g')
                pos = [pos, regexp(segs, 'g', 'once')];
                currAx = [currAx; currAxData(4,:)];
            end
            if contains(segs,'c')
                pos = [pos, regexp(segs, 'c', 'once')];
                currAx = [currAx; currAxData(5,:)];
            end
            if contains(segs,'b')
                pos = [pos, regexp(segs, 'b', 'once')];
                currAx = [currAx; currAxData(6,:)];
            end
            if contains(segs,'m')
                pos = [pos, regexp(segs, 'm', 'once')];
                currAx = [currAx; currAxData(7,:)];
            end
            if contains(segs,'k')
                pos = [pos, regexp(segs, 'k', 'once')];
                currAx = [currAx; currAxData(8,:)];
            end
            % check flipping status
            if contains(flip,'r')
                currAx{1,4} = flipud(currAx{1,4});
            end
            if contains(flip,'o')
                currAx{2,4} = flipud(currAx{2,4});
            end
            if contains(flip,'y')
                currAx{3,4} = flipud(currAx{3,4});
            end
            if contains(flip,'g')
                currAx{4,4} = flipud(currAx{4,4});
            end
            if contains(flip,'c')
                currAx{5,4} = flipud(currAx{5,4});
            end
            if contains(flip,'b')
                currAx{6,4} = flipud(currAx{6,4});
            end
            if contains(flip,'m')
                currAx{7,4} = flipud(currAx{7,4});
            end
            if contains(flip,'k')
                currAx{8,4} = flipud(currAx{8,4});
            end
        end
    % sanity check
%         figure
%         hold on
%         for i = 1:size(currAx,1)
%             plot3(currAx{i,4}(:,1),currAx{i,4}(:,2),currAx{i,4}(:,3));
%             scatter3(currAx{i,4}(1,1),currAx{i,4}(1,2),currAx{i,4}(1,3),40,'o','k');
%             scatter3(currAx{i,4}(end,1),currAx{i,4}(end,2),currAx{i,4}(end,3),60,'s','k');
%         end
%         hold off
        orderedCurrAx = cell(1,4);
        for p = 1:length(pos)
            orderedCurrAx(pos(p),:) = currAx(p,:);
        end
        currAxConc = [currAx(1,1),cell2mat(orderedCurrAx(:,4))];
        finalAxData = [finalAxData; [currAxConc {NaN} {NaN}]];
        currAxData_bin = finalAxData{k,2};
        
        % Now verify sheaths for used axon segments
        figure
        hold on
        plot3(currAxConc{1,2}(:,1),currAxConc{1,2}(:,2),currAxConc{1,2}(:,3));
        L = size(currAxSheaths,1);
        for i =1:L
            plot3(currAxSheaths{i}(:,1),currAxSheaths{i}(:,2),currAxSheaths{i}(:,3));
            idx = dsearchn(currAxData_bin, currAxSheaths{i});
            if idx(1) < idx(end)
                indxlength = idx(1):idx(end);
            else
                indxlength = idx(end):idx(1);
            end
            currAxData_bin(indxlength,:) = NaN(length(indxlength),3);
        end
        hold off
        NonNanLocations = ~isnan(currAxData_bin(:,1));
        props = regionprops(NonNanLocations, 'Area', 'PixelIdxList');
        X = [];
        % EXCLUDE UNMYELINATED SEGMENTS AT START OR END OF AXON
        for x = 1:length(props)
            start = props(x).PixelIdxList(1);
            finish = props(x).PixelIdxList(end);
            temp = currAxData_bin(start:finish,:);
            b_coords = temp(2:end,:);
            a_coords = temp(1:end-1,:);
            X(x) = sum(sqrt(sum((b_coords-a_coords).^2,2)));
        end
        finalAxData{k,3} = currAxData_bin;
        finalAxData{k,4} = X;
    end
end