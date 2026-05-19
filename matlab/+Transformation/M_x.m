function M = M_x(phi)
    s = sin(phi);
    c = cos(phi);

    M = [ 1  0  0;
          0  c -s;
          0  s  c];
end
