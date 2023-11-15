
classes=["Bubble Wrap", 
     "Crepe Paper", 
     "Foam Board", 
     "Polystyrene", 
     "Wax"];

layers=[softmaxLayer("Name","softmax")
         classificationLayer('classes',classes,"Name","classoutput")];
lgraph=layerGraph(prunedDLNet.Layers);
lgraph=addLayers(lgraph,layers);
lgraph=connectLayers(lgraph,'fc_3','softmax');
figure
plot(lgraph)