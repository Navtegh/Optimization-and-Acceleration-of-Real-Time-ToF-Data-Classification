function net = lstm_ap(x_train, x_val, y_train, y_val,num_pca)
    numHiddenUnits = 100;
    numClasses = 5;
    layers = [ ...
    sequenceInputLayer(num_pca)
    bilstmLayer(numHiddenUnits,OutputMode="last")
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
    
    options = trainingOptions('adam',...    
        'InitialLearnRate',0.08,... 
        'LearnRateSchedule', 'piecewise',... 
        'LearnRateDropFactor', 0.65,...
        'LearnRateDropPeriod', 1,...    
        'MaxEpochs',5,...           
        'MiniBatchSize', 800,...  
        'Shuffle', 'every-epoch',...
        'ValidationData', {x_val, y_val},...
        'ValidationFrequency', 500, ...
        'ValidationPatience', 5, ...
        'VerboseFrequency', 500, ...
        'plots','training-progress',...
        'ExecutionEnvironment','auto');

    
    
    net = trainNetwork(x_train, y_train, layers, options);

    

end