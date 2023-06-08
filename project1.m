
clc
clear all
close all

% load the data
startdate = '01/01/1994';
enddate = '01/01/2022';

f = fred;
Y_us = fetch(f,'GDPC1',startdate,enddate);
%Y_au = fetch(f,'NGDPRSAXDCAUQ',startdate,enddate);
Y_jp = fetch(f,'JPNRGDPEXP',startdate,enddate);
%Y_jp = fetch(f,'JPNNGDP',startdate,enddate);
y_us = log(Y_us.Data(:,2));
y_jp = log(Y_jp.Data(:,2));

q = Y_us.Data(:,1);

T = size(y_us,1);

%[trend, cycle] = hpfilter(log(y), 1600);
[cycle_us, trend_us] = qmacro_hpfilter(y_us, 1600);
[cycle_jp, trend_jp] = qmacro_hpfilter(y_jp, 1600);

% plot detrended GDP
dates = 1994:1/1:2022.1/1; zerovec = zeros(size(y_us));
figure
title('Detrended log(real GDP) 1994Q1-2022Q1'); hold on
plot(q, cycle_us,'b')
plot(q, cycle_jp,'r')
legend('US', 'JP','Location','southwest')
datetick('x', 'yyyy-qq')

% compute sd(y), sd(c), rho(y), rho(c), corr(y,c) (from detrended series)
ysd_us = std(cycle_us)*100;
ysd_jp = std(cycle_jp)*100;

corr = corrcoef(cycle_us,cycle_jp); corr = corr(1,2);

disp(['アメリカのGDPの標準偏差: ', num2str(ysd_us),'.']); disp(' ')
disp(['日本のGDPの標準偏差: ', num2str(ysd_jp),'.']); disp(' ')
disp(['アメリカと日本のGDPの相関係数: ', num2str(corr),'.']); disp(' ')
