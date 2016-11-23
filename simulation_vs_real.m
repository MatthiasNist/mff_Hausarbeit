Mdl = garch('Constant',0.05,'GARCH',garch_val,'ARCH',arch_val);

rng default; % For reproducibility
[vS,yS] = simulate(Mdl,3883);
y0 = yS(1);
v0 = vS(1);
y = yS(2:end);
v = vS(2:end);