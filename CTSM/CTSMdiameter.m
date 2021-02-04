%edited 20180308 CLC
function avgDiams = CTSMdiameter
    %clear variables
    clc
    folder = uigetdir('E:\ANALYSIS\DiameterAnalysis\SingleAxons','Choose a directory');
    addpath(genpath(folder));
    folder = dir(folder);
    files={folder(:).name};
    files = files(contains(files,'.csv'));
    flnth = length(files);
    AxDiams = NaN(flnth,3);
    scale = input('What is the scale?   ');
    %18.9698
    %25.5353
    %32.4740 - vm315
    %34.3310
    %40.3894 - latest vm axons
    for i = 1:flnth
        axNum = str2double(files{i}(3:4));  %watch naming, different for pop vs single axon
        try AxDiam = CTSMdiam(files{i}, scale);
        catch
            warning('error calculating fwhm for %s',files{i});
            continue
        end
        %BE SURE THAT NUMS<10 ARE 2-DIGIT
        ismyel = str2double(files{i}(6)); %watch naming, different for pop vs single axon
        AxDiams(i,:) = [axNum, AxDiam, ismyel];
    end
    maxAx = max(AxDiams(:,1));
    avgDiams = NaN(maxAx,2);
    for i = 1:maxAx
        idx = AxDiams(:,1) == i;
        temp = AxDiams(idx,:);
        avgDiam = mean(temp(:,2),'omitnan');
        avgDiams(i,1) = avgDiam;
        avgDiams(i,2) = sum(temp(:,3),'omitnan') / length(temp(:,3));
    end
end
function AxDiam = CTSMdiam(fn, scale)
    M = csvread(fn,1,0);
    x = M(:,1)./scale;
    y = M(:,2);
    y = y - min(y);
    AxDiam = fwhm(x,y);
end