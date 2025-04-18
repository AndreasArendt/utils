function [x, P, res] = lls(A, y, options)

    % Parse input arguments and set default values
    arguments
        A double                  % Design matrix
        y double                  % Observation vector
        options.R double = eye(size(y, 1)) % Weight matrix, defaults to identity
    end
    
    % Input validation
    [m, ~] = size(A); % Dimensions of A
    assert(size(y, 1) == m, 'The number of rows in A must match the length of y.')
    assert(isequal(size(options.R),  [m, m]), 'The weight matrix R must be square and of size equal to the number of rows in A.')
    
    % Compute the weighted least squares solution
    R_inv = options.R \ eye(size(options.R)); % Numerically stable computation of R_inv
    normal_matrix = A' * R_inv * A;           % Normal matrix
    x = normal_matrix \ (A' * R_inv * y);     % Solve normal equations with stabilityend

    % Compute covariance matrix
    P = inv(normal_matrix);          % Covariance of the estimated parameters

    % Comput residuals
    res = A * x - y;
end