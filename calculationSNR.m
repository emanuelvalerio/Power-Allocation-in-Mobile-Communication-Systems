% Functio to calculate the Signal-To-Noise-Ratio of each subcarrieries
function SNR = calculationSNR(csi,powerNoise)
    SNR = (csi.^2)/(powerNoise);
end