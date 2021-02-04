axNames = {'PV','VM','SOM','PO','RBP4','NXPH4'};
Data = [];
for i = 1:length(axNames)
    fields = fieldnames(PLM.(axNames{i}));
    for k = 1:(length(fields)-3)
        data = PLM.(axNames{i}).(fields{k}).percentMyelin;
        sd = std(data);
        avg = mean(data);
        cv = sd/avg*100;
        Data(k,i) = cv;
    end
end