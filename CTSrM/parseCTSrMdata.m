function [data,p,ks2stat] = parseCTSrMdata(PLMpv,PLMvm,datasham,shamlim)
[vmcolor,pvcolor] = CTSMcolors;
data = struct;
data.pv = [];
data.vm = [];
for k = 1:2
    if k==1
        PLM = PLMvm;
        type = 'vm';
    else
        PLM = PLMpv;
        type = 'pv';
    end
    allDeltaM = [];
    allDeltaV = [];
    allLnthsM = [];
    allLnthsV = [];
    allDeltaV_0s = [];
    idx = [];
    reg = fieldnames(PLM);
    for r = 1:length(reg)
        fields = fieldnames(PLM.(reg{r}));
        delta = PLM.(reg{r}).(fields{3});
        lnths = PLM.(reg{r}).(fields{2}).totalAxonLength;
        bsln = PLM.(reg{r}).(fields{1});
        r5wk = PLM.(reg{r}).(fields{2});
        survIdx = NaN(length(r5wk.axonName),1);
        for i=1:length(r5wk.axonName)
            survIdx(i) = find(~cellfun(@isempty,strfind(bsln.axonName,r5wk.axonName{i})));
        end
        allDeltaV_0s = [allDeltaV_0s; delta];
        delta(bsln.percentMyelin(survIdx)==0 & r5wk.percentMyelin==0) = [];
        lnths(bsln.percentMyelin(survIdx)==0 & r5wk.percentMyelin==0) = [];
        
        allDeltaV = [allDeltaV; delta];
        allLnthsV = [allLnthsV; lnths];
        idx = [idx; r.*ones(size(delta))];
        if r==1
            allDeltaM = delta;
            allLnthsM = lnths;
        else
            [allDeltaM, delta] = forceConcat(allDeltaM,delta,1);
            allDeltaM = [allDeltaM,delta];
            [allLnthsM, lnths] = forceConcat(allLnthsM,lnths,1);
            allLnthsM = [allLnthsM,lnths];
        end
    end
    allDeltaV(allDeltaV<-100) = -100;
    allDeltaM(allDeltaM<-100) = -100;
    allDeltaV(allDeltaV>100) = 100;
    allDeltaM(allDeltaM>100) = 100;
    data.(type).allDeltaM = allDeltaM;
    data.(type).allDeltaV = allDeltaV;
    data.(type).allLnthsM = allLnthsM;
    data.(type).allLnthsV = allLnthsV;
    data.(type).allDeltaV_0s = allDeltaV_0s;
    figure
    plot([0 13],[0 0],'k-','LineWidth',0.3)
    hold on
    if k==1
        color = repmat({vmcolor},length(reg),1);
        if nargin>2
            plot([0 13],[-shamlim(2) -shamlim(2)],'k--','LineWidth',0.3)
            plot([0 13],[shamlim(2) shamlim(2)],'k--','LineWidth',0.3)
            shamdata = datasham.vm.allDeltaM;
            lim = [0 0.5];
            ttl = 'VM';
        end
    else
        color = repmat({pvcolor},length(reg),1);
        if nargin>2
            plot([0 13],[-shamlim(1) -shamlim(1)],'k--','LineWidth',0.3)
            plot([0 13],[shamlim(1) shamlim(1)],'k--','LineWidth',0.3)
            shamdata = datasham.pv.allDeltaM;
            lim = [0 0.5];
            ttl = 'PV';
        end
    end
    plotSpread(allDeltaV,'distributionIdx',idx,'distributionMarkers',{'o'},'distributionColors',color);
    violin(allDeltaM,'facecolor',[1 1 1],'facealpha',0,'mc',[],'medc',[]);
    hold off
    ylim([-100 100])
    ylabel('change in PLM')
    xlabel('region')
    figQuality(gcf,gca,[4 3])
    
    if nargin > 2
        shambins = [];
        for i = 1:size(shamdata,2)
            temp = histcounts(shamdata(:,i),-100:10:100);
            shambins = [shambins; temp./sum(temp)];
        end
        cuprbins = [];
        for i = 1:size(allDeltaM,2)
            temp = histcounts(allDeltaM(:,i),-100:10:100);
            cuprbins = [cuprbins; temp./sum(temp)];
        end
        cupravg = mean(cuprbins,1);
        shamavg = mean(shambins,1);
        avg = [cupravg; shamavg];
        sem = [calcSEM(cuprbins,1); calcSEM(shambins,1)];
        
        [ct,cu] = getFigColors;
        figure
        [b,e] = errorbarbar(avg',sem');
        b(1).FaceColor = cu;
        b(1).BarWidth = b(1).BarWidth .* 2;
        b(2).FaceColor = ct;
        e(1).Color = 'k';
        e(2).Color = 'k';
        e(1).CapSize = 2;
        e(2).CapSize = 2;
        ylim(lim)
        title(ttl)
        xlim([0 20])
        xticks(0:2:20)
        xticklabels(-100:20:100)
        figQuality(gcf,gca,[5 2.7])
        
        [~,p{k},ks2stat{k}] = kstest2(cupravg,shamavg,'Tail','smaller')
        if k==1
            vmcupravg = cupravg;
            vmshamavg = shamavg;
        end
    end
end

figure
d = [data.pv.allDeltaV; data.vm.allDeltaV];
idx = [ones(size(data.pv.allDeltaV)); 2.*ones(size(data.vm.allDeltaV))];
[pv,vm] = forceConcat(data.pv.allDeltaV, data.vm.allDeltaV);
v = [pv vm];
hold on
plotSpread(d,'distributionIdx',idx,'distributionMarkers',{'o'},'distributionColors',{pvcolor,vmcolor});
violin(v,'facecolor',[1 1 1],'facealpha',0,'mc',[],'medc',[]);
if nargin > 2
    plot([0.6 1.4],[-shamlim(1) -shamlim(1)],'k--','LineWidth',0.6)
    plot([0.6 1.4],[shamlim(1) shamlim(1)],'k--','LineWidth',0.6)
    plot([1.6 2.4],[-shamlim(2) -shamlim(2)],'k--','LineWidth',0.6)
    plot([1.6 2.4],[shamlim(2) shamlim(2)],'k--','LineWidth',0.6)
end
plot([0 3],[0 0],'k-','LineWidth',0.3)
hold off
ylim([-100 100])
xticklabels({'PV' 'VM'})
ylabel({'change in PLM'})
figQuality(gcf,gca,[3 2.7])
% [~,pPooled] = kstest2(vm,pv)
if nargin > 2
    [~,p{3},ks2stat{3}] = kstest2(cupravg,vmcupravg)
end

end

