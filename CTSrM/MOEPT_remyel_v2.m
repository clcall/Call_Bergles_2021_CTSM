data = [0.579881657000000,0.554216867000000,169,83;0.526570048000000,0.494117647000000,207,85;0.425531915000000,0.496598639000000,141,147;0.378048780000000,0.407407407000000,82,27;0.500000000000000,0.510416667000000,144,96;0.482758621000000,0.469613260000000,174,181;0.452631579000000,0.455357143000000,190,112;0.361344538000000,0.380952381000000,119,105;0.298245614000000,0.361445783000000,114,83;0.489130435000000,0.604166667000000,184,144;0.423280423000000,0.522058824000000,189,136];
data(:,1:2) = data(:,1:2).*100;
avgData = mean(data(:,1:2));
sem = calcSEM(data(:,1:2),1);
figure
[~,color] = CTSMcolors;
x = [1 2];
hold on
for i = 1:size(data,1)
    plot(x,data(i,1:2),'o-','Color',color,'MarkerSize',5,'LineWidth',1);
end
xlim([0,3]);
ylim([0,70]);
xticks([1,2]);
errorbar([1,2],avgData,sem,'ko','MarkerSize',3,'MarkerFaceColor','k','LineWidth',1.5,'CapSize',0)
hold off
set(gca,'XTickLabel',[])
figQuality(gcf,gca,[2,2.7]);

figure
x = [1 2];
avgData = mean(data(:,3:4));
sem = calcSEM(data(:,3:4),1);
hold on
for i = 1:size(data,1)
    plot(x,data(i,3:4),'o-','Color',color,'MarkerSize',5,'LineWidth',1);
end
xlim([0,3]);
% ylim([0,70]);
xticks([1,2]);
errorbar([1,2],avgData,sem,'ko','MarkerSize',3,'MarkerFaceColor','k','LineWidth',1.5,'CapSize',0)
hold off
set(gca,'XTickLabel',[])
figQuality(gcf,gca,[2,2.7]);


