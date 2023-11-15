function net = algorithm_cnn5_new(x_train, x_val, y_train, y_val, num_pca)

    layers = [
         imageInputLayer([1 num_pca 1],"Name","imageinput")
         batchNormalizationLayer("Name","batchnorm_1")

         convolution2dLayer([1 4],8,"Name","conv_1","Padding","same")
         batchNormalizationLayer("Name","batchnorm_2")
         reluLayer("Name","relu_1")
    
         convolution2dLayer([1 4],16,"Name","conv_2","Padding","same")
         batchNormalizationLayer("Name","batchnorm_3")
         reluLayer("Name","relu_2")
         dropoutLayer(0.3)
    
         convolution2dLayer([1 4],32,"Name","conv_3","Padding","same")
         batchNormalizationLayer("Name","batchnorm_4")
         reluLayer("Name","relu_3")
    
         fullyConnectedLayer(16,"Name","fc_1")
         batchNormalizationLayer("Name","batchnorm_5")
         reluLayer("Name","relu_4")
         fullyConnectedLayer(16,"Name","fc_2")
         batchNormalizationLayer("Name","batchnorm_6")
         reluLayer("Name","relu_5")
         fullyConnectedLayer(numel(unique(y_train)),"Name","fc_3")
         softmaxLayer("Name","softmax")
         classificationLayer("Name","classoutput")
         ];
    
    options = trainingOptions('adam',...    
        'InitialLearnRate',0.08,... 
        'LearnRateSchedule', 'piecewise',... 
        'LearnRateDropFactor', 0.65,...
        'LearnRateDropPeriod', 1,...    
        'MaxEpochs',10,...           
        'MiniBatchSize', 2000,...  
        'Shuffle', 'every-epoch',...
        'ValidationData', {x_val, y_val},...
        'ValidationFrequency', 500, ...
        'ValidationPatience', 5, ...
        'VerboseFrequency', 500, ...
        'plots','training-progress',...
        'ExecutionEnvironment','auto');
    
    net = trainNetwork(x_train, y_train, layers, options);

end