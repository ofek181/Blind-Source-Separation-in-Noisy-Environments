function tfmat=tfanalysis(x,awin,timestep,numfreq)
x = x(:) ; awin = awin(:); % make inputs go columnwise
nsamp = length(x); wlen = length(awin);
% calc size and init output t?f matrix
numtime = ceil((nsamp-wlen+1)/timestep);
tfmat = zeros(numfreq,numtime+1);
for i = 1:numtime
    sind = ((i-1)*timestep)+1;
    tfmat(:,i) = fft(x(sind:(sind+wlen-1)).*awin,numfreq);
end
i = i +1;
sind = ((i-1)*timestep)+1;
lasts = min(sind,length(x));
laste = min((sind+wlen-1),length(x));
tfmat(:,end) = fft([x(lasts:laste) ;zeros(wlen-(laste-lasts+1),1)].*awin,numfreq);