analyzeNetwork(network);
inputSize=network.Layers(1).InputSize;

augimdsTrain = augmentedImageDatastore(inputSize,x_train,y_train);
augimdsCalibration = shuffle(augimdsTrain).subset(1:200);

augimdsValidation = augmentedImageDatastore(inputSize,x_val,y_val);
augimdsValidation = shuffle(augimdsValidation).subset(1:50);