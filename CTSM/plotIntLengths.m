% edited 20180309 CLC - added individual points (average per axon)
function [int_p,int_tbl,int_stats,int_comparison] = plotIntLengths(PLM)
    xNames = {'PV','VM','PO','SOM','RBP4','NXPH4'};
    avgData = NaN(length(xNames),1);
    sem = NaN(length(xNames),1);
    allData = NaN(78,length(xNames));
    for i = 1:length(xNames)
        avgData(i) = mean(PLM.(xNames{i}).cmbdIntData,'omitnan');
        allData(1:length(PLM.(xNames{i}).cmbdIntData),i) = PLM.(xNames{i}).cmbdIntData;
        sem(i) = calcSEM(PLM.(xNames{i}).cmbdIntData,1);
    end
    [vm, pv, po, som, rbp4, nxph4, ~] = CTSMcolors;
    color = {pv, vm, po, som, rbp4, nxph4};
    for i = 1:length(xNames)
        nandex = isnan(PLM.(xNames{i}).cmbdIntData);
        data{i} = PLM.(xNames{i}).cmbdIntData(~nandex);
    end
    
    figure
    p = plotSpread(data,'xNames',xNames,'distributionMarker','o','distributionColor',color);
    hold on
    set(p{1},'MarkerSize',5);
    set(p{1},'LineWidth',1);
    errorbar(avgData,sem,'ko','MarkerSize',5,'MarkerFaceColor','w','LineWidth',1.5)
    hold off
    set(gca,'XTickLabel',xNames);
    ylabel('Average internode length (\mum)');
    set(gca,'XTickLabelRotation',45)
    figQuality(gcf,gca,[3 2.7])
    
    [int_p,int_tbl,int_stats] = anova1(allData);
    int_comparison = multcompare(int_stats,'CType','dunn-sidak');
end