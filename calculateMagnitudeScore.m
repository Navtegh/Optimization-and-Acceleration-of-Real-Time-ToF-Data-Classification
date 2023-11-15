function score = calculateMagnitudeScore(dlnet)
score = dlupdate(@abs,dlnet.Learnables);
end