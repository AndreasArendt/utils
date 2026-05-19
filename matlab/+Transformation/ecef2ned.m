function [N, E, D] = ecef2ned(lat__rad, lon__rad, x__m, y__m, z__m)
    [E,N,U] = Transformation.ecef2enu(lat__rad, lon__rad, x__m, y__m, z__m);
    D = -U;
end
