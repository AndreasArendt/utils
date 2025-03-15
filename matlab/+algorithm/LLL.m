function B = LLL(B, options)
%% Lenstra–Lenstra–Lovász (LLL) lattice basis reduction algorithm
% Take care: it might not work correctly for complex numbers!

    arguments(Input)
        B
        options.delta (1,1) double = 0.75
    end
    
    N = size(B,2);
    kk = 2;
    
    % Gram Schmid coefficients
    proj = @(u,v)(dot(v, u) / norm(u)^2);
    
    [B_star, ~] = algorithm.GramSchmid(B);
    
    while kk <= N
        % Size reduction - ensure |mu| <= 0.5
        for jj = kk-1:-1:1
            mu = proj(B_star(:,jj), B(:,kk));
    
            if abs(real(mu)) > 0.5 || abs(imag(mu)) > 0.5
                B(:,kk) = B(:,kk) - round(mu) * B(:,jj);
                [B_star, ~] = algorithm.GramSchmid(B); %naive method
            end
        end
    
        mu_tmp = proj(B_star(:,kk-1), B(:,kk));
    
        bb_k  = norm(B_star(:,kk))^2;
        bb_k1 = norm(B_star(:,kk-1))^2;
    
        % Lovasz condition check        
        if bb_k > (options.delta - abs(mu_tmp)^2) * bb_k1
            kk = kk+1;
        else
            b_tmp = B(:,kk);
            B(:,kk) = B(:,kk-1);
            B(:,kk-1) = b_tmp;
            [B_star, ~] = algorithm.GramSchmid(B); %naive method
            kk = max([kk-1,2]);
        end
    end
end