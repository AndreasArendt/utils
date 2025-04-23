mu = [1, -4];

x1 = randn(100, 1) + mu(1) - 0.5;
x2 = randn(100, 1) + mu(2) - 0.5;

x = (-10:0.1:10).';
y = (-10:0.1:10).';

[X, Y] = meshgrid(x, y);
data = [X(:) Y(:)] - mu;
gauss_pdf = pdf.gauss(data);
gauss_pdf = reshape(gauss_pdf, size(X));

figure;
hold on;
surf(x, y, gauss_pdf);
plot(x1,x2, 'x', 'Color', Color.RED);