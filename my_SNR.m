function [ noise_with_SNR ] = my_SNR(signal , noise , SNR)
%function gets signal, noise and desired SNR 
%function outputs the noise with reduced SNR to match desired
signal_RMS = sqrt(mean(signal.^2));            %calculating the signal RMS
noise_RMS = sqrt(mean(noise.^2));              %calculating the noise RMS
desired_noise_RMS = signal_RMS/(10^(SNR/20));  %this needs to be RMS of noise(math calculations)
factor_RMS = desired_noise_RMS/noise_RMS;      %this is the factor difference
noise_with_SNR = factor_RMS*noise;             %noise with right RMS
end

