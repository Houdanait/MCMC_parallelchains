function figVARS(X1, YMatrix1,vari)
%CREATEFIGURE(X1,YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 28-Oct-2013 10:24:02

% Create figure
figure3 = figure(44);
B=max(max(YMatrix1))*1.1;
A=min(min(YMatrix1));
%B=1.5e+1;
C=min(X1);
D=max(X1);

% Create axes
axes3 = axes('Parent',figure3,'YMinorTick','on','XMinorTick','on',...
    'FontSize',14,...
    'FontName','Times New Roman',...
    'DataAspectRatio',[1 2*(B-A)/(D-C) 1]);
box(axes3,'on');
hold(axes3,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',axes3);
set(plot1(1),'Marker','+','DisplayName','$\phi$','Color',[0 0 0]);
set(plot1(2),'MarkerEdgeColor',[0 0 0],'Marker','o','Color',[0 0 0],...
    'DisplayName','$k$');
hold on
% Create plot
plot([C D],[vari vari],'Parent',axes3,'LineWidth',3,'Color',[1 0 0],...
    'DisplayName','variance');
xlim(axes3,[C D])
ylim(axes3,[A B])

% Create xlabel
xlabel('$n$','Interpreter','latex','FontSize',20,...
    'FontName','Times New Roman');

% Create ylabel
ylabel('$\sigma^2_{\theta_\alpha}$','Interpreter','latex',...
    'FontSize',20,...
    'FontName','Times New Roman');

% Create legend
leg3 = legend(axes3,'show');
set(leg3,'Interpreter','latex')

