PO  = @(chi) 100*exp(-pi*chi./sqrt(1-chi.^2));
prosp_chi = 0.6:1e-8:0.8;
[md, mi] = min(abs(PO(prosp_chi)-5));
chi = prosp_chi(mi)

chi_chosen = 0.72;
o_n = 4/(chi_chosen*1);
o_gc = o_n*sqrt(sqrt(1+4*chi_chosen^4)-2*chi_chosen^2)
