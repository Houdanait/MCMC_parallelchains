clear;
close all
base_name = 'prod_D2_KLfull_DE_RK3_0';
%dados=load('../prod/prodF_ref_0.dat');
%dados=load('../SIMULADOR_ELASTICO/exp/conc/conc_ref_0.dat');
dados=load('../twophaseflow/exp/prod/prod_referencia_0.dat');
ref=dados;
%
file_name = ['../twoStage/select_prod/' base_name '.dat']
file_name = '../twophaseflow/exp/prod/prod_ref_0.dat'
%
% Create figure
figure1 = figure()
B=450.;
A=100.0;
%B=1e-2;
%A=1e-5;
C=min(dados(:,1));
C=-0
D=max(dados(:,1))*1.01;

dasp=[1 2.*(B-A)/(D-C) 200];
% Create axes
axes1 = axes('Parent',figure1,'FontSize',14,'FontName','Times New Roman',...
    'DataAspectRatio',dasp);
box(axes1,'on');
hold(axes1,'all');

dados=load(file_name);

plot(dados(:,1),dados(:,2),'Parent',axes1,'Color',[1 0 0],...
    'MarkerSize',5,'Marker','o','LineStyle','none','DisplayName','sample 1')
plot(dados(:,1),dados(:,3),'Parent',axes1,'Color',[0 0 1],...
    'MarkerSize',5,'Marker','s','LineStyle','none','DisplayName','sample 2')
plot(dados(:,1),dados(:,4),'Parent',axes1,'Color',[0 0 0],...
    'MarkerSize',5,'Marker','^','LineStyle','none','DisplayName','sample 3')
plot(dados(:,1),dados(:,5),'Parent',axes1,'Color',[0 1 0],...
    'MarkerSize',5,'Marker','v','LineStyle','none','DisplayName','sample 4')
% plot(dados(:,1),dados(:,6),'Parent',axes1,'Color',[0 1 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 5')
% plot(dados(:,1),dados(:,7),'Parent',axes1,'Color',[0.2 0.2 0.5],...
%     'MarkerSize',4,'Marker','s','LineStyle','none','DisplayName','sample 6')
% plot(dados(:,1),dados(:,8),'Parent',axes1,'Color',[0 0 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 7')
% plot(dados(:,1),dados(:,9),'Parent',axes1,'Color',[1 0 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 8')
% plot(dados(:,1),dados(:,10),'Parent',axes1,'Color',[0 1 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 9')
% plot(dados(:,1),dados(:,11),'Parent',axes1,'Color',[0 0 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 10')
% plot(dados(:,1),dados(:,12),'Parent',axes1,'Color',[1 0 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 11')
% plot(dados(:,1),dados(:,13),'Parent',axes1,'Color',[1 1 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 12')
% plot(dados(:,1),dados(:,14),'Parent',axes1,'Color',[.8 .8 .8],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 13')
% plot(dados(:,1),dados(:,15),'Parent',axes1,'Color',[0 1 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 14')
% plot(dados(:,1),dados(:,16),'Parent',axes1,'Color',[0 1 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 15')
% plot(dados(:,1),dados(:,17),'Parent',axes1,'Color',[0 0 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 16')
% plot(dados(:,1),dados(:,18),'Parent',axes1,'Color',[0 0 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 17')
% plot(dados(:,1),dados(:,19),'Parent',axes1,'Color',[1 0 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 18')
% plot(dados(:,1),dados(:,20),'Parent',axes1,'Color',[0 1 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 19')
% plot(dados(:,1),dados(:,21),'Parent',axes1,'Color',[0 0 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 20')
% plot(dados(:,1),dados(:,22),'Parent',axes1,'Color',[0 1 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 21')
% plot(dados(:,1),dados(:,23),'Parent',axes1,'Color',[1 1 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 22')
% plot(dados(:,1),dados(:,24),'Parent',axes1,'Color',[1 0 0],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 23')
% plot(dados(:,1),dados(:,25),'Parent',axes1,'Color',[0 0 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 24')
% plot(dados(:,1),dados(:,26),'Parent',axes1,'Color',[0 0 1],...
%     'MarkerSize',4,'Marker','o','LineStyle','none','DisplayName','sample 25')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dados=load('../../MCMC/reject_prod/prod_chn0-20_16000.dat');
%dados=load('../conc/conc_amostra_0.dat');
plot(ref(:,1),ref(:,2),'Parent',axes1,'Color',[1 0 0],...
    'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 1')
plot(ref(:,1),ref(:,3),'Parent',axes1,'Color',[0 0 1],...
    'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 2')
plot(ref(:,1),ref(:,4),'Parent',axes1,'Color',[0 0 0],...
    'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 3')
plot(ref(:,1),ref(:,5),'Parent',axes1,'Color',[0 1 0],...
    'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 4')
% plot(ref(:,1),ref(:,6),'Parent',axes1,'Color',[0 1 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 5')
% plot(ref(:,1),ref(:,7),'Parent',axes1,'Color',[0.2 0.2 .5],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 6')
% plot(ref(:,1),ref(:,8),'Parent',axes1,'Color',[0 0 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 7')
% plot(ref(:,1),ref(:,9),'Parent',axes1,'Color',[1 0 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 8')
% plot(ref(:,1),ref(:,10),'Parent',axes1,'Color',[0 1 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 9')
% plot(ref(:,1),ref(:,11),'Parent',axes1,'Color',[0 0 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 10')
% plot(ref(:,1),ref(:,12),'Parent',axes1,'Color',[1 0 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 11')
% plot(ref(:,1),ref(:,13),'Parent',axes1,'Color',[1 1 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 12')
% plot(ref(:,1),ref(:,14),'Parent',axes1,'Color',[.8 .8 .8],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 13')
% plot(ref(:,1),ref(:,15),'Parent',axes1,'Color',[0 1 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 14')
% plot(ref(:,1),ref(:,16),'Parent',axes1,'Color',[0 1 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 15')
% plot(ref(:,1),ref(:,17),'Parent',axes1,'Color',[0 0 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 16')
% plot(ref(:,1),ref(:,18),'Parent',axes1,'Color',[0 0 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 17')
% plot(ref(:,1),ref(:,19),'Parent',axes1,'Color',[1 0 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 18')
% plot(ref(:,1),ref(:,20),'Parent',axes1,'Color',[0 1 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 19')
% plot(ref(:,1),ref(:,21),'Parent',axes1,'Color',[0 0 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 20')
% plot(ref(:,1),ref(:,22),'Parent',axes1,'Color',[0 1 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 21')
% plot(ref(:,1),ref(:,23),'Parent',axes1,'Color',[1 1 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 22')
% plot(ref(:,1),ref(:,24),'Parent',axes1,'Color',[1 0 0],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 23')
% plot(ref(:,1),ref(:,25),'Parent',axes1,'Color',[0 0 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 24')
% plot(ref(:,1),ref(:,26),'Parent',axes1,'Color',[0 0 1],...
%     'MarkerSize',4,'LineWidth',2,'DisplayName','ref. 25')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlim(axes1,[C D])
ylim(axes1,[A B])
% Create xlabel
xlabel('$t (day)$','FontSize',16,'FontName','Times New Roman',...
    'FontAngle','italic','Interpreter','latex');

% Create ylabel
ylabel('Oil rate ($m^3/day$)','FontSize',16,'FontName',...
    'Times New Roman','FontAngle','italic','Interpreter','latex');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Location','NorthEast','FontSize',8);
set(legend1,'Box','off');

% Print
base=['../figuras/conc_' base_name];
print('-djpeg90',base)
print('-depsc','-r100',base)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NORMA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = min(size(ref(:,2:end),1),size(dados(:,2:end),1));
norma=norm(ref(:,2:end))
norma=norm(ref(:,2:end)-dados(:,2:end))/norma;
fprintf('ERRO RELATIVO = %e\n',norma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
