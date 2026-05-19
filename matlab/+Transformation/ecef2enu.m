function [E, N, U] = ecef2enu(lat__rad, lon__rad, x__m, y__m, z__m)
    Mx = Transformation.M_x(pi/2 - lat__rad);
    Mz = Transformation.M_z(pi/2 + lon__rad);

    ENU = zeros(numel(x__m),3);
    for ii = 1:numel(x__m)
        ENU(ii,:) = Mx.' * Mz.' * [x__m(ii); y__m(ii); z__m(ii)];
    end            

    E = ENU(:,1);
    N = ENU(:,2);
    U = ENU(:,3);
end
