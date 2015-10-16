%% PART1: GARCH ANALYSIS---------------------------------------------------
%---------------------------exercise 1:------------------------------------
%--------------------------------------------------------------------------
% Teilaufgabe 1: Loading historic stock prices of Deutsche Bank:

tickSym = 'DBK.DE';     % Ticker symbol of Deutsche Bank AG 
                        %(https://de.finance.yahoo.com/q/cp?s=%5EGDAXI)

% specify beginning and ending as string variables
date_beg = '01012000';   %  first observation on first of January 2000
date_end = '01012015'; % Last observation on first of January 2015

dbk_data = getPrices(date_beg, date_end, tickSym);

%% Teilaufgabe 2: Calculating logarithmic returns
dbk_returns = price2retWithHolidays(dbk_data);

%% Teilaufgabe 3: Estimating GARCH-Parameters:

dats = datenum(dbk_returns.Properties.RowNames, 'yyyy-mm-dd');

dbk_returns_vec = dbk_returns.(1); % Vector of dbk_returns
dbk_returns_vec_rev = dbk_returns_vec(end:-1:1); % the data has to be set
% upside-down, (so financial crisis in 2008 can be seen)

log_rets = 100*dbk_returns_vec_rev; % vector of logarithmic returns


% specifying the object 
object_specif = garch('Constant', NaN, 'GARCHLags', 1, 'ARCHLags', 1) 

% alternative: conditional mean model offset
% object_specif = garch('Constant', NaN, 'GARCHLags',1,'ARCHLags',1,'Offset',NaN) 

% estimate-method for object of class "GARCH" => calculation of process-
% parameters
[params output] = estimate(object_specif, log_rets)
print(params,output)

garch_val = params.GARCH{1}; % GARCH-parameter
arch_val = params.ARCH{1};   % ARCH-parameter
k = params.Constant; % constant term
%offset = params.Offset %conditional mean model offset

%% Teilaufgabe 4: Estimating and plotting of backtesting procedure:

% evaluating the critical values (alpha = 5%)
alpha_levels = 1 - [0.95];
var = infer(params, log_rets);
sigma = sqrt(var);
val_pdf_crit = norminv(alpha_levels, k, sigma);

%plotting the data:
figure('position', [50 50 1200 600])
scatter(dats, log_rets, '.')
datetick 'x'
set(gca, 'xLim', [dats(end) dats(1)])

hold on;

% Defining and retrieving the exceedances
exceedances = log_rets < val_pdf_crit;
dats_exceed = dats(exceedances);
logRets_exceed = log_rets(exceedances);

% plotting the exceedances in red color:
plot(dats_exceed, logRets_exceed, '.r')

% plotting the VaR with a dotted black line:
plot(dats, val_pdf_crit, ':k')

% labeling of plot
xlabel('dates')
ylabel('logarithmic returns')
title('historic Deutsche Bank returns and VaR exceedances')

% frequency of exceedances:
freq_exceed = numel(find(log_rets < val_pdf_crit)) / length(log_rets)

% plotting of frequency-text:
freq_text = text(dats(end-ceil((length(dats)/4))), -15, ...
    ['frequency of exceedances: ' num2str(freq_exceed*100) '%'])
freq_text(1).Color = 'red';
freq_text(1).FontSize = 12;

%% Teilaufgabe 5: Autocorrelation function

% simulating the path of length 40000:
rng default; % For reproducibility
[var_sim, rets_sim] = simulate(params, 40000); 

% Again, like wie did in class autocorrelation function for i = 1:20,
% beginning with lag 0
auto_corr_coef_real = autocorr(log_rets.^2, 20) % real world data 
auto_corr_coef_sim = autocorr(rets_sim.^2, 20) % simulated data

%plotting of the autocorrelation function:
figure
subplot(2, 1, 1)
autocorr(auto_corr_coef_real)
title('Autocorrelation Function - real world data')

subplot(2,1,2)
autocorr(auto_corr_coef_real)
title('Autocorrelation Function - simulated data')

%% letzte Teilaufgabe (exercise 1)

rng default; % For reproducibility
[V,Y] = simulate(params, length(log_rets), 'NumPaths', 3);

% extracting the simulated data:
data = struct('log_rets', log_rets, 'Simulated_Path_1', Y(:,1) ...
    , 'Simulated_Path_2', Y(:,2), 'Simulated_Path_3', Y(:,3));

% creating a table for the plotting-loop:
data_table = struct2table(data);

%plotting-loop:
figure
for ii = 1:size(data_table, 2)
subplot(4,1,ii)
plot(dats, data_table.(ii))
title(['Responses' data_table.Properties.VariableNames(ii)], ... 
    'interpreter', 'none')
set(gca, 'yLim', [-50 50])
datetick 'x'
hold on
end

% Aufgrund der Ausschlaege (vor allem nach unten) um das Jahr 2008 herum im
% obersten Plot, ist erkenntlich, dass dieser die wahren Daten wiedergibt, 
% da zu diesem Zeitpunkt die Finanzkrise um sich griff.

%--------------------------------------------------------------------------
%---------------------------exercise 2:------------------------------------
%--------------------------------------------------------------------------

%% Teilaufgabe 1: Plotting of ks-estimate of real world data log_rets 
[y_real_ks, x_real_ks] = ksdensity(log_rets);  % 
figure
plot(x_real_ks, y_real_ks, '.-b');
set(gca, 'xLim', [-10 10])
set(gca, 'yLim', [0 0.3])
hold on

%% Teilaufgabe 2: Plotting a pdf with estimated parameters of log_rets

% estimation of sigma and mu
[mu_hat_real, sigma_hat_real] = normfit(log_rets) 

x_pdf = [-10:.001:10];

% pdf-estimating and plotting:
norm_pdf = normpdf(x_pdf, mu_hat_real, sigma_hat_real);
plot(x_pdf, norm_pdf, '-r')
hold on

%% Teilaufgabe 3: Plotting of ks-estimate of GARCH-Process simulation:

% Again the object-specification of the GARCH-Process like in exercise 1:
object_specif = garch('Constant', NaN, 'GARCHLags',1,'ARCHLags',1) 
[params output] = estimate(object_specif, log_rets);

% simulating the process with path-length of 40000
[var_sim, rets_sim] = simulate(params, 40000);

% kernel-smoothing-estimate and plotting:
[y_sim_ks, x_sim_ks] = ksdensity(rets_sim);
plot(x_sim_ks, y_sim_ks, '-g');
hold on

%% Teilaufgabe 4: Simulating and plotting of t-distr. GARCH-Process:

% GARCH-pbject-specification with t-distribution:
object_specif_t = garch('Constant', NaN, 'GARCHLags', 1,'ARCHLags', 1, ...
    'Distribution','T')
[params_t output_t] = estimate(object_specif_t, log_rets)

% simulating a path of length 40000:
[var_sim_t, rets_sim_t] = simulate(params_t,40000);

% ks-estimate and plotting:
[y_sim_t_ks , x_sim_t_ks] = ksdensity(rets_sim_t);
plot(x_sim_t_ks,y_sim_t_ks, '-k');
xlabel('values')
ylabel('density')
legend('real data - kernel', 'norm. distr. - est. param.', ...
    'norm. distr. GARCH - kernel', 't-distr. GARCH - kernel', ...
     'Location', 'best')
 legend('boxoff')

% => die Wölbung (kurtosis) der geplotteten simulierten Werte kommt mit 
% einer GARCH-specification die auf einer t-Verteilung aufbaut den wahren 
% Werten - bzw. deren parameterfreien kernel-Schätzung - erheblich näher 
% als dies die theoretische Normalverteilung mit geschätzten Parametern 
% oder die Kernel-Schätzung aufbauend auf einer Simulation der 
% GARCH-specification mittels Normalverteilungsannahme tut. => Die
% Simulation der Werte des GARCH-Objects mit einer t-Verteilung als
% Verteilungsannahme repliziert die wahren Wölbung am besten.







