v = [1 -1 3; 1 0 5; 1 2 6];

[u, e] = algorithm.GramSchmid(v);

figure;
hold on;
axis equal;
grid on;

quiver3(0,0,0,v(1,1),v(2,1),v(3,1), 'DisplayName', 'v1', 'Color', Color.BLUE)
quiver3(0,0,0,v(1,2),v(2,2),v(3,2), 'DisplayName', 'v2', 'Color', Color.BLUE)
quiver3(0,0,0,v(1,3),v(2,3),v(3,3), 'DisplayName', 'v3', 'Color', Color.BLUE)

quiver3(0,0,0,e(1,1),e(2,1),e(3,1), 'DisplayName', 'u1')
quiver3(0,0,0,e(1,2),e(2,2),e(3,2), 'DisplayName', 'u2')
quiver3(0,0,0,e(1,3),e(2,3),e(3,3), 'DisplayName', 'u3')