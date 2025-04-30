function [Theta, res] = LevenbergMarquardt(J, F, Z, x0, options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% J:= Jacobian Matrix
% F:= Optimization Function

arguments(Input)
    J
    F
    Z
    x0
    options.beta = 0.1;
    options.alpha = 5;
    options.tol = 1e-6;
    options.maxIter = 1000;
    options.verbose = true;
end

Theta = x0;

for ii = 1:options.maxIter
    cost_old = norm(F(Z,Theta))^2;
    dx = -options.alpha * (J(Z,Theta).'*J(Z,Theta) + options.beta*eye(numel(Theta))) \ J(Z,Theta).' * F(Z,Theta);
    x_new = Theta + dx;
    cost_new = norm(F(Z, x_new))^2;

    if cost_new < cost_old
        Theta = x_new;
        options.beta = options.beta / options.alpha;

        if norm(dx) < options.tol
            break;
        end
    else
        options.beta = options.beta * options.alpha;
    end
end

res = F(Z, Theta);

if options.verbose
    fprintf('Stopped after %d iterations\n', ii);
    fprintf('Tolerance %.9f\n', norm(dx));
end