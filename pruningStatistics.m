function [sparsityPerLayer,prunedChannelsPerLayer,numOutChannelsPerLayer,layerNames] = pruningStatistics(dlnet)

layerNames = unique(dlnet.Learnables.Layer,'stable');
numLayers = numel(layerNames);
layerIDs = zeros(numLayers,1);
for idx = 1:numel(layerNames)
    layerIDs(idx) = find(layerNames(idx)=={dlnet.Layers.Name});
end

sparsityPerLayer = zeros(numLayers,1);
prunedChannelsPerLayer = zeros(numLayers,1);
numOutChannelsPerLayer = zeros(numLayers,1);

numParams = zeros(numLayers,1);
numPrunedParams = zeros(numLayers,1);
for idx = 1:numLayers
    layer = dlnet.Layers(layerIDs(idx));
    
    % Calculate the sparsity
    paramIDs = strcmp(dlnet.Learnables.Layer,layerNames(idx));
    paramValue = dlnet.Learnables.Value(paramIDs);
    for p = 1:numel(paramValue)
        numParams(idx) = numParams(idx) + numel(paramValue{p});
        numPrunedParams(idx) = numPrunedParams(idx) + nnz(extractdata(paramValue{p})==0);
    end

    % Calculate channel statistics
    sparsityPerLayer(idx) = numPrunedParams(idx)/numParams(idx);
    switch class(layer)
        case "nnet.cnn.layer.FullyConnectedLayer"
            numOutChannelsPerLayer(idx) = layer.OutputSize;
            prunedChannelsPerLayer(idx) = nnz(all(layer.Weights==0,2)&layer.Bias(:)==0);
        case "nnet.cnn.layer.Convolution2DLayer"
            numOutChannelsPerLayer(idx) = layer.NumFilters;
            prunedChannelsPerLayer(idx) = nnz(reshape(all(layer.Weights==0,[1,2,3]),[],1)&layer.Bias(:)==0);
        case "nnet.cnn.layer.GroupedConvolution2DLayer"
            numOutChannelsPerLayer(idx) = layer.NumGroups*layer.NumFiltersPerGroup;
            prunedChannelsPerLayer(idx) = nnz(reshape(all(layer.Weights==0,[1,2,3]),[],1)&layer.Bias(:)==0);
        case "nnet.cnn.layer.BatchNormalizationLayer"
        otherwise
            error("Unknown layer: "+class(layer))
    end
end
end