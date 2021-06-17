data = [-2.56647890000000,-50.8875740000000;-3.24524010000000,-58.9371981000000;7.10667250000000,4.25531910000000;2.93586270000000,-67.0731707000000;1.04166670000000,-33.3333333000000;-1.31453610000000,4.02298850000000;0.272556400000000,-41.0526316000000;1.96078430000000,-11.7647059000000;6.32001690000000,-27.1929825000000;11.5036232000000,-21.7391304000000;9.87784000000000,-28.0423280000000];

avgData = mean(data);
sem = calcSEM(data,1);
figure
% subplot(1,2,1)
[~,color] = CTSMcolors;
p = plotSpread(data,'distributionMarker','o','distributionColor',{color,'k'});
hold on
set(p{1},'MarkerSize',5);
set(p{1},'LineWidth',1);
errorbar(avgData,sem,'ko','MarkerSize',3,'MarkerFaceColor','k','LineWidth',1.5,'CapSize',0)
hold off
set(gca,'XTickLabel',[])
% avgData = mean(data(:,2));
% sem = calcSEM(data(:,2),1);
% subplot(1,2,2)
% p = plotSpread(data(:,2),'distributionMarker','o','distributionColor','k');
% hold on
% set(p{1},'MarkerSize',5);
% set(p{1},'LineWidth',1);
% errorbar(avgData,sem,'ko','MarkerSize',3,'MarkerFaceColor','k','LineWidth',1.5,'CapSize',0)
% hold off
figQuality(gcf,gca,[3,2.7]);
