% edited CLC 20180308 - changed y lim
function [avgData,sem,tbl,comparison] = plotPropMyel(PLM)
    xNames = {'PV','VM','PO','SOM','RBP4','NXPH4','NTSR1'};
    data = NaN(length(xNames),5);
    sem = NaN(1,length(xNames));
    avgData = sem;
    for i = 1:length(xNames)
        fields = fieldnames(PLM.(xNames{i}));
        for j = 1:(length(fields)-3)
            temp = PLM.(xNames{i}).(fields{j}).percentMyelin;
            data(i,j) = nnz(temp)/length(temp);
        end
        sem(i) = calcSEM(data(i,:),2);
        avgData(i) = mean(data(i,:),'omitnan');
    end
    [vm, pv, po, som, rbp4, nxph4, ntsr1] = CTSMcolors;
    color = {pv, vm, po, som, rbp4, nxph4, ntsr1};
    figure
    p = plotSpread(data','xNames',xNames,'distributionMarker','o','distributionColor',color);
    hold on
    set(p{1},'MarkerSize',5);
    set(p{1},'LineWidth',1);
    errorbar(avgData,sem,'ko','MarkerSize',5,'MarkerFaceColor','w','LineWidth',1.5)
    hold off
    set(gca,'XTickLabel',xNames);
    ylabel('Proportion of axons myelinated');
    ylim([0 1])
    ytickformat('%.1f')
    set(gca,'XTickLabelRotation',45)
    figQuality(gcf,gca,[3 2.7])
    
    [~,tbl,stats] = anova1(data');
    comparison = multcompare(stats,'CType','dunn-sidak');
end