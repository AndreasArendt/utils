function L = gauss(data, sigma)    
    % pre‑compute constant part
    c = 1 / sqrt((2*pi*sigma)^size(data,1));

    % Mahalanobis distance norm(x)^2 / sigma
    quad = sum(data.^2, 1) / sigma;

    % element‑wise exponential
    L = c .* exp(-0.5 * quad);
end