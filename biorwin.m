function win=biorwin(wins,dM,dN)
wins=wins(:); L=length(wins); N=L/dN;
win=zeros(L,1);
mu=zeros(2*dN-1,1);
mu(1)=1;
for k=1:dM
    H=zeros(2*dN-1,ceil((L-k+1)/dM));
    for q=0:2*dN-2
        h=shiftcir(wins,q*N);
        H(q+1,:)=h(k:dM:L)';
    end
    win(k:dM:L)=pinv(H)*mu;
end

