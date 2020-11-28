%% Constants, setup
a=4;
b=6;
c=6;

set(gca, 'defaultTextInterpreter','latex')
set(gca, 'FontSize',54)
close all
%% PROBLEM THREE
Np = 16.2*a*[1 4.1*(1+0.1*c)];
Dp = conv([1 .43*b],[1 2.85+0.08*c]);
[A, B, C, D] = tf2ss(Np,Dp);
