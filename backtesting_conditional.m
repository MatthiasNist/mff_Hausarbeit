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
logRets = 100*dbk_returns_vec

object_specif = arima('ARLags',1,'Variance',garch(1,1))

[params output] = estimate(object_specif, logRets)
print(params,output)

% constant = params.Constant;
% ar_1 = params.AR;
% garch_val = params.Variance.GARCH{1}; % GARCH-parameter
% arch_val = params.Variance.ARCH{1};   % ARCH-parameter
% k = params.Variance.Constant; % offset labeled "k"

var = infer(params.Variance, logRets) %conditional variances
mu = infer(params, logRets) % conditional means...???

alphaLevels = 1 - [0.95];
sigma = sqrt(var) % Berechnung Standardabweichung
val_pdf_crit = norminv(alphaLevels, mu, sigma)


figure('position', [50 50 1200 600])

scatter(dats, logRets, '.')
datetick 'x'
set(gca, 'xLim', [dats(end) dats(1)])

hold on;

% line([dats(end) dats(1)], val_pdf_crit*[1 1], 'Color', 'black')

exceedances = logRets < val_pdf_crit;
dats_exceed = dats(exceedances);
logRets_exceed = logRets(exceedances);

plot(dats_exceed, logRets_exceed, '.r') % kein einziger rot....

% Plots für Varianz:

subplot(2, 1, 1)

plot(dats, logRets)

subplot(2, 1, 2)

plot(dats, var)