function y = normpdf2(x, mu, sigma)
  
if nargin < 3, 
    sigma = 1;
end

if nargin < 2;
    mu = 0;
end

if nargin < 1, 
    error('Requires at least one input argument.');
end

[errorcode x mu sigma] = distchck(3,x,mu,sigma);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize Y to zero.
y = zeros(size(x));

k = find(sigma > 0);
if any(k)
    xn = (x(k) - mu(k)) ./ sigma(k);
    f   = exp(-0.5.*xn.^2)./(sigma(k).*sqrt(2*pi));
    y(k)  = -(1-xn.^2).*f;
end

% Return NaN if SIGMA is negative or zero.
k1 = find(sigma <= 0);
if any(k1)
    tmp   = NaN;
    y(k1) = tmp(ones(size(k1))); 
end
