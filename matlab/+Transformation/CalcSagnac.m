function dist = CalcSagnac(xyz_sv, xyz_rx)
    % Sagnac (rx - sv) \dot ([0;0;w] x sv)
    N = size(xyz_sv,1);
    dist = zeros(N,1);

    w = Transformation.MeanAngularVelocityOfEarth__radDs();

    for ii = 1:N                    
        dist(ii) = dot(xyz_rx - xyz_sv(ii,:), cross([0,0,w], xyz_sv(ii,:))) / Transformation.SpeedOfLight__mDs();
    end
end
