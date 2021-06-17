directory = 'D:\Call_Bergles_2021_CTSM\CTSrM\SCoReQuant';
addpath(genpath('D:\Call_Bergles_2021_CTSM'))
files = dir(directory);
files(1:2) = [];
dirFlags = [files.isdir];
folders = files(dirFlags);
scoreDens = struct;
scoreDens.allNum = [];
scoreDens.allLnth = [];
for j = 1:length(folders)
    currFolder = fullfile(directory, folders(j).name);
    contents = dir(currFolder);
    contents(1:2) = [];
    region = folders(j).name;
    fprintf('Started processing for %s.\n',region);
    if isfield(scoreDens, region)
        str = ['Data already exists for ' region '. Do you want to overwrite it? (1=yes / 0=no)\n'];
        a = input(str);
        if a==0
            continue
        elseif a==1
            scoreDens.(region) = [];
        end
    else
        scoreDens.(region) = [];
    end
    for k = 1:length(contents)
        if contains(contents(k).name,'.mat')
            continue
        end
        roi = matlab.lang.makeValidName(contents(k).name);
        currXmlstruct = fullfile(contents(1).folder,[roi '.mat']);
        if exist(currXmlstruct,'file')
            load(currXmlstruct)
            [numsegs, totlnth] = calculatePathsXML_score(xmlstruct);
        else
            tracesFile = fullfile(directory,region,contents(k).name);
            fprintf('Parsing %s traces file %s...\n',region,num2str(k));
            xmlstruct = parseXML_SingleCell(tracesFile);
            [numsegs, totlnth] = calculatePathsXML_score(xmlstruct);           
            save(fullfile(directory,region,[roi '.mat']),'xmlstruct');
            fprintf('Done.\n');
        end
        if contains(roi,'0_bsln')
            scoreDens.(region).ROI_0(1,:) = [numsegs, totlnth];
        elseif contains(roi,'0_rec5')
            scoreDens.(region).ROI_0(2,:) = [numsegs, totlnth];
        elseif contains(roi,'1_bsln')
            scoreDens.(region).ROI_1(1,:) = [numsegs, totlnth];
        elseif contains(roi,'1_rec5')
            scoreDens.(region).ROI_1(2,:) = [numsegs, totlnth];
        end  
    end
    scoreDens.(region).data = [scoreDens.(region).ROI_0(1,1) + scoreDens.(region).ROI_1(1,1), scoreDens.(region).ROI_0(1,2) + scoreDens.(region).ROI_1(1,2);...
                                scoreDens.(region).ROI_0(2,1) + scoreDens.(region).ROI_1(2,1), scoreDens.(region).ROI_0(2,2) + scoreDens.(region).ROI_1(2,2)];
    scoreDens.allNum = [scoreDens.allNum; scoreDens.(region).data(:,1)'];
    scoreDens.allLnth = [scoreDens.allLnth; scoreDens.(region).data(:,2)'];
    fprintf('Finished processing all %s traces.\n', region);
    save([directory 'scoreDens.mat'],'scoreDens');
end

%%
data = scoreDens.allNum;
avgData = mean(data(:,1:2));
sem = calcSEM(data(:,1:2),1);
figure
color = [0.5 0.5 0.5];
x = [1 2];
hold on
for i = 1:size(data,1)
    plot(x,data(i,1:2),'o-','Color',color,'MarkerSize',5,'LineWidth',1);
end
xlim([0.5,2.5]);
ylim([0,350]);
xticks([1,2]);
errorbar([1,2],avgData,sem,'ko','MarkerSize',3,'MarkerFaceColor','k','LineWidth',1.5,'CapSize',0)
hold off
set(gca,'XTickLabel',[])
figQuality(gcf,gca,[1.7,2.7]);

data = scoreDens.allLnth ./ 1000;
avgData = mean(data(:,1:2));
sem = calcSEM(data(:,1:2),1);
figure
color = [0.5 0.5 0.5];
x = [1 2];
hold on
for i = 1:size(data,1)
    plot(x,data(i,1:2),'o-','Color',color,'MarkerSize',5,'LineWidth',1);
end
xlim([0.5,2.5]);
ylim([0,14]);
xticks([1,2]);
errorbar([1,2],avgData,sem,'ko','MarkerSize',3,'MarkerFaceColor','k','LineWidth',1.5,'CapSize',0)
hold off
set(gca,'XTickLabel',[])
figQuality(gcf,gca,[1.7,2.7]);