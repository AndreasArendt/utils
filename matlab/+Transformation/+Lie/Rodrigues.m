function R = Rodrigues(rot_xyz)
%RODRIGUES Rodrigues Rotation Formula
% see: https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula

theta = vecnorm(rot_xyz, 2,2);

if theta < 1e-12
    % First-order approximation
    R = eye(3) + Vector.skew(phi);
    return;
end

K = Vector.skew(rot_xyz);
R = eye(3) + sin(theta)/theta * K + ((1-cos(theta))/theta^2)*K*K;
