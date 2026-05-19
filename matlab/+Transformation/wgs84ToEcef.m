function [x_E, y_E, z_E] = wgs84ToEcef(lat, lon, alt)
    e = sqrt(1 - (Transformation.Wgs84_SemiMinorAxis__m() / Transformation.Wgs84_SemiMajorAxis__m())^2);                                
    N = Transformation.Wgs84_SemiMajorAxis__m() ./ sqrt(1 - e^2 .* sin(lat).^2);
    x_E = (N+alt) .* cos(lat) .* cos(lon);
    y_E = (N+alt) .* cos(lat) .* sin(lon);
    z_E = ((1-e^2) .* N + alt) .* sin(lat);            
end
