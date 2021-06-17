function [arealPLM,p,tbl,stats,comparison,xNames] = analyzeArealPLM(CTSM_PLM)
p = {};
tbl = {};
stats = {};
comparison = {};
load('D:\Call_Bergles_2021_CTSM\CTSM\ArealComparison\arealPLM.mat')
%% combine data per animal for each region
fields = fieldnames(arealPLM);
areas = {'AUD','VIS','MOs','TEa'};
for a = 1:length(areas)
    arealPLM.(areas{a}).cmbdData = [];
    arealPLM.(areas{a}).cmbdAxData = [];
    arealPLM.(areas{a}).cmbdIntData = [];
end
for m = 1:(length(fields))
    for a = 1:length(areas)
        if ~isfield(arealPLM.(fields{m}),areas{a})
            continue
        end
        arealPLM.(areas{a}).cmbdData = [arealPLM.(areas{a}).cmbdData; arealPLM.(fields{m}).(areas{a}).percentMyelin];
        arealPLM.(areas{a}).cmbdAxData = [arealPLM.(areas{a}).cmbdAxData; arealPLM.(fields{m}).(areas{a}).totalAxonLength];
        arealPLM.(areas{a}).cmbdIntData = [arealPLM.(areas{a}).cmbdIntData; arealPLM.(fields{m}).(areas{a}).avgInternodeLength];
    end
end

arealPLM.SS.cmbdData = CTSM_PLM.PV.cmbdData;
arealPLM.SS.cmbdAxData = CTSM_PLM.PV.cmbdAxData;
arealPLM.SS.cmbdIntData = CTSM_PLM.PV.cmbdIntData;
%% calculate statistics
data = NaN(60,3);
data(1:length(arealPLM.SS.cmbdData),1) = arealPLM.SS.cmbdData;
data(1:length(arealPLM.AUD.cmbdData),2) = arealPLM.AUD.cmbdData;
data(1:length(arealPLM.VIS.cmbdData),3) = arealPLM.VIS.cmbdData;
data(1:length(arealPLM.MOs.cmbdData),4) = arealPLM.MOs.cmbdData;
data(1:length(arealPLM.TEa.cmbdData),5) = arealPLM.TEa.cmbdData;

[p{1},tbl{1},stats{1}] = kruskalwallis(data);
comparison{1} = multcompare(stats{1},'CType','dunn-sidak');
%%
colors{1} = [244 228 28]./255;
colors{2} = [253 190 61]./255;
colors{3} = [65 186 151]./255;
colors{4} = [20 132 211]./255;
colors{5} = [53 42 134]./255;
figure;
h = cdfplot(data(:,5));
h.Color = colors{1};
h.LineWidth = 2;
hold on
h = cdfplot(data(:,4));
h.Color = colors{2};
h.LineWidth = 2;
h = cdfplot(data(:,3));
h.Color = colors{3};
h.LineWidth = 2;
h = cdfplot(data(:,2));
h.Color = colors{4};
h.LineWidth = 2;
h = cdfplot(data(:,1));
h.Color = colors{5};
h.LineWidth = 2;
hold off
figQuality(gcf,gca,[3,2.7]);
ylabel('cumulative proportion')
xlabel('percent length myelinated')
grid off
title([])
%% plot histograms
figure
subplot(2,3,1)
generateHisto('SS',arealPLM);
ylabel('Proportion of axons')
xlabel('Percent length myelinated')
box off

subplot(2,3,2)
generateHisto('VIS',arealPLM);
xlabel('Percent length myelinated')
box off

subplot(2,3,3)
generateHisto('AUD',arealPLM);
xlabel('Percent length myelinated')
box off

subplot(2,3,4)
generateHisto('MOs',arealPLM);
ylabel('Proportion of axons')
xlabel('Percent length myelinated')
box off

subplot(2,3,5)
generateHisto('TEa',arealPLM);
xlabel('Percent length myelinated')
box off

% FINAL SUBPLOT BELOW
%% prop myel
anNames = {'MOBP_PV','PV1','PV2','PV3','PV4'};
xNames = {'SS','VIS','AUD','MOs','TEa'};
data = NaN(length(anNames),5);
sem = NaN(1,length(anNames));
avgData = sem;
for i = 1:length(anNames)
    fields = fieldnames(arealPLM.(anNames{i}));
    for j = 1:(length(fields))
        switch fields{j}
            case 'VIS'
                area = 2;
            case 'AUD'
                area = 3;
            case 'MOs'
                area = 4;
            case 'TEa'
                area = 5;
        end
        temp = arealPLM.(anNames{i}).(fields{j}).percentMyelin;
        data(i,area) = nnz(temp)/length(temp);
    end
end

fields = fieldnames(CTSM_PLM.PV);
for f = 2:5
    temp = CTSM_PLM.PV.(fields{f-1}).percentMyelin;
    data(f,1) = nnz(temp)./length(temp);
end


mbpdata = [NaN,64.877,NaN,NaN,NaN;35.035,54.746,59.966,NaN,18.212;69.735,NaN,28.511,NaN,NaN;37.298,65.789,77.77,49.205,8.785;55.87,80.854,76.689,34.111,14.752];
scaleddata = mbpdata ./ data;
sem = calcSEM(scaleddata,1);
avgData = mean(scaleddata,1,'omitnan');
[~, pv] = CTSMcolors;
color = {pv, pv, pv, pv, pv};
subplot(2,3,6)
errorbar(avgData,sem,'ko','MarkerSize',5,'MarkerFaceColor','w','LineWidth',1.5)
hold on
h = plotSpread(scaleddata,'xNames',xNames,'distributionMarker','o','distributionColor',color);
set(h{1},'MarkerSize',5);
set(h{1},'LineWidth',1);
hold off
set(gca,'XTickLabel',xNames);
% ylabel('Proportion of axons myelinated');
xlim([0.5 5.5])
figQuality(gcf,gca,[6 3.4])

[p{2},tbl{2},stats{2}] = kruskalwallis(scaleddata);
comparison{2} = multcompare(stats{2},'CType','dunn-sidak');
end

function generateHisto(name,arealPLM)
    [~,pv] = CTSMcolors;
    histogram(arealPLM.(name).cmbdData,'Normalization','probability','BinWidth',10,'BinLimits',[0,100],'FaceColor',pv,'FaceAlpha',1);
    axis([0 100 0 1])
    ytickformat('%.1f')
    title(name)
end