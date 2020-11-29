PO  = @(zeta) 100*exp(-pi*zeta./sqrt(1-zeta.^2));
prosp_zeta = 0.6:1e-8:0.8;
[md, mi] = min(abs(PO(prosp_zeta)-5));
zeta = prosp_zeta(mi)

zeta_chosen = 0.72;
o_n = 4/(zeta_chosen*1);
o_gc = o_n*sqrt(sqrt(1+4*zeta_chosen^4)-2*zeta_chosen^2)
