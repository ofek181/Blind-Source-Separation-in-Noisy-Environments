function x = tfsynthesis(timefreqmat,swin,timestep,numfreq)
swin = swin (:); % make synthesis window go columnwise
winlen = length(swin);
[numfreq numtime] = size(timefreqmat);
ind = rem((1:winlen)-1,numfreq)+1;
x = zeros((numtime-1)*timestep+winlen,1);
for i = 1:numtime % overlap, window, and add
    temp = numfreq*real(ifft(timefreqmat(:,i)));
    sind = ((i-1)*timestep);
    rind = (sind+1):(sind+winlen);
    x(rind) = x(rind)+temp(ind).*swin;
end