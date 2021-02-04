function plotArealHisto(arealPLM)
    figure
    subplot(1,3,1)
    generateHisto('SS',arealPLM);

    subplot(1,3,2)
    generateHisto('AUD',arealPLM);
    
    subplot(1,3,3)
    generateHisto('VIS',arealPLM);
    
    figQuality(gcf,gca,[6 4])
end

function generateHisto(name,arealPLM)
    if contains(name,'SS')
        RGB = [1.0   0.3   0.3];
    elseif contains(name,'AUD')
        RGB = [1.0   0.3   0.3];
    elseif contains(name,'VIS')
        RGB = [1.0   0.3   0.3];
    end
    histogram(arealPLM.(name).cmbdData,'Normalization','probability','BinWidth',10,'BinLimits',[0,100],'FaceColor',RGB,'FaceAlpha',1);
    axis([0 100 0 1])
    title(name)
%     if contains(name, 'RBP4')
%         xlabel('Percent of Axon Length Myelinated','FontSize',11,'FontWeight','bold');
%     end
    %ylabel('Number of Axons');
    %y max normalized?
end