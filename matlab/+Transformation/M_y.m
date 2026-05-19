function M = M_y(theta)
    s = sin(theta);
    c = cos(theta);

    M = [ c  0  s;
          0  1  0;
         -s  0  c];
end
