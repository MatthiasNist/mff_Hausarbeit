
rng default; % For reproducibility
[vS,yS] = simulate(params,40000);
y0 = yS(1);
v0 = vS(1);
y = yS(2:end);
v = vS(2:end);

figure
subplot(2,1,1)
plot(v)
title('Conditional Variances')
subplot(2,1,2)
plot(y)
title('Innovations')


%%



%infered:

vI = infer(params, logRets);

figure
plot(1:100,v,'r','LineWidth',2)
hold on
plot(1:100,vI,'k:','LineWidth',1.5)
legend('Simulated','Inferred','Location','NorthEast')
title('Inferred Conditional Variances - No Presamples')
hold off


%%

rng default; % For reproducibility
[vS,yS] = simulate(params,101);
y0 = yS(1);
v0 = vS(1);
y = yS(2:end);
v = vS(2:end);

figure
subplot(2,1,1)
plot(v)
title('Conditional Variances')
subplot(2,1,2)
plot(y)
title('Innovations')


%%



%infered:

vI = infer(params,logRets);

figure
plot(1:100,v,'r','LineWidth',2)
hold on
plot(1:100,vI,'k:','LineWidth',1.5)
legend('Simulated','Inferred','Location','NorthEast')
title('Inferred Conditional Variances - No Presamples')
hold off