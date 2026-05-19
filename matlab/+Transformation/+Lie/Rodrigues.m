function R = Rodrigues(rot_xyz)
%RODRIGUES Rodrigues Rotation Formula
% see: https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula

theta = vecnorm(rot_xyz, 2,2);
K = Vector.skew(rot_xyz);

if theta < 1e-12
    % Second-order approximation    
    R = eye(3) + K + 0.5*K*K;
    return;
end

R = eye(3) + sin(theta)/theta * K + ((1-cos(theta))/theta^2)*K*K;
