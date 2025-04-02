function [X_RTS, P_RTS] = rts(X_pri, X_post, F, P_pri, P_post)
%RTS - Rauch-Tung-Striebel Smoother for fixed interval smoothing
%  X needs to be a row vector of states (as columns)
% _pri  - is after prediction
% _post - is after correction

    nEstimation = size(X,1);
    nStates     = size(X,2);

    P_RTS = NaN(nStates,nStates,nEstimation);
    X_RTS = NaN(nEstimation,nStates);
    
    P_RTS(:,:,end) = kf.P;
    X_RTS(end,:)   = kf.X.';
    
    for k = nEstimation-1:-1:1       
        C_k = (P_post(:,:,k) * F.') / P_pri(:,:,k+1);
        P_RTS(:,:,k) = P_post(:,:,k) - C_k * (P_pri(:,:,k+1) - P_RTS(:,:,k+1)) * C_k.';
        X_RTS(k,:) = (X_post(k,:).' + C_k * (X_RTS(k+1,:)' - X_pri(k+1,:).')).';
    end
end

