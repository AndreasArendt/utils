function p = gauss(data)    
    mu    = mean(data);
    sigma = diag(var(data));
    k = numel(mu);
    p = (2*pi)^(-k/2) * det(sigma)^-0.5 * exp(-0.5 * sum((data / sigma) .* data, 2));
end