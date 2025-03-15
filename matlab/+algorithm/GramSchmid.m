function [u, e] = GramSchmid(v)
%% Gram-Schmid algorithm
% Finding Set of vectors that are perpendicular to each other

    u = NaN(size(v));
    e = NaN(size(v));

    % column vectors
    N = numel(v(1,:));

    proj = @(u,v)(u .* (dot(v, u) ./ dot(u,u)));
    
    % iterate over each column vector
    for kk = 1:N

        if kk == 1
            u(:,kk) = v(:,kk);            
        else
            V = repmat(v(:,kk), 1, kk-1);
            U = u(:,1:kk-1);
            u(:,kk) = v(:,kk) - sum(proj(U, V), 2);        
        end
        
        e(:,kk) = u(:,kk) / norm(u(:,kk));
    end
end