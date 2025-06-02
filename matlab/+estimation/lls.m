function [x, P, res] = lls(A, y, options)

    % Parse input arguments and set default values
    arguments
        A double                                % Design matrix
        y double                                % Observation vector
        options.R double = eye(size(y, 1))      % Weight matrix, defaults to identity
        options.cond_thresh = 1e10              % Threshold for condition number
        options.regularize (1,1) logical = true % Enable Tikhonov regularization if ill-conditioned by default
        options.lambda (1,1) double = 1e-3      % Tikhonov Regularization strength
    end
    
    % Input validation
    [m, n] = size(A); % Dimensions of A
    assert(size(y, 1) == m, 'The number of rows in A must match the length of y.')
    assert(isequal(size(options.R),  [m, m]), 'The weight matrix R must be square and of size equal to the number of rows in A.')
    
    % Compute the weighted least squares solution
    R_inv = options.R \ eye(size(options.R)); % Numerically stable computation of R_inv
    normal_matrix = A' * R_inv * A;           % Normal matrix
    
    % Check condition number
    cond_num = cond(normal_matrix);
    if cond_num > options.cond_thresh
        warning('Matrix is ill-conditioned: cond = %.2e', cond_num);
        if options.regularize
            warning('Applying Tikhonov regularization with lambda = %.1e', options.lambda);
            normal_matrix = normal_matrix + options.lambda * eye(n);
        end
    end
    
    x = normal_matrix \ (A' * R_inv * y);     % Solve normal equations with stabilityend

    % Compute covariance matrix
    if nargout >= 2
        P = inv(normal_matrix);
    end

    % Comput residuals
    if nargout >= 3        
        res = A * x - y;
    end
end