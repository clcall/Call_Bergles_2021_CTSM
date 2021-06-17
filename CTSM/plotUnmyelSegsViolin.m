function unmyelSegData = plotUnmyelSegsViolin
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\PV1.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\PV3.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\PV4.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\PV5.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\SOM1.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\SOM2.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\SOM4.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\SOM5.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\VM315.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\VM511.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\VM3131.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\VM3132.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\PO316.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\PO327.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\PO3151.mat')
load('D:\Call_Bergles_2021_CTSM\CTSM\PLM_FinalTraces\PO3152.mat')
%%
[vm,pv,po,som,rbp4,nxph4,ntsr1] = CTSMcolors;
figure
subplot(1,4,2)
VMdata = [[VM511{:,end}] [VM315{:,end}] [VM3132{:,end}] [VM3131{:,end}]];
VMdata(VMdata==0) = [];
VMdata(isnan(VMdata)) = [];
VMdataN = VMdata(VMdata<5);
VMdataNN = VMdata(VMdata>5);
violin(VMdata(VMdata<150)','facecolor',vm,'facealpha',1,'edgecolor','none','mc',[],'medc',[]);
hold on
plot([0 1.5],[5 5],'k--')
hold off
ylim([0 150])
yticks(0:50:150)
xticklabels({})
xlabel('VM')
box off

subplot(1,4,4)
POdata = [[PO3151{:,end}] [PO3152{:,end}] [PO316{:,end}] [PO327{:,end}]];
POdata(POdata==0) = [];
POdata(isnan(POdata)) = [];
POdataN = POdata(POdata<5);
POdataNN = POdata(POdata>5);
violin(POdata(POdata<150)','facecolor',po,'facealpha',1,'edgecolor','none','mc',[],'medc',[]);
hold on
plot([0 1.5],[5 5],'k--')
hold off
ylim([0 150])
yticks(0:50:150)
xticklabels({})
xlabel('PO')
box off

subplot(1,4,1)
PVdata = [[PV1{:,end}] [PV3{:,end}] [PV4{:,end}] [PV5{:,end}]];
PVdata(PVdata==0) = [];
PVdata(isnan(PVdata)) = [];
PVdataN = PVdata(PVdata<5);
PVdataNN = PVdata(PVdata>5);
violin(PVdata(PVdata<150)','facecolor',pv,'facealpha',1,'edgecolor','none','mc',[],'medc',[]);
hold on
plot([0 1.5],[5 5],'k--')
hold off
ylim([0 150])
yticks(0:50:150)
xticklabels({})
xlabel('PV')
ylabel('Unmyelinated segment length (\mum)')
box off

subplot(1,4,3)
SOMdata = [[SOM1{:,end}] [SOM2{:,end}] [SOM4{:,end}] [SOM5{:,end}]];
SOMdata(SOMdata==0) = [];
SOMdata(isnan(SOMdata)) = [];
SOMdataN = SOMdata(SOMdata<5);
SOMdataNN = SOMdata(SOMdata>5);
violin(SOMdata(SOMdata<150)','facecolor',som,'facealpha',1,'edgecolor','none','mc',[],'medc',[]);
hold on
plot([0 1.5],[5 5],'k--')
hold off
ylim([0 150])
yticks(0:50:150)
xticklabels({})
xlabel('SOM')
box off

figQuality(gcf,gca,[4.5 3]);

unmyelSegData = {PVdataN,PVdataNN,VMdataN,VMdataNN,POdataN,POdataNN,SOMdataN,SOMdataNN};
%%
m = max([length(PVdataNN),length(VMdataNN),length(SOMdataNN),length(POdataNN)]);
temp = NaN(m,4);
temp(1:length(PVdataNN),1) = PVdataNN';
temp(1:length(VMdataNN),2) = VMdataNN';
temp(1:length(SOMdataNN),3) = SOMdataNN';
temp(1:length(POdataNN),4) = POdataNN';
[p,tbl,stats] = kruskalwallis(temp);
%%
figure;
h = cdfplot(VMdataNN);
h.Color = vm;
h.LineWidth = 1;
hold on
h = cdfplot(PVdataNN);
h.Color = pv;
h.LineWidth = 1;
h = cdfplot(SOMdataNN);
h.Color = som;
h.LineWidth = 1;
h = cdfplot(POdataNN);
h.Color = po;
h.LineWidth = 1;
hold off
figQuality(gcf,gca,[3,2.7]);
ylabel('cumulative proportion')
xlabel('unmyelinated segment length ()')
grid off
title([])
