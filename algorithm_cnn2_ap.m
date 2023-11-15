function net = algorithm_cnn2_ap(x_train, x_val, y_train, y_val,num_pca)

    layers = [
         imageInputLayer([8 9 1 ],"Name","imageinput")
         batchNormalizationLayer("Name","batchnorm_1")

         convolution2dLayer([3 3],4,"Name","conv_1","Padding","same")
         batchNormalizationLayer("Name","batchnorm_2")
         reluLayer("Name","relu_1")
    
         convolution2dLayer([3 3],8,"Name","conv_2","Padding","same")
         batchNormalizationLayer("Name","batchnorm_3")
         reluLayer("Name","relu_2")
         %dropoutLayer(0.1)
    
         convolution2dLayer([3 3],16,"Name","conv_3","Padding","same")
         batchNormalizationLayer("Name","batchnorm_4")
         reluLayer("Name","relu_3")

         % convolution2dLayer([1 4],16,"Name","conv_4","Padding","same")
         % batchNormalizationLayer("Name","batchnorm_5")
         % reluLayer("Name","relu_4")
         % %dropoutLayer(0.1)
         % fullyConnectedLayer(16,"Name","fc_1")
         fullyConnectedLayer(32,"Name","fc_1")
         batchNormalizationLayer("Name","batchnorm_6")
         reluLayer("Name","relu_5")
         fullyConnectedLayer(16,"Name","fc_2")
         batchNormalizationLayer("Name","batchnorm_7")
         reluLayer("Name","relu_6")
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