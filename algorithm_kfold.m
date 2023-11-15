function bestNet = algorithm_kfold(x_train, x_val, y_train, y_val,num_pca)
y = y_train;
x = x_train;
numFolds = 3;
c = cvpartition(y,'k',numFolds);
% table to store the results 
netAry = {numFolds,1};
perfAry = zeros(numFolds,1);
for i = 1:numFolds
    
    %get Train and Test data for this fold
     trIdx = c.training(i);
     teIdx = c.test(i);
     xTrain = x(trIdx);
     yTrain = y(trIdx);
     xTest = x(teIdx);
     yTest = y(teIdx);
     
     %transform data to columns as expected by neural nets
     xTrain = xTrain';
     xTest = xTest';
     yTrain = dummyvar(grp2idx(yTrain))';
     yTest = dummyvar(grp2idx(yTest))';
     
     %create net and set Test and Validation to zero in the input data
     net = patternnet(10);
     net.divideParam.trainRatio = 1;
     net.divideParam.testRatio = 0;
     net.divideParam.valRatio = 0;
     
     %train network
     net = train(net,xTrain,yTrain);
     yPred = net(xTest);
     perf = perform(net,yTest,yPred);
     disp(perf);
     
     %store results     
     netAry{i} = net;
     perfAry(i) = perf;
     
end
%take the network with min Loss value
[maxPerf,maxPerfId] = min(perfAry);
bestNet = netAry{maxPerfId};