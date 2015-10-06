
%% kernel smothing estimate of real world data "logRets"
[f,xi] = ksdensity(logRets);  % "f" und "xi" aus exapmles => verständlicher nennen
figure
plot(xi,f, '.-b');
set(gca, 'xLim', [-10 10])
set(gca, 'yLim', [0 0.3])
hold on

%%
% fitting a normal distribution taking estimated parameters of "logRets"

% estimation of sigma and mu
[mu_hat_real, sigma_hat_real] = normfit(logRets) 

x = [-10:.001:10];
norm_pdf = normpdf(x,mu_hat_real,sigma_hat_real);
plot(x, norm_pdf, '-r')
hold on

%% Again the object-specification of the GARCH-Process like in exercise 1:

object_specif = garch('Constant', NaN, 'GARCHLags',1,'ARCHLags',1) 
[params output] = estimate(object_specif, logRets)

% simulating the process with path-length of 40000
[var_sim, rets_sim] = simulate(params,40000);

[f_sim,xi_sim] = ksdensity(rets_sim);

plot(xi_sim,f_sim, '-g');
hold on

%% s. http://de.mathworks.com/help/econ/specify-garch-models-using-garch.html
object_specif_t = garch('Constant', NaN, 'GARCHLags',1,'ARCHLags',1,'Distribution','T')
[params_t output_t] = estimate(object_specif_t, logRets)

[var_sim_t, rets_sim_t] = simulate(params_t,40000);

[f_sim_t ,xi_sim_t] = ksdensity(rets_sim_t);

plot(xi_sim_t,f_sim_t, '-k');
xlabel('values')
ylabel('density')
legend('real data - kernel', 'norm. distr. - est. param.', ...
    'norm. distr. GARCH - kernel', 't-distr. GARCH - kernel', ...
     'Location','best')
 legend('boxoff')

% => die Wölbung (kurtosis) der geplotteten simulierten Werte kommt mit 
% einer GARCH-specification die auf einer t-Verteilung aufbaut den wahren 
% Werten - bzw. deren parameterfreien kernel-Schätzung - erheblich näher 
% als dies die theoretische Normalverteilung mit geschätzten Parametern 
% oder die Kernel-Schätzung aufbauend auf einer Simulation der 
% GARCH-specification mittels Normalverteilungsannahme tut. => Die
% Simulation der Werte des GARCH-Objects mit einer t-Verteilung als
% Verteilungsannahme repliziert die wahren Wölbung am besten.


