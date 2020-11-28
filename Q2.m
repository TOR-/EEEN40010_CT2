%% Constants, setup
a=4;
b=6;
c=6;

set(gca, 'defaultTextInterpreter','latex')
set(gca, 'FontSize',54)
close all

dB = @(v) 20*log10(v);
ro = @(v) 10^(v/20);

%% PROBLEM TWO
Np = 16.2*a*[1 4.1*(1+0.1*c)];
Dp = conv([1 .43*b],[1 2.85+0.08*c]);
Gp = tf(Np,Dp);
%margin(Gp)
dc_gain = dB(freqresp(Gp, 0));
sse_p = 1/(1+freqresp(Gp, 0));
sse_target = 0.04;
dc_gain_min = dB(1/sse_target -1);
d_dc_gain = dc_gain - dc_gain_min;

%% PO & CHI
PO_target = 25;
PO  = @(chi) 100*exp(-pi*chi./sqrt(1-chi.^2));
prosp_chi = 0.3:1e-5:0.8;
[md, mi] = min(abs(PO(prosp_chi)-PO_target));
chi = prosp_chi(mi);
chi_chosen = 0.45;
%% TS 2%
TS_target = 1;
o_n = 4/(chi_chosen*TS_target);
o_gc = o_n*sqrt(sqrt(1+4*chi_chosen^4)-2*chi_chosen^2);
o_gc_chosen = 8;%o_gc;
%% CONTROLLER alpha AND tau
% reduce plant with gain
k = ro(-6);
Gp_k = tf(k*Np,Dp);
%margin(Gp_k)
d_gain = -19;
alpha = 10^(d_gain/10);
PM_desired = 45; % degrees
alpha = (1+sind(PM_desired))/(1-sind(PM_desired));
tau = 1/(o_gc_chosen*sqrt(alpha));
Nc = k*[tau*alpha 1];
Dc = [tau 1];
Gc = tf(Nc, Dc);
%k = 1;
%z = 1;
%p = 1;
%Nc = k*[1 z];
%Dc = [1 p];
%Gc = tf(Np, Dc);
Go = series(Gp, Gc);
Gideal = tf(1,1);
Gcl = feedback(Go, Gideal);
%step(Gcl)
si = stepinfo(Gcl);
si.Overshoot
si.SettlingTime