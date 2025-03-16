mu = [1, -4];

x1 = rand(100, 1) + mu(1) - 0.5;
x2 = rand(100, 1) + mu(2) - 0.5;

sigma = zeros(2);
sigma(1,1) = var(x1);
sigma(2,2) = var(x2);

k = numel(mu);

x = (-5:0.1:5).';
y = (-5:0.1:5).';

[X, Y] = meshgrid(x, y);
data = [X(:) Y(:)] - mu;
pdf = (2*pi)^(-k/2) * det(sigma)^-0.5 * exp(-0.5 * sum((data / sigma) .* data, 2));
pdf = reshape(pdf, size(X));

figure;
hold on;
surf(x, y, pdf);
plot(x1,x2, 'x', 'Color', Color.RED);


