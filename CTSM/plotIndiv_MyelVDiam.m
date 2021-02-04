function plotIndiv_MyelVDiam
load('D:\Call_Bergles_2021_CTSM\CTSM\DiameterAnalysis\RBP4data.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\DiameterAnalysis\VMdata.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\DiameterAnalysis\NTSR1data.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\DiameterAnalysis\NXPH4data.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\DiameterAnalysis\POdata.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\DiameterAnalysis\PVdata.mat')

figure
hold on
subplot(3,2,1)
generateHisto('PV',PV)
ylabel('Proportion of axons')

subplot(3,2,2)
generateHisto('VM',VM)

subplot(3,2,3)
generateHisto('PO',PO)
ylabel('Proportion of axons')

subplot(3,2,4)
generateHisto('RBP4',RBP4)

subplot(3,2,5)
generateHisto('NXPH4',NXPH4)
ylabel('Proportion of axons')
xlabel('Axon diameter (\mum)')

subplot(3,2,6)
generateHisto('NTSR1',NTSR1)
xlabel('Axon diameter (\mum)')

figQuality(gcf,gca,[4 5.5])
hold off
end
function generateHisto(NAME,data)
[vm,pv,po,som,rbp4,nxph4,ntsr1] = CTSMcolors;
if contains(NAME,'VM')
    color = vm;
elseif contains(NAME,'PV')
    color = pv;
elseif contains(NAME,'PO')
    color = po;
elseif contains(NAME,'NTSR1')
    color = ntsr1;
elseif contains(NAME,'RBP4')
    color = rbp4;
elseif contains(NAME,'NXPH4')
    color = nxph4;
end
M = NaN(length(data),1);
UM = NaN(length(data),1);
M(1:length(data(data(:,2)>=0.5))) = data(data(:,2)>=0.5);
UM(1:length(data(data(:,2)<0.5))) = data(data(:,2)<0.5);
hold on
histogram(M,'Normalization','probability','BinWidth',0.1,'BinLimits',[0.2,1.4],'FaceColor',color,'FaceAlpha',0.7);
histogram(UM,'Normalization','probability','BinWidth',0.1,'BinLimits',[0.2,1.4],'FaceColor','black','FaceAlpha',0.45);
axis([0 1.5 0 .8])
yticks(0:0.2:0.8)
ytickformat('%.1f')
xtickformat('%.1f')
title(NAME)
hold off
end