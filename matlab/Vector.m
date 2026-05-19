classdef Vector < handle
    %VECTOR Summary of this class goes here
    %   Detailed explanation goes here
        
    methods (Static = true)
        function d12 = EuclidianDistance_3D(x1, y1, z1, x2, y2, z2)
            dx = (x1 - x2);
            dy = (y1 - y2);
            dz = (z1 - z2);
            d12 = vecnorm([dx dy dz],2,2);
        end

        function d12 = DistanceVector_3D(x1, y1, z1, x2, y2, z2)
            dx = (x1 - x2);
            dy = (y1 - y2);
            dz = (z1 - z2);
            
            d12 = [dx, dy, dz];
        end

        function e = NormalizedDistanceVector(x1, y1, z1, x2, y2, z2)
            d = Vector.DistanceVector_3D(x1, y1, z1, x2, y2, z2);
            e = d ./ vecnorm(d,2,2);
        end

        function S = skew(v)
            assert(size(v,2) == 3, "allow only [n x 3] vectors")
        
            n = size(v,1);
            S = zeros(3,3,n);
        
            S(1,2,:) = -v(:,3);
            S(1,3,:) =  v(:,2);
        
            S(2,1,:) =  v(:,3);
            S(2,3,:) = -v(:,1);
        
            S(3,1,:) = -v(:,2);
            S(3,2,:) =  v(:,1);
        end
    end
end

