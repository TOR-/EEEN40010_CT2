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
Gp = tf(Np,Dp);
[A, B, C, D] = tf2ss(Np,Dp);
sip = stepinfo(Gp);
t_s_max = sip.SettlingTime * 0.4;
t_s_target = 0.7;
PO_max = max([10*100*si.Overshoot,25]);

PO  = @(zeta) 100*exp(-pi*zeta./sqrt(1-zeta.^2));
%prosp_zeta = 0.2:1e-8:0.8;
[md, mi] = min(abs(PO(prosp_zeta)-PO_max));
zeta = prosp_zeta(mi);
zeta_chosen = 0.5;
PO_target = PO(zeta_chosen);
%%
o_n = 4/(zeta_chosen * t_s_target);
Pcharc = [1 2*zeta_chosen*o_n o_n^2];
roots(Pcharc);
pole(Gp);
zero(Gp);
%% CONTROLLER
P = [-6 -6.7];
K = place(A, B, P);
K_chosen = [7, 32];
NB = -1/(C/(A-(B*K_chosen))*B);
Gcl = ss(A-(B*K_chosen),NB*B,C,D);
sicl = stepinfo(Gcl);
sicl.SettlingTime;
pole(Gcl);

%% ONCE MORE, BUT WITH OBSERVER
L = place(A',C',[-100 -101])'
% Observer gain, poles hereby produced much be negative enough 
% that the estimation error converges to zero rapidly
L_chosen = [64 -9]';
Acl = [A-(B*K_chosen) B*K_chosen; zeros(size(A)) A-(L_chosen*C)];
Bcl = NB*[B;zeros(length(A),1)];
Ccl = [C zeros(1,length(A))];
Dcl = D;
Gcl_observer = ss(Acl, Bcl, Ccl, Dcl);
siclo = stepinfo(Gcl_observer);
siclo.SettlingTime
siclo.Overshoot
%step(Gcl_observer)
%print('report/img/p3-step_observer','-dpng');

%% SENSITIVITY
factors=0.9:0.05:1.1;
%factors=0.2:0.05:1.8;
ak=a;
bk=b;
ck=c;
ts = zeros(length(factors)^3,1);
pk = zeros(length(factors)^3,1);
idx = 1;
for af=factors
    a=ak*af;
    for bf=factors
        b=bk*bf;
        for cf=factors
            c=ck*cf;
            Np = 16.2*a*[1 4.1*(1+0.1*c)];
            Dp = conv([1 .43*b],[1 2.85+0.08*c]);
            Gp = tf(Np,Dp);
            [A, B, C, D] = tf2ss(Np,Dp);
            Acl = [A-(B*K_chosen) B*K_chosen; zeros(size(A)) A-(L_chosen*C)];
            Bcl = NB*[B;zeros(length(A),1)];
            Ccl = [C zeros(1,length(A))];
            Dcl = D;
            Gcl_observer = ss(Acl, Bcl, Ccl, Dcl);
            siclo = stepinfo(Gcl_observer);
            Gcl = ss(A-(B*K_chosen),NB*B,C,D);
            sicl = stepinfo(Gcl);
            %fprintf(1, "%f & %f & %f & %f & %f & %f\n", a, b, c, siclo.SettlingTime, sicl.SettlingTime, siclo.Peak);
            ts(idx) = siclo.SettlingTime;
            pk(idx) = siclo.Peak;
            idx = idx+1;
        end
    end
end
a = ak;
b = bk;
c = ck;
plot(abs(pk-1),'.')
plot((ts-t_s_max)/t_s_max,'o')