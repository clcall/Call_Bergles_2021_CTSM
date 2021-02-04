function barWithPoints(data,colors,conditionNames,subVarNames,figDim)
% data: struct of matrices ixj where i = subject and j = sub-variables, 
%       e.g. replicates/time-points/layers
% colors: cell array of RGB matrices or color characters, e.g. 'k', arranged
%       in same order of conditions in 'data'
% conditionNames: 1xc cell array of strings of each condition represented in
%       data arranged in same order as in data, where c = number of conditions.
%       If left empty, fieldnames of 'data' will be used
% subVarNames: 1xc cell array of strings for each variable within a
%       condition arranged in same order of data, where c = number of
%       conditions.
% figDim: 2-element matrix [height,width] in inches

fields = fieldnames(data);
if isempty(conditionNames)
    conditionNames = fields;
end
numConditions = length(fields);
numSubVar = size(data.(fields{1}),2);
coloridx = repmat(colors,1,numSubVar);
avg = NaN(length(fields),numSubVar);
sem = NaN(length(fields),numSubVar);
y = [];
numSubjects = zeros(1,numConditions);
for f = 1:length(fields)
    avg(f,:) = mean(data.(fields{f}),1,'omitnan');
    sem(f,:) = calcSEM(data.(fields{f}),1);
%     if f < length(fields)
%         [a, ~] = forceConcat(data.(fields{f}), data.(fields{f+1}), 1);
%     end
    y = [y; data.(fields{f})(:)];
    numSubjects(f) = size(data.(fields{f}),1);
end
y(y<0) = 0; % TEMP TO CORRECT PLOTCURVES ISSUE WAY UPSTREAM DURING BINNING
figure
xes = repmat(1:numSubVar, numConditions, 1);
[b,e] = errorbarbar(xes',avg',sem',{'EdgeColor','k','FaceColor','none'},{'k','LineStyle','none'});
% numSubjects = size(data.(fields{1}),1);
idx = NaN(size(y));
count = 0;
ticks = xes(1,:);
for i = 1:numConditions
    xoff = get(b(i),'XOffset');
    for j = 1:numSubVar
        idx(count+1:numSubjects(i)+count) = ones(numSubjects(i),1).*(ticks(j) + xoff);
        count = count + numSubjects(i);
    end
end
hold on
plotSpread(y,'distributionIdx',idx,'distributionMarkers',{'o'},'distributionColors',coloridx);
xticks(xes(1,:))
xticklabels(subVarNames)
hold off
figQuality(gcf,gca,figDim)