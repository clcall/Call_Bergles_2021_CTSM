% edited CLC 20180306 - added commented code for optional high-pass filter
function [mdls,axon_p,axon_tbl,axon_stats,axon_comparisons] = plotAxonLengths(PLM)
    xNames = {'PV','VM','PO','SOM','RBP4','NXPH4','NTSR1'};
    % Currently largest number of axons is 78 (rbp4)
    data = NaN(78,7);
    plmdata = data;
    mdls = {};
    % HIGH PASS FILTER OPTION
%     for i = 1:length(xNames)
%         lnth = length(PLM.(xNames{i}).cmbdAxData(PLM.(xNames{i}).cmbdAxData<300));
%         data(1:lnth,i) = PLM.(xNames{i}).cmbdAxData(PLM.(xNames{i}).cmbdAxData<300);
%     end

%     figure
%     hold on
    [vm, pv, po, som, rbp4, nxph4, ntsr1] = CTSMcolors;
    color = {pv, vm, po, som, rbp4, nxph4, ntsr1};
    for i = 1:length(xNames)
        lnth = length(PLM.(xNames{i}).cmbdAxData);
        data(1:lnth,i) = PLM.(xNames{i}).cmbdAxData;
        plmdata(1:lnth,i) = PLM.(xNames{i}).cmbdData;
%         scatter(PLM.(xNames{i}).cmbdAxData,PLM.(xNames{i}).cmbdData,ones(lnth,1).*30,repmat(color{i},lnth,1));
        mdls{i} = fitlm(PLM.(xNames{i}).cmbdAxData,PLM.(xNames{i}).cmbdData);
        if mdls{i}.Coefficients.pValue(2) < 0.05
            figure
            plot(mdls{i})
            title([xNames{i} ' p = ' num2str(mdls{i}.Coefficients.pValue(2))])
        end
    end
%     hold off
    
    figure
    p = plotSpread(data,'xNames',xNames,'distributionMarker','o','distributionColor',color);
    hold on
    set(p{1},'MarkerSize',3);
    set(p{1},'LineWidth',1);
    ylabel('Axon length traced (\mum)')
    set(gca,'XTickLabelRotation',45)
    figQuality(gcf,gca,[3 2.7])
    hold off
    
    [axon_p,axon_tbl,axon_stats] = kruskalwallis(data);
    axon_comparisons = multcompare(axon_stats,'CType','dunn-sidak');
    
end