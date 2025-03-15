function plot_3d_lattice(a1, a2, a3, num_cells)
    % Function to plot a 3D lattice based on three basis vectors
    
    figure;
    hold on;
    grid on;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('3D Lattice Structure');
    axis equal;
    
    for i = -num_cells:num_cells
        for j = -num_cells:num_cells
            for k = -num_cells:num_cells
                point = i * a1 + j * a2 + k * a3;
                plot3(point(1), point(2), point(3), '.', 'Color', Color.BLUE, 'MarkerSize', 6, 'MarkerFaceColor', Color.BLUE, 'HandleVisibility','off');
            end
        end
    end
   hold off;
end

% Example usage:
B = [2 1 -2; 3 2 -2; 1 -1 2];
BB = algorithm.LLL(B);

a1 = B(:,1);
a2 = B(:,2);
a3 = B(:,3);

num_cells = 3;
plot_3d_lattice(a1, a2, a3, num_cells);
hold on;set(gca,'ColorOrderIndex',1)
quiver3(0,0,0,BB(1,1), BB(2,1), BB(3,1), 'off', 'DisplayName', 'v1')
quiver3(0,0,0,BB(1,2), BB(2,2), BB(3,2), 'off', 'DisplayName', 'v2')
quiver3(0,0,0,BB(1,3), BB(2,3), BB(3,3), 'off', 'DisplayName', 'v3')

quiver3(0,0,0,B(1,1), B(2,1), B(3,1), 'off', 'DisplayName', 'u1')
quiver3(0,0,0,B(1,2), B(2,2), B(3,2), 'off', 'DisplayName', 'u2')
quiver3(0,0,0,B(1,3), B(2,3), B(3,3), 'off', 'DisplayName', 'u3')
legend('show')