function M = M_z(psi)
    s = sin(psi);
    c = cos(psi);

    M = [ c -s  0;
          s  c  0;
          0  0  1];
end
