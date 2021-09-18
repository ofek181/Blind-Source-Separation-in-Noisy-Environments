function [Pr] = NC(z , mx , Rx)
J =8;
nu = trace(Rx);
factor = eye(J)*nu*1e-4;
Pr = exp(-(z-mx)'*(eye(J)/(Rx+factor))*(z-mx));
end

