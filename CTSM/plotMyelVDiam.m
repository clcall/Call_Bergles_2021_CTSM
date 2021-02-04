function [glm,p,ks2stat] = plotMyelVDiam
load('D:\OligodendrocyteAnalysisCode\CTSM\DiameterAnalysis\RBP4data.mat')
load('D:\OligodendrocyteAnalysisCode\CTSM\DiameterAnalysis\VMdata.mat')
load('D:\OligodendrocyteAnalysisCode\CTSM\DiameterAnalysis\NTSR1data.mat')
load('D:\OligodendrocyteAnalysisCode\CTSM\DiameterAnalysis\NXPH4data.mat')
load('D:\OligodendrocyteAnalysisCode\CTSM\DiameterAnalysis\POdata.mat')
load('D:\OligodendrocyteAnalysisCode\CTSM\DiameterAnalysis\PVdata.mat')
[vm,pv,po,som,rbp4,nxph4,ntsr1] = CTSMcolors;
allData = [PV;NTSR1;NXPH4;RBP4;PO;VM];
x = allData(:,1);
y = allData(:,2);

% axNames = {'PV','VM','PO','SOM','RBP4','NXPH4','NTSR1'};
% figure
% hold on
% [binomCoeffs,binomDev,binomStats] = glmfit(x,y,'binomial','link','probit');
% yfit = glmval(binomCoeffs,x,'probit');
% srt_yfit = sort(yfit);
% plot(sort(x),srt_yfit,'--','LineWidth',1.2,'Color','k');
% axis([0 1.4 0 1])
% xlabel('Average axon diameter (\mum)')
% ylabel('Proportion of axon length myelinated')
% figQuality(gcf,gca,[2.8 2.1])
% hold off

types = [repmat({'PV'},size(PV,1),1);...
         repmat({'NTSR1'},size(NTSR1,1),1);...
         repmat({'NXPH4'},size(NXPH4,1),1);...
         repmat({'RBP4'},size(RBP4,1),1);...
         repmat({'PO'},size(PO,1),1);...
         repmat({'VM'},size(VM,1),1)];

tbl = table(x,types,y,'VariableNames',{'diam','type','PLM'});
glm = stepwiseglm(tbl,'PLM ~ diam*type','Distribution','binomial','CategoricalVars','type','Link','probit')
[pd,a,~] = partialDependence(glm,{'diam','type'});
figure
hold on
h = plot(a,pd(2:end,:),'-','LineWidth',1);
h(1).Color = nxph4;
h(2).Color = po;
h(3).Color = pv;
h(4).Color = rbp4;
h(5).Color = vm;

plot(NXPH4(:,1),NXPH4(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'MarkerEdgeColor',nxph4,'LineWidth',1);
plot(PO(:,1),PO(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'MarkerEdgeColor',po,'LineWidth',1);
plot(NTSR1(:,1),NTSR1(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'MarkerEdgeColor',ntsr1,'LineWidth',1);
plot(PV(:,1),PV(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'MarkerEdgeColor',pv,'LineWidth',1);
plot(RBP4(:,1),RBP4(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'MarkerEdgeColor',rbp4,'LineWidth',1);
plot(VM(:,1),VM(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'MarkerEdgeColor',vm,'LineWidth',1);

xlabel('axon diameter (\mum)')
ylabel('probability myelinated')
ytickformat('%.1f')
xtickformat('%.1f')
hold off
xlim([0.2 1.3])
figQuality(gcf,gca,[3 2.5]);
%%
figure
hold on
M = NaN(length(allData),1);
UM = NaN(length(allData),1);
M(1:length(allData(allData(:,2)>=0.5))) = allData(allData(:,2)>=0.5);
UM(1:length(allData(allData(:,2)<0.5))) = allData(allData(:,2)<0.5);
histogram(M,'Normalization','probability','BinWidth',0.1,'BinLimits',[0.2,1.4],'FaceColor','cyan','FaceAlpha',0.6); 
histogram(UM,'Normalization','probability','BinWidth',0.1,'BinLimits',[0.2,1.4],'FaceColor','black','FaceAlpha',0.45); 
axis([0 1.5 0 .5])
xlabel('average axon diameter (\mum)')
ylabel('proportion of axons')
ytickformat('%.1f')
xtickformat('%.1f')
figQuality(gcf, gca, [3 2.5])
hold off
[~,p,ks2stat] = kstest2(M,UM)
