%% PLOT HISTOGRAMS
% edited 20180306
function plotHisto(PLM)
    figure
    subplot(3,2,1)
    generateHisto('PV',PLM);

    subplot(3,2,2)
    generateHisto('VM',PLM);
    
    subplot(3,2,3)
    generateHisto('PO',PLM);
    
    subplot(3,2,4)
    generateHisto('SOM',PLM);
     
    subplot(3,2,5)
    generateHisto('RBP4',PLM);
    
    subplot(3,2,6)
    generateHisto('NXPH4',PLM);
    
    figQuality(gcf,gca,[4.5 6.5])
    
%     ytext = text(-330,50,'Number of Axons');
%     set(ytext,'Rotation',90)
%     set(ytext,'FontSize',13)
%     set(ytext,'FontWeight','bold')
%     set(ytext,'FontName','Arial')
%     
%     xtext = text(-190,-12,'Percent of Axon Length Myelinated');
%     set(xtext,'FontSize',13)
%     set(xtext,'FontWeight','bold') 
%     set(xtext,'FontName','Arial')
end

function generateHisto(name,PLM)
    [vm, pv, po, som, rbp4, nxph4, ntsr1] = CTSMcolors;
    if contains(name,'VM')
        RGB = vm;
    elseif contains(name,'PV')
        RGB = pv;
    elseif contains(name,'PO')
        RGB = po;
    elseif contains(name,'SOM')
        RGB = som;
    elseif contains(name,'RBP4')
        RGB = rbp4;
    elseif contains(name,'NXPH4')
        RGB = nxph4;
    end
    histogram(PLM.(name).cmbdData,'Normalization','probability','BinWidth',10,'BinLimits',[0,100],'FaceColor',RGB,'FaceAlpha',1);
    title(name)
    axis([0 100 0 1])
    ytickformat('%.1f')
    box off
%% sanity check: distributions for axons only <500 microns
% fields = fieldnames(PLM.(name));
% data=[];
% for f = 1:(length(fields)-3)
%     temp = PLM.(name).(fields{f}).totalAxonLength;
%     idx = temp<500;
%     data = [data; PLM.(name).(fields{f}).percentMyelin(idx)];
% end
% histogram(data,'Normalization','probability','BinWidth',10,'BinLimits',[0,100],'FaceColor',RGB,'FaceAlpha',1);
end