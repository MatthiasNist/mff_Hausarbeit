tickSym = 'DBK.DE';     % Ticker symbol of Deutsche Bank AG (https://de.finance.yahoo.com/q/cp?s=%5EGDAXI)

% specify beginning and ending as string variables
dateBeg = '01012000';   %  first observation on first of January 2000
dateEnd = '01012015'; % Last observation on first of January 2015

dbk_data = getPrices(dateBeg, dateEnd, tickSym)

% calculating logarithmic returns
dbk_returns = price2retWithHolidays(dbk_data);

%%

dats = datenum(dbk_returns.Properties.RowNames, 'yyyy-mm-dd');

dbk_returns_vec = dbk_returns.(1) % Vector of dbk_returns
logRets = 100*dbk_returns_vec % vector of logarithmic returns


% specifying the object 
object_specif = garch('Constant', NaN, 'GARCHLags',1,'ARCHLags',1) 
% plus a conditional mean model offset
% object_specif = garch('Constant', NaN, 'GARCHLags',1,'ARCHLags',1,'Offset',NaN) 

[params output] = estimate(object_specif, logRets)
print(params,output)

% constant = params.Constant;
% ar_1 = params.AR;
% garch_val = params.Variance.GARCH{1}; % GARCH-parameter
% arch_val = params.Variance.ARCH{1};   % ARCH-parameter
% k = params.Variance.Constant; % offset labeled "k"


object_specif_var = garch(1,1)

% estimate-method for object of class "GARCH" => calculation of process-parameters
params_var = estimate(object_specif_var, logRets)

%EstMdl = estimate(Mdl,y) estimates the unknown parameters of the 
%conditional variance model object Mdl with the observed univariate time 
%series y, using maximum likelihood (!). EstMdl is a fully specified 
%conditional variance model object that stores the results. It is the 
%same model type as Mdl (see garch, egarch, and gjr).

garch_val = params.GARCH{1} % GARCH-parameter
arch_val = params.ARCH{1}   % ARCH-parameter
k = params.Constant % constant term
%offset = params.Offset %conditional mean model offset


var = infer(params_var, logRets)
%mu = infer(params, logRets)

alphaLevels = 1 - [0.95];
sigma = sqrt(var)
val_pdf_crit = norminv(alphaLevels, k, sigma) % Mittelwert k oder offset?

%mit Offset:
%val_pdf_crit = norminv(alphaLevels, offset, sigma)


figure('position', [50 50 1200 600])

%plotting the data:
scatter(dats, logRets, '.')
datetick 'x'
set(gca, 'xLim', [dats(end) dats(1)])

hold on;

% Defining and retrieving the exceedances
exceedances = logRets < val_pdf_crit;
dats_exceed = dats(exceedances);
logRets_exceed = logRets(exceedances);

% plotting the exceedances in red color:
plot(dats_exceed, logRets_exceed, '.r')

% plotting the VaR with a dotted black line:
plot(dats, val_pdf_crit,':k')

% labeling of plot
xlabel('dates')
ylabel('logarithmic returns')
title('historic Deutsche Bank returns and VaR exceedances')

% frequency of exceedances:
freq_exceed = numel(find(logRets < val_pdf_crit))/length(logRets)

% plotting of frequency-text:
freq_text = text(dats(end-ceil((length(dats)/2))), -15, ...
    ['frequency of exceedances: ' num2str(freq_exceed*100) '%'])
freq_text(1).Color = 'red';
freq_text(1).FontSize = 11;



%% Überprüfung Varianz (langsamer)

sigmaHat0 = 2;

retrieveSigmas = zeros(numel(y), 1);
retrieveSigmas(1) = sigmaHat0;

for ii=2:numel(y)
    retrieveSigmas(ii) = sqrt(k + garch*retrieveSigmas(ii-1).^2 +...
        arch*y(ii-1).^2);
end

%% simulate

%rng default; % For reproducibility
[var_sim, rets_sim] = simulate(params,40000);

autoCorrCoef_real = corr(logRets(1:end-1), logRets(2:end))
autoCorrCoef_sim = corr(y(1:end-1), y(2:end))


%% letzte Teilaufgabe 

% rng default; % For reproducibility
% 
% %500 sample-paths with 100 observations
% [V,Y] = simulate(params,40000,'NumPaths',2);
% 
% figure
% subplot(2,1,1)
% plot(V)
% title('Simulated Conditional Variances')
% 
% subplot(2,1,2)
% plot(Y)
% title('Simulated Responses')

rng default; % For reproducibility
[V,Y] = simulate(params,length(logRets),'NumPaths',3);

data = struct('logRets', logRets, 'SimulatedPath1', Y(:,1) ...
    , 'SimulatedPath2', Y(:,2), 'SimulatedPath3', Y(:,3))

data_table = struct2table(data)

for ii = 1:size(data_table, 2)
subplot(4,1,ii)
plot(data_table.(ii))
title(['Responses' data_table.Properties.VariableNames(ii)])
set(gca, 'yLim', [-50 50])
hold on
end





