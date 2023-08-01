clearvars
clc

a = 0.05;
x = linspace(-a,a,1000);
y = linspace(-a,a,1000);

[X,Y] = meshgrid(x,y);



F = sqrt(4*X.^2+3*Y.^2)-abs(X);

figure(1), clf, hold on

    view(-19,30)
    s = surface(X,Y,F);
    s.EdgeColor='none';

%     f=surf(X,Y,abs(X));
%     f.EdgeColor='b';
%     f.FaceColor='r';
    xlabel('$x1$')
    ylabel('$x2$')
    plot_layout(gca)



