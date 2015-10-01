
tickSym = 'DBK.DE';     % Ticker symbol of Deutsche Bank AG (https://de.finance.yahoo.com/q/cp?s=%5EGDAXI)

% specify beginning and ending as string variables
dateBeg = '01012000';   %  first observation on first of January 2000
dateEnd = '01012015'; % Last observation on first of January 2015

dbk_data = getPrices(dateBeg, dateEnd, tickSym)

% calculating logarithmic returns
dbk_returns = price2retWithHolidays(dbk_data);

%%
dbk_returns_vec = dbk_returns.(1) % input-data must be of type 'double'
%object-specification, input for method estimate() must be of class
%GARCH(P, Q) with P = lags of GARCH and Q = lags of Arch. Here: garch(1,1)
object_specif = garch(1,1)

% estimate-method for object of class "GARCH" => calculation of process-parameters
params = estimate(object_specif, dbk_returns_vec)

garch_val = params.GARCH{1} % GARCH-parameter
arch_val = params.ARCH{1}   % ARCH-parameter

%% 

%Backtesting für sturen kritisches Wert aus NV

% critical value (alpha = 0.05) under assuption of normal distribution 

alphaLevels = 1 - [0.95];

var_norm_crit = norminv(alphaLevels, arch_val, garch_val)

% calculating innovations via "infer"

% calculate exceedances

logRets = 100*dbk_returns_vec;
nObs = length(logRets);
dats = datenum(dbk_returns.Properties.RowNames, 'yyyy-mm-dd');


figure('position', [50 50 1200 600])

scatter(dats, logRets, '.')
datetick 'x'
set(gca, 'xLim', [dats(end) dats(1)])

hold on;

line([dats(end) dats(1)], var_norm_crit*[1 1], 'Color', 'black')

exceedances = logRets < var_norm_crit;
dats_exceed = dats(exceedances);
logRets_exceed = logRets(exceedances);

plot(dats_exceed, logRets_exceed, '.r')



