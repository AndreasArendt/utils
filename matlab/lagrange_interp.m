function p = lagrange_interp(x, y, x_eval)
% Lagrange Interpolation
% Note: This version is faster than with vectorization!

    assert(numel(x) == numel(y), 'x and y must have the same length');
    
    p = 0;
    for ii = 1:numel(x)
        L = 1;
        for jj = 1:numel(x)
            % skip this term
            if jj == ii
                continue;
            end

            L = L * (x_eval-x(jj))/(x(ii)-x(jj));
        end
        
        p = p + y(ii)*L;
    end
end